import 'package:mineral/core/builders.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/collectors/interaction_collector.dart';
import 'package:mineral/src/internal/entities/interactive_components/interactive_component.dart';

abstract class InteractiveDynamicMenu extends InteractiveComponent<DynamicSelectMenuBuilder, DynamicMenuCreateEvent> {
  InteractiveDynamicMenu(super.customId, { bool standalone = false }) {
    if (standalone) {
      InteractionCollector<DynamicMenuCreateEvent>(customId).collect().then((value) async {
        await handle(value);
      });
    }
  }
}