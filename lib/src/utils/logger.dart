import 'dart:io';

/// Log level for filtering output.
enum Level { error, info }

/// A simple terminal logger for CLI applications.
class Logger {
  final Level level;

  Logger({this.level = Level.info});

  bool get _showInfo => level == Level.info;

  void info(String message) {
    if (_showInfo) stdout.writeln(message);
  }

  void success(String message) {
    if (_showInfo) stdout.writeln('\x1B[32m$message\x1B[0m');
  }

  void warn(String message) {
    if (_showInfo) stdout.writeln('\x1B[33m$message\x1B[0m');
  }

  void err(String message) {
    stderr.writeln('\x1B[31m$message\x1B[0m');
  }

  /// Start a progress indicator. Call [Progress.complete] or [Progress.fail]
  /// when done.
  Progress progress(String message) {
    return Progress._(message);
  }

  /// Prompt the user for a yes/no answer.
  Future<bool> confirm(String message, {bool defaultValue = false}) async {
    final hint = defaultValue ? 'Y/n' : 'y/N';
    stdout.write('$message ($hint): ');
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    if (input.isEmpty) return defaultValue;
    return input == 'y' || input == 'yes';
  }

  /// Prompt the user to select one option from a list.
  String chooseOne(
    String message, {
    required List<String> choices,
    String? defaultValue,
  }) {
    stdout.writeln(message);
    for (var i = 0; i < choices.length; i++) {
      final marker = choices[i] == defaultValue ? '> ' : '  ';
      stdout.writeln('$marker${i + 1}. ${choices[i]}');
    }
    final defaultIndex =
        defaultValue != null ? choices.indexOf(defaultValue) : -1;
    while (true) {
      final hint = defaultIndex >= 0 ? ' [${defaultIndex + 1}]' : '';
      stdout.write('Enter choice$hint: ');
      final input = stdin.readLineSync()?.trim() ?? '';
      if (input.isEmpty && defaultValue != null) return defaultValue;
      final index = int.tryParse(input);
      if (index != null && index >= 1 && index <= choices.length) {
        return choices[index - 1];
      }
      stdout.writeln(
          'Invalid choice, please enter a number between 1 and ${choices.length}.');
    }
  }

  /// Prompt the user to select multiple options from a list.
  List<String> chooseAny(
    String message, {
    required List<String> choices,
    List<String>? defaultValues,
  }) {
    stdout.writeln('$message (comma-separated numbers, e.g. 1,3):');
    for (var i = 0; i < choices.length; i++) {
      final isDefault = defaultValues?.contains(choices[i]) ?? false;
      final marker = isDefault ? '* ' : '  ';
      stdout.writeln('$marker${i + 1}. ${choices[i]}');
    }
    stdout.write('Enter choices: ');
    final input = stdin.readLineSync()?.trim() ?? '';
    if (input.isEmpty) return defaultValues ?? [];
    return input
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .where((i) => i != null && i >= 1 && i <= choices.length)
        .map((i) => choices[i! - 1])
        .toList();
  }
}

/// A progress indicator that prints dots while work is in progress.
class Progress {
  final String _message;
  bool _done = false;

  Progress._(this._message) {
    stdout.write('$_message...');
  }

  /// Mark the progress as complete with an optional success message.
  void complete([String? message]) {
    if (_done) return;
    _done = true;
    stdout.writeln(' \x1B[32m${message ?? 'done'}\x1B[0m');
  }

  /// Mark the progress as failed with an optional error message.
  void fail([String? message]) {
    if (_done) return;
    _done = true;
    stdout.writeln(' \x1B[31m${message ?? 'failed'}\x1B[0m');
  }
}
