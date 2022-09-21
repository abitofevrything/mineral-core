import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildScheduledEventUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildScheduledEventCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      GuildScheduledEvent? before = guild.scheduledEvents.cache.get(payload['id']);
      GuildScheduledEvent after = GuildScheduledEvent.from(channelManager: guild.channels, memberManager: guild.members, payload: payload);
      guild.scheduledEvents.cache.set(after.id, after);

      manager.emit(event: Events.guildScheduledEventUpdate, params: [before, after]);
    }
  }
}
