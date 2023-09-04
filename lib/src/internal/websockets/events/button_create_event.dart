import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ButtonCreateEvent<T extends PartialChannel> extends Event {
  final ButtonInteraction _interaction;

  ButtonCreateEvent(this._interaction);

  ButtonInteraction get interaction => _interaction;
  GuildMember? get sender => _interaction.member!;
  T get channel => _interaction.channel as T;
}
