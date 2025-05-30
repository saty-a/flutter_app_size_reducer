import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'base_command.dart';
import '../utils/progress_bar.dart';

class CleanCommand extends BaseCommand {
  @override
  String get name => 'clean';

  @override
  String get description => 'Clean unused assets';

  @override
  String getOptions() {
    return '''
  --dry-run    Show what would be deleted without actually deleting
  --force      Skip confirmation prompt
''';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    final dryRun = args.contains('--dry-run');
    final force = args.contains('--force');

    final configFile = File('flutter_app_size_reducer.yaml');
    if (!await configFile.exists()) {
      print(
          'Configuration file not found. Please run "flutter_app_size_reducer init" first.');
      return;
    }

    final config = loadYaml(await configFile.readAsString());
    final excludeExtensions =
        List<String>.from(config['config']['exclude-extensions'] ?? []);
    final excludePaths =
        List<String>.from(config['config']['exclude-paths'] ?? []);

    final assetsDir = Directory('assets');
    if (!await assetsDir.exists()) {
      print('No assets directory found.');
      return;
    }

    final progress = CliProgress(
      description: 'Scanning assets',
      totalSteps: 100,
    );

    final unusedAssets = <String>[];

    await for (final entity in assetsDir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = path.relative(entity.path, from: '.');

        // Skip excluded extensions and paths
        if (excludeExtensions.any((ext) => relativePath.endsWith('.$ext')) ||
            excludePaths.any((path) => relativePath.startsWith(path))) {
          continue;
        }

        // Check if asset is used
        final isUsed = await _isAssetUsed(relativePath);
        if (!isUsed) {
          unusedAssets.add(relativePath);
        }

        progress.increment();
      }
    }

    if (unusedAssets.isEmpty) {
      print('\nNo unused assets found.');
      return;
    }

    print('\nFound ${unusedAssets.length} unused assets:');
    for (final asset in unusedAssets) {
      print('- $asset');
    }

    if (dryRun) {
      print('\nThis was a dry run. No files were deleted.');
      return;
    }

    if (!force) {
      print('\nDo you want to delete these files? (y/N)');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y') {
        print('Operation cancelled.');
        return;
      }
    }

    print('\nDeleting unused assets...');
    for (final asset in unusedAssets) {
      try {
        await File(asset).delete();
        print('Deleted: $asset');
      } catch (e) {
        print('Error deleting $asset: $e');
      }
    }
    print('\nCleanup completed.');
  }

  Future<bool> _isAssetUsed(String assetPath) async {
    final libDir = Directory('lib');
    if (!await libDir.exists()) return false;

    final assetName = path.basename(assetPath);
    final assetPathWithoutExt = path.withoutExtension(assetPath);

    // Search in Dart files
    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = await entity.readAsString();

        // Check for direct asset references
        if (content.contains("'$assetPath'") ||
            content.contains('"$assetPath"') ||
            content.contains("'$assetName'") ||
            content.contains('"$assetName"') ||
            content.contains("'$assetPathWithoutExt'") ||
            content.contains('"$assetPathWithoutExt"')) {
          return true;
        }
      }
    }

    // Check pubspec.yaml for asset declarations
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      if (content.contains(assetPath) || content.contains(assetName)) {
        return true;
      }
    }

    return false;
  }
}
