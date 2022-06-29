/// The api is the Map of all the classes, enumerations of the framework
///
/// {@category Api}
library api;

export 'src/api/client/mineral_client.dart' show MineralClient, ClientActivity, ClientStatus, Intent;
export 'src/api/client/client_presence.dart' show ClientPresence, GamePresence;

export 'src/api/application.dart' show Application;
export 'src/api/user.dart' show User;
export 'src/api/status.dart' show Status;
export 'src/api/activity.dart' show Activity;
export 'src/api/guild_member.dart' show GuildMember;
export 'src/api/voice.dart' show Voice;

export 'src/api/guild.dart' show Guild;
export 'src/api/moderation_rule.dart' show ModerationEventType, ModerationTriggerType, ModerationPresetType, ModerationActionType, ModerationTriggerMetadata, ModerationActionMetadata, ModerationAction, ModerationRule;

export 'src/api/webhook.dart' show Webhook;

export 'src/api/channels/channel.dart' show Channel, ChannelType;
export 'src/api/channels/voice_channel.dart' show VoiceChannel;
export 'src/api/channels/text_based_channel.dart' show TextBasedChannel;
export 'src/api/channels/text_channel.dart' show TextChannel;
export 'src/api/channels/category_channel.dart' show CategoryChannel;

export 'src/api/message.dart' show Message;
export 'src/api/message_embed.dart' show MessageEmbed, Footer, Image, Author, Field;
export 'src/api/color.dart' show Color;

export 'src/api/emoji.dart' show Emoji;
export 'src/api/role.dart' show Role;

export 'src/api/components/row.dart' show Row;
export 'src/api/components/select_menu.dart' show SelectMenu, SelectMenuOption, EmojiOption;
export 'src/api/components/modal.dart' show Modal;
export 'src/api/components/text_input.dart' show TextInputStyle;
export 'src/api/components/button.dart' show Button, ButtonStyle;
export 'src/api/components/link.dart' show Link;

export 'src/api/interactions/command_interaction.dart' show CommandInteraction;

export 'src/api/utils.dart';
export 'src/internal/extensions/collection.dart';

typedef Snowflake = String;
