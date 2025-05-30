import 'package:console_bars/console_bars.dart';
import 'dart:async';
import 'dart:io';

class CliProgress {
  late final FillingBar _progressBar;
  Timer? _updateTimer;
  int _currentProgress = 0;
  final int _totalSteps;
  final Stopwatch _stopwatch = Stopwatch();
  static const String _clearLine = '\x1B[2K\r'; // ANSI escape code to clear line

  CliProgress({
    required String description,
    required int totalSteps,
  }) : _totalSteps = totalSteps {
    _progressBar = FillingBar(
      desc: description,
      total: totalSteps,
      time: true,
      percentage: true,
      fill: '=',
      space: ' ',
      scale: 0.5,
    );
    _stopwatch.start();
  }

  void increment() {
    _currentProgress++;
    _progressBar.increment();
    if (_currentProgress >= _totalSteps) {
      dispose();
    }
  }

  void incrementBy(int steps) {
    _currentProgress += steps;
    for (var i = 0; i < steps; i++) {
      _progressBar.increment();
    }
    if (_currentProgress >= _totalSteps) {
      dispose();
    }
  }

  void clear() {
    stdout.write(_clearLine); // Clear the current line using ANSI escape code
  }

  void dispose() {
    _stopwatch.stop();
    _updateTimer?.cancel();
  }
}