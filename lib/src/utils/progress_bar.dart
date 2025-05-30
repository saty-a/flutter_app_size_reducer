// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io' if (dart.library.html) 'dart:html' as io;

/// A progress bar utility for CLI applications.
class CliProgress {
  final String description;
  final int totalSteps;
  int _currentStep = 0;
  static const String _clearLine = '\x1B[2K\r';

  CliProgress({
    required this.description,
    required this.totalSteps,
  });

  void increment() {
    _currentStep++;
    _updateProgress();
  }

  void _updateProgress() {
    final percentage = (_currentStep / totalSteps * 100).toStringAsFixed(1);
    io.stdout.write('$description: $percentage% complete\r');
  }

  void clear() {
    io.stdout.write(_clearLine);
  }

  void dispose() {
    clear();
  }
}
