import 'dart:async';

import 'package:flutter/foundation.dart';

/// Откладывает действие, пока вызовы не прекратятся на [delay].
///
/// В лекции Debounce — синглтон со static-таймером. Здесь у каждого экрана
/// свой экземпляр: общий таймер отменял бы действия разных экранов друг другу,
/// а свой можно отменить в dispose.
class Debounce {
  Debounce({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();
}
