import 'package:console_bars/console_bars.dart';

/// A wrapper class for console progress bars that provides time and percentage tracking
class CliProgress {
  late final FillingBar _progressBar;
  final String description;
  final int totalSteps;

  /// Creates a new CLI progress bar
  ///
  /// [description] - The text shown before the progress bar
  /// [totalSteps] - Total number of steps to complete
  CliProgress({
    required this.description,
    required this.totalSteps,
  }) {
    _progressBar = FillingBar(
      desc: description,
      total: totalSteps,
      time: true,
      percentage: true,
    );
  }

  /// Increments the progress by one step
  void increment() {
    _progressBar.increment();
  }

  /// Increments the progress by [steps] number of steps
  void incrementBy(int steps) {
    for (var i = 0; i < steps; i++) {
      _progressBar.increment();
    }
  }

  /// Updates the total number of steps
  void updateTotal(int newTotal) {
    _progressBar.total = newTotal;
  }

  /// Updates the description text
  void updateDescription(String newDescription) {
    _progressBar.desc = newDescription;
  }
}
