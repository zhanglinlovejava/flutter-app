import 'package:event_bus/event_bus.dart';
import 'dart:async';
class EventUtils {
  static EventBus _bus = EventBus();

  static StreamSubscription<T> on<T>(Function function) {
    StreamSubscription<T> ss = _bus.on<T>().listen((event) {
      if (function != null) {
        function(event);
      }
    });
    return ss;
  }

  static void fire<T>(T t) {
    _bus.fire(t);
  }

  static void off(StreamSubscription ss) {
    if (ss != null) ss.cancel();
  }
}
