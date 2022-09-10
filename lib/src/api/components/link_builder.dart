import 'package:mineral/src/api/components/component.dart';

class LinkBuilder extends Component {
  String label;
  String url;
  int style = 5;

  LinkBuilder({ required this.label, required this.url }) : super(type: ComponentType.button);

  @override
  dynamic toJson () {
    return {
      'type': type.value,
      'label': label,
      'style': style,
      'url': url,
    };
  }

  factory LinkBuilder.from({ required dynamic payload }) {
    return LinkBuilder(
      url: payload['url'],
      label: payload['label'],
    );
  }
}