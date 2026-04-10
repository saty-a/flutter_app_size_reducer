import 'dart:io';

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
    stdout.write('$description: $percentage% complete\r');
  }

  void clear() {
    stdout.write(_clearLine);
  }

  void dispose() {
    clear();
  }
}
