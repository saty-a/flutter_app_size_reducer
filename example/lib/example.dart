import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';

/// Demonstrates programmatic use of flutter_app_size_reducer.
///
/// Run from the root of your Flutter project:
///   dart run flutter_app_size_reducer:flutter_app_size_reducer <command>
///
/// Or use the library API directly in your own Dart scripts:
Future<void> main() async {
  // 1. Initialize — creates flutter_app_size_reducer.yaml with defaults.
  //    Pass --force to overwrite an existing config file.
  await FlutterAppSizeReducer.init();

  // 2. Analyze assets and dependencies.
  //    Results are printed to the console; the returned map is for
  //    programmatic use in CI pipelines or custom tooling.
  final results = await FlutterAppSizeReducer.analyze();
  print('Asset analysis: ${results['assets']}');

  // 3. Remove unused assets.
  //    dryRun: true  → preview deletions without removing anything.
  //    force: true   → skip the interactive confirmation prompt.
  await FlutterAppSizeReducer.clean(dryRun: true);

  // 4. Compress large images to reduce app bundle size.
  //    quality: JPEG compression level 1–100 (default 85).
  await FlutterAppSizeReducer.optimize(quality: 80, dryRun: true);
}
