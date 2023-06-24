import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

import '../../../../core/builders.dart';

class MessageReactionAddEvent extends Event {
  final Guild? guild;
  final TextBasedChannel? channel;
  final Message message;
  final User user;
  final GuildMember? member;
  final EmojiBuilder emoji;

  MessageReactionAddEvent(
    this.guild,
    this.channel,
    this.message,
    this.user,
    this.member,
    this.emoji,);
}
