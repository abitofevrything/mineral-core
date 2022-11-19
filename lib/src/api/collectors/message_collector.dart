import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral/src/internal/managers/collector_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class MessageCollector extends Collector with Container {
  final Map<Snowflake, Message> _messages = {};
  StreamSubscription? subscription;

  final bool Function(Message message) _filter;
  final int? _max;
  Duration? _time;

  MessageCollector (this._filter, this._max, this._time): super(MessageCreateEvent) {
    container.use<CollectorManager>().subscribe(this);
  }

  @override
  Future<dynamic> collect () async {
    final completer = Completer();
    subscription = controller.stream.listen((message) async {
      if (_filter(message)) {
        _messages.putIfAbsent(message.id, () => message);
      }

      if (_messages.length == _max) {
        await _unsubscribe();
        completer.complete(_messages);
      }
    });

    return completer.future;
  }

  Future<void> _unsubscribe () async {
    container.use<CollectorManager>().unsubscribe(this);
    await subscription?.cancel();
  }
}