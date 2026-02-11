/// A command-line tool to analyze and reduce Flutter app size by managing assets and dependencies.
///
/// This package provides functionality to:
/// * Analyze app assets and identify unused or large files
/// * Clean unused assets safely
/// * Optimize large assets to reduce app size
/// * Configure behavior through a YAML file
///
/// Example:
/// ```dart
/// import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';
///
/// void main() async {
///   // Initialize configuration
///   await FlutterAppSizeReducer.init();
///
///   // Analyze assets
///   final results = await FlutterAppSizeReducer.analyze();
///
///   // Clean unused assets
///   await FlutterAppSizeReducer.clean(dryRun: true);
///
///   // Optimize large assets
///   await FlutterAppSizeReducer.optimize(quality: 80);
/// }
/// ```
library flutter_app_size_reducer;

import 'src/commands/analyse_command.dart';
import 'src/commands/clean_command.dart';
import 'src/commands/init_command.dart';
import 'src/commands/optimize_command.dart';

export 'src/commands/analyse_command.dart';
export 'src/commands/clean_command.dart';
export 'src/commands/init_command.dart';
export 'src/commands/analyze_dependencies_command.dart';
export 'src/commands/base_command.dart';
export 'src/services/dependency_analyzer.dart';
export 'src/models/config_model.dart';
export 'src/utils/config_loader.dart';

/// The main class for the Flutter App Size Reducer package.
///
/// This class provides static methods to access the package's functionality
/// programmatically, as an alternative to using the command-line interface.
class FlutterAppSizeReducer {
  /// Initialize the configuration file.
  ///
  /// Creates a new configuration file with default settings if it doesn't exist.
  /// If the file already exists, it will be overwritten only if confirmed.
  static Future<void> init() async {
    await InitCommand().execute();
  }

  /// Analyze assets in the current project.
  ///
  /// Scans the project for unused assets and large files that could be optimized.
  /// Returns a map containing the analysis results.
  static Future<Map<String, dynamic>> analyze() async {
    final command = AnalyseCommand();
    command.initLogger();
    await command.execute();
    return {}; // Analysis results are printed to console
  }

  /// Clean unused assets from the project.
  ///
  /// [dryRun] - If true, only show what would be deleted without actually deleting.
  /// [force] - If true, skip confirmation prompt.
  static Future<void> clean({bool dryRun = false, bool force = false}) async {
    final args = <String>[];
    if (dryRun) args.add('--dry-run');
    if (force) args.add('--force');
    await CleanCommand().execute(args);
  }

  /// Optimize large assets in the project.
  ///
  /// [quality] - JPEG quality for image optimization (1-100, default: 85).
  /// [dryRun] - If true, only show what would be optimized without actually optimizing.
  /// [force] - If true, skip confirmation prompt.
  static Future<void> optimize({
    int quality = 85,
    bool dryRun = false,
    bool force = false,
  }) async {
    final args = <String>[];
    if (quality != 85) args.add('--quality=$quality');
    if (dryRun) args.add('--dry-run');
    if (force) args.add('--force');
    await OptimizeCommand().execute(args);
  }
}
