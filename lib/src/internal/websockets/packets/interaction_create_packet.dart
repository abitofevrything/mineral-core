import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/component_builder.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/events/interaction_create_event.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class InteractionCreatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = container.use<EventManager>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['member']['user']['id']);

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.chatInput.value) {
      _executeCommandInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.user.value) {
      _executeContextMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.applicationCommand.value && payload['data']['type'] == ApplicationCommandType.message.value) {
      _executeContextMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value && payload['data']['component_type'] == ComponentType.button.value) {
      _executeButtonInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.messageComponent.value && payload['data']['component_type'] == ComponentType.selectMenu.value) {
      _executeSelectMenuInteraction(guild!, member!, payload);
    }

    if (payload['type'] == InteractionType.modalSubmit.value) {
      _executeModalInteraction(guild!, member!, payload);
    }

    if (member != null) {
      final Interaction interaction = Interaction.from(payload: payload);
      eventManager.controller.add(InteractionCreateEvent(interaction));
    }
  }

  _executeCommandInteraction (Guild guild, GuildMember member, dynamic payload) {
    CommandInteraction interaction = CommandInteraction.fromPayload(payload);
    container.use<CommandManager>().controller.add(CommandCreateEvent(interaction));
  }

  _executeContextMenuInteraction (Guild guild, GuildMember member, dynamic payload) async {
    if (payload['data']?['type'] == ApplicationCommandType.user.value) {
      final interaction = ContextUserInteraction.from(payload: payload );
      container.use<ContextMenuManager>().controller.add(interaction);
    }

    if (payload['data']?['type'] == ApplicationCommandType.message.value) {
      TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
      Message? message = channel?.messages.cache.get(payload['data']?['target_id']);

      if (message == null) {
        Response response = await container.use<Http>().get(url: '/channels/${payload['channel_id']}/messages/${payload['data']?['target_id']}');
        if (response.statusCode == 200) {
          message = Message.from(channel: channel!, payload: jsonDecode(response.body));
          channel.messages.cache.putIfAbsent(message.id, () => message!);
        }
      }

      final interaction = ContextMessageInteraction.from(message: message!, payload: payload);
      container.use<ContextMenuManager>().controller.add(interaction);
    }
  }

  _executeButtonInteraction (Guild guild, GuildMember member, dynamic payload) async {
    if (payload['guild_id'] == null) {
        return;
    }

    EventManager eventManager = container.use<EventManager>();

    dynamic channel = guild.channels.cache.get(payload['channel_id']);
    if (channel == null) {
      final Response response = await container.use<Http>().get(url: '/channels/${payload['channel_id']}');
      channel = ChannelWrapper.create(jsonDecode(response.body));

      guild.channels.cache.putIfAbsent(channel.id, () => channel);
    }

    Message? message = channel?.messages.cache[payload['message']['id']];
    if (message == null) {
      final Response response = await container.use<Http>().get(url: '/channels/${payload['channel_id']}/messages/${payload['message']?['id']}');
      message = Message.from(channel: channel, payload: jsonDecode(response.body));

      channel.messages.cache.putIfAbsent(message.id, () => message!);
    }

    ButtonInteraction buttonInteraction = ButtonInteraction.fromPayload(payload);
    eventManager.controller.add(ButtonCreateEvent(buttonInteraction));
  }

  _executeModalInteraction (Guild guild, GuildMember member, dynamic payload) {
    EventManager eventManager = container.use<EventManager>();
    ModalInteraction modalInteraction = ModalInteraction.from(payload: payload);

    for (dynamic row in payload['data']['components']) {
      for (dynamic component in row['components']) {
        modalInteraction.data.putIfAbsent(component['custom_id'], () => component['value']);
      }
    }

    eventManager.controller.add(ModalCreateEvent(modalInteraction));
  }

  void _executeSelectMenuInteraction (Guild guild, GuildMember member, dynamic payload) {
    EventManager eventManager = container.use<EventManager>();
    TextBasedChannel? channel = guild.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['message']['id']);

    SelectMenuInteraction interaction = SelectMenuInteraction.from(
      message: message,
      payload: payload,
    );

    for (dynamic value in payload['data']['values']) {
      interaction.data.add(value);
    }

    eventManager.controller.add(SelectMenuCreateEvent(interaction));
  }
}