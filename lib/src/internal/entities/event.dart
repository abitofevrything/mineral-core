import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

class Event {
  final Events event;
  final String? customId;

  const Event(this.event, { this.customId });
}

abstract class MineralEvent {
  late StoreManager stores;
  late MineralClient client;
  late Environment environment;
}

enum Events {
  ready('ready', { 'client': MineralClient }),
  guildCreate('create::guild', { 'guild': Guild }),
  guildUpdate('update::guild', { 'before': Guild, 'after': Guild }),
  presenceUpdate('update::presence', { 'before': GuildMember, 'after': GuildMember }),

  moderationRuleCreate('create::moderation-rule', { 'rule': ModerationRule }),
  moderationRuleUpdate('update::moderation-rule', { 'before': ModerationRule, 'after': ModerationRule }),
  moderationRuleDelete('delete::moderation-rule', { 'rule': ModerationRule }),

  guildScheduledEventCreate('create::scheduled-event', { 'event': GuildScheduledEvent }),
  guildScheduledEventDelete('delete::scheduled-event', { 'event': GuildScheduledEvent }),
  guildScheduledEventUpdate('update::scheduled-event', { 'before': GuildScheduledEvent, 'after': GuildScheduledEvent }),
  guildScheduledEventUserAdd('user-add::scheduled-event', { 'event': GuildScheduledEvent, 'user': User, 'member': 'GuildMember?' }),
  guildScheduledEventUserRemove('user-remove::scheduled-event', { 'event': GuildScheduledEvent, 'user': User, 'member': 'GuildMember?' }),

  messageCreate('create::message', { 'message': Message }),
  messageUpdate('update::message', { 'before': Message, 'after': Message }),
  messageDelete('delete::message', { 'message': Message }),

  channelCreate('create::channel', { 'channel': GuildChannel }),
  channelUpdate('update::channel', { 'before': GuildChannel, 'after': GuildChannel }),
  channelDelete('delete::channel', { 'channel': GuildChannel }),

  memberJoin('join::member', { 'member': GuildMember }),
  memberUpdate('update::member', { 'before': GuildMember, 'after': GuildMember }),
  memberLeave('leave::member', { 'member': GuildMember }),
  memberRolesUpdate('update::roles-member', { 'before': Role, 'after': Role }),
  acceptRules('accept::rules', { 'member': GuildMember }),

  interactionCreate('create::interaction', { 'interaction': Interaction }),
  commandCreate('create::commandInteraction', { 'interaction': CommandInteraction }),
  buttonCreate('create::buttonInteraction', { 'interaction': ButtonInteraction }),
  modalCreate('create::modalInteraction', { 'interaction': ModalInteraction }),
  selectMenuCreate('create::selectMenuInteraction', { 'interaction': SelectMenuInteraction }),

  voiceStateUpdate('update::voice', { 'before': VoiceManager, 'after': VoiceManager }),
  voiceConnect('connect::voice', { 'member': GuildMember, 'before': 'VoiceChannel?', 'after': VoiceChannel }),
  voiceDisconnect('disconnect::voice', { 'member': GuildMember, 'channel': VoiceChannel }),
  voiceMove('move::voice', { 'member': GuildMember, 'before': VoiceChannel, 'after': VoiceChannel}),
  memberMuted('mute::voice', { 'member': GuildMember }),
  memberUnMuted('unmute::voice', { 'member': GuildMember }),
  memberDeaf('deaf::voice', { 'member': GuildMember }),
  memberUnDeaf('undeaf::voice', { 'member': GuildMember }),
  memberSelfMuted('self::mute::voice', { 'member': GuildMember }),
  memberSelfUnMuted('self::unmute::voice', { 'member': GuildMember }),
  memberSelfDeaf('self::deaf::voice', { 'member': GuildMember }),
  memberSelfUnDeaf('self::undeaf::voice', { 'member': GuildMember });

  final String event;
  final Map<String, dynamic> params;
  const Events(this.event, this.params);
}
