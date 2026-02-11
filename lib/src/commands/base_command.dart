import 'package:mason_logger/mason_logger.dart';

/// Base class for all commands in the flutter_app_size_reducer CLI.
///
/// This abstract class provides common functionality for all commands including:
/// - Logger management with configurable output formats (JSON, colored terminal)
/// - User interaction helpers (confirmations, choices, progress indicators)
/// - Consistent error handling and messaging
///
/// ## Usage Example
///
/// ```dart
/// class MyCommand extends BaseCommand {
///   @override
///   String get name => 'my-command';
///
///   @override
///   String get description => 'Does something useful';
///
///   @override
///   String getOptions() => '--option=<value>  Description';
///
///   @override
///   Future<void> execute([List<String> args = const []]) async {
///     printInfo('Starting...');
///     final progress = createProgress('Processing');
///     // ... do work
///     progress.complete('Done!');
///   }
/// }
/// ```
///
/// ## Design Pattern
///
/// This class follows the Template Method pattern where:
/// - Base class provides infrastructure (logging, user interaction)
/// - Subclasses implement specific command logic (execute, options)
///
/// ## SOLID Principles
///
/// - **Single Responsibility**: Handles ONLY command infrastructure
/// - **Open/Closed**: Open for extension (new commands), closed for modification
/// - **Liskov Substitution**: All commands can substitute BaseCommand
abstract class BaseCommand {
  /// The command name used in CLI (e.g., 'init', 'analyse', 'clean').
  ///
  /// This name is used when invoking the command:
  /// ```bash
  /// fasr <name> [options]
  /// ```
  String get name;

  /// The human-readable description of what this command does.
  ///
  /// Displayed in help text and command listings.
  String get description;

  /// The logger instance for all output operations.
  ///
  /// Use this for:
  /// - `logger.info()` - Regular messages
  /// - `logger.success()` - Success messages (green)
  /// - `logger.warn()` - Warnings (yellow)
  /// - `logger.err()` - Errors (red)
  /// - `logger.progress()` - Progress indicators
  Logger get logger => _logger;
  late final Logger _logger;

  /// Whether to output in JSON format instead of human-readable text.
  ///
  /// When true:
  /// - Disables colored output
  /// - Suppresses progress indicators
  /// - Returns structured JSON data
  /// - Useful for CI/CD integration
  bool get jsonOutput => _jsonOutput;
  bool _jsonOutput = false;

  /// Whether to use ANSI colors in terminal output.
  ///
  /// When false:
  /// - No color codes are emitted
  /// - Useful for logs and non-terminal environments
  bool get useColors => _useColors;
  bool _useColors = true;

  /// Initialize the command with a logger instance.
  ///
  /// Must be called before using any logger methods.
  ///
  /// Parameters:
  /// - [jsonOutput]: If true, configures logger for JSON output
  /// - [useColors]: If true, enables colored terminal output
  ///
  /// Example:
  /// ```dart
  /// final command = MyCommand();
  /// command.initLogger(jsonOutput: false, useColors: true);
  /// await command.execute();
  /// ```
  void initLogger({bool jsonOutput = false, bool useColors = true}) {
    _jsonOutput = jsonOutput;
    _useColors = useColors;
    _logger = Logger(
      level: jsonOutput ? Level.error : Level.info,
    );
  }

  /// Get command-specific options help text.
  ///
  /// Returns a formatted string describing the command's options.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// String getOptions() {
  ///   return '''
  ///   --type=<type>    Analysis type (assets, dependencies, all)
  ///   --export=<path>  Export report to file
  ///   ''';
  /// }
  /// ```
  String getOptions();

  /// Execute the command with the given arguments.
  ///
  /// This is the main entry point for command execution.
  ///
  /// Parameters:
  /// - [args]: Command-specific arguments (e.g., ['--type=dependencies'])
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Future<void> execute([List<String> args = const []]) async {
  ///   printInfo('Starting analysis...');
  ///   // Parse args and perform operation
  ///   printSuccess('Complete!');
  /// }
  /// ```
  Future<void> execute([List<String> args = const []]);

  /// Print usage information for this command.
  ///
  /// Displays:
  /// - Command name and usage pattern
  /// - Description
  /// - Available options
  void printUsage() {
    logger.info('''
Usage: fasr $name [options]

$description

Options:
${getOptions()}
''');
  }

  // ----- Helper Methods for Output -----

  /// Print an error message (red text).
  ///
  /// Use for critical errors that prevent operation from completing.
  ///
  /// Example:
  /// ```dart
  /// printError('Configuration file not found');
  /// ```
  void printError(String message) {
    logger.err(message);
  }

  /// Print a success message (green text with checkmark).
  ///
  /// Use for successful completion of operations.
  ///
  /// Example:
  /// ```dart
  /// printSuccess('Analysis complete!');
  /// ```
  void printSuccess(String message) {
    logger.success(message);
  }

  /// Print a warning message (yellow text with warning icon).
  ///
  /// Use for non-critical issues that user should be aware of.
  ///
  /// Example:
  /// ```dart
  /// printWarning('No assets directory found');
  /// ```
  void printWarning(String message) {
    logger.warn(message);
  }

  /// Print an informational message.
  ///
  /// Use for general progress updates and information.
  ///
  /// Example:
  /// ```dart
  /// printInfo('Scanning dependencies...');
  /// ```
  void printInfo(String message) {
    logger.info(message);
  }

  // ----- Helper Methods for User Interaction -----

  /// Create a progress indicator for long-running operations.
  ///
  /// Returns a [Progress] object that can be completed or failed.
  ///
  /// Example:
  /// ```dart
  /// final progress = createProgress('Analyzing dependencies');
  /// // ... do work
  /// progress.complete('Found 13 dependencies');
  /// // OR
  /// progress.fail('Analysis failed');
  /// ```
  Progress createProgress(String message) {
    return logger.progress(message);
  }

  /// Ask for user confirmation (yes/no question).
  ///
  /// Parameters:
  /// - [message]: The question to ask
  /// - [defaultValue]: Default answer if user just presses Enter
  ///
  /// Returns true if user confirms, false otherwise.
  ///
  /// Note: In JSON mode, automatically returns [defaultValue].
  ///
  /// Example:
  /// ```dart
  /// if (await confirm('Delete unused assets?', defaultValue: false)) {
  ///   // User confirmed, proceed with deletion
  /// }
  /// ```
  Future<bool> confirm(String message, {bool defaultValue = false}) async {
    if (jsonOutput) return defaultValue;
    return logger.confirm(message, defaultValue: defaultValue);
  }

  /// Prompt user to choose one option from a list.
  ///
  /// Parameters:
  /// - [message]: Question to display
  /// - [choices]: List of available options
  /// - [defaultValue]: Default selection
  ///
  /// Returns the selected choice.
  ///
  /// Note: In JSON mode, returns [defaultValue] or first choice.
  ///
  /// Example:
  /// ```dart
  /// final format = chooseOne(
  ///   'Select output format:',
  ///   ['json', 'markdown', 'html'],
  ///   defaultValue: 'markdown',
  /// );
  /// ```
  String chooseOne(
    String message,
    List<String> choices, {
    String? defaultValue,
  }) {
    if (jsonOutput) return defaultValue ?? choices.first;
    return logger.chooseOne(
      message,
      choices: choices,
      defaultValue: defaultValue,
    );
  }

  /// Prompt user to choose multiple options from a list.
  ///
  /// Parameters:
  /// - [message]: Question to display
  /// - [choices]: List of available options
  /// - [defaultValues]: Default selections
  ///
  /// Returns list of selected choices.
  ///
  /// Note: In JSON mode, returns [defaultValues] or empty list.
  ///
  /// Example:
  /// ```dart
  /// final formats = chooseAny(
  ///   'Select image formats to optimize:',
  ///   ['png', 'jpg', 'gif', 'webp'],
  ///   defaultValues: ['png', 'jpg'],
  /// );
  /// ```
  List<String> chooseAny(
    String message,
    List<String> choices, {
    List<String>? defaultValues,
  }) {
    if (jsonOutput) return defaultValues ?? [];
    return logger.chooseAny(
      message,
      choices: choices,
      defaultValues: defaultValues,
    );
  }
}
