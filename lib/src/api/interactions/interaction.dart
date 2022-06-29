import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

enum InteractionCallbackType {
  pong(1),
  channelMessageWithSource(4),
  deferredChannelMessageWithSource(5),
  deferredUpdateMessage(6),
  updateMessage(7),
  applicationCommandAutocompleteResult(8),
  modal(9);

  final int value;
  const InteractionCallbackType(this.value);
}

class Interaction {
  Snowflake id;
  Snowflake applicationId;
  int version;
  InteractionType type;
  String token;
  User user;
  Guild? guild;


  Interaction({ required this.id, required this.applicationId, required this.version, required this.type, required this.token, required this.user });

  Future<void> reply ({ String? content, List<MessageEmbed>? embeds, List<Row>? components, bool? tts, bool? private }) async {
    Http http = ioc.singleton(ioc.services.http);

    List<dynamic> embedList = [];
    if (embeds != null) {
      for (MessageEmbed element in embeds) {
        embedList.add(element.toJson());
      }
    }

    List<dynamic> componentList = [];
    if (components != null) {
      for (Row element in components) {
        componentList.add(element.toJson());
      }
    }

    await http.post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.channelMessageWithSource.value,
      'data': {
        'tts': tts ?? false,
        'content': content,
        'embeds': embeds != null ? embedList : [],
        'components': components != null ? componentList : [],
        'flags': private != null && private == true ? 1 << 6 : null,
      }
    });
  }

  Future<void> modal (Modal modal) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.post(url: "/interactions/$id/$token/callback", payload: {
      'type': InteractionCallbackType.modal.value,
      'data': modal.toJson(),
    });

    print(response.body);
  }
}
