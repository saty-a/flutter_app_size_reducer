import 'dart:io';
import 'package:flutter_app_size_reducer/src/utils/progress_bar.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'base_command.dart';
import 'clean_command.dart';

class AnalyseCommand extends BaseCommand {
  final List<String> unusedAssets = <String>[];
  final Map<String, int> largeAssets = <String, int>{};
  CliProgress? _progress;


  @override
  String get name => 'analyse';

  @override
  String get description => 'Analyze assets and dependencies in your Flutter project';

  @override
  String getOptions() {
    return '''
  --type=<type>    Type of analysis (assets, dependencies, all)
  --config=<path>  Path to configuration file
''';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    try {
      final configFile = File('flutter_app_size_reducer.yaml');
      if (!await configFile.exists()) {
        print('Configuration file not found. Please run "dart run flutter_app_size_reducer init" first.');
        return;
      }

      final config = loadYaml(await configFile.readAsString());
      final maxAssetSize = config['config']['max-asset-size'] as int;

      print('Analyzing project assets...\n');

      // Find all assets
      final assetsDir = Directory('assets');
      if (!await assetsDir.exists()) {
        print('No assets directory found.');
        return;
      }

      // Count total files for progress bar
      int totalFiles = 0;
      await for (final _ in assetsDir.list(recursive: true)) {
        if (_ is File) totalFiles++;
      }

      if (totalFiles == 0) {
        print('No files found in assets directory.');
        return;
      }

      _progress = CliProgress(
        description: 'Scanning assets',
        totalSteps: totalFiles,
      );

      // Analyze assets
      await for (final entity in assetsDir.list(recursive: true)) {
        if (entity is File) {
          final relativePath = path.relative(entity.path, from: '.');
          final size = await entity.length();
          
          // Check if asset is used in code
          final isUsed = await _isAssetUsed(relativePath);
          if (!isUsed) {
            unusedAssets.add(relativePath);
          }
          
          // Check if asset is larger than max size
          if (size > maxAssetSize) {
            largeAssets[relativePath] = size;
          }
          
          _progress?.increment();
        }
      }

      _progress?.clear(); // Clear progress bar before showing results
      print('\n=== Analysis Results ===\n');
      
      print('Unused Assets:');
      if (unusedAssets.isEmpty) {
        print('No unused assets found.');
      } else {
        for (final asset in unusedAssets) {
          // Make the path clickable in the terminal
          print('- file://${path.absolute(asset)}');
        }
      }

      print('\nLarge Assets (>${_formatSize(maxAssetSize)}):');
      if (largeAssets.isEmpty) {
        print('No large assets found.');
      } else {
        for (final entry in largeAssets.entries) {
          // Make the path clickable in the terminal
          print('- file://${path.absolute(entry.key)} (${_formatSize(entry.value)})');
        }
      }

      if (unusedAssets.isNotEmpty) {
        print('\nWould you like to:');
        print('1. Clean unused assets');
        print('2. Exit');
        print(''); // Add a blank line for better readability
        
        final choice = stdin.readLineSync();
        switch (choice) {
          case '1':
            await CleanCommand().execute(unusedAssets);
            break;
          default:
            print('Exiting...');
        }
      }
    } finally {
      _progress?.dispose();
      _progress = null;
    }
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

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Map<String, dynamic> getResults() {
    return {
      'unusedAssets': unusedAssets,
      'largeAssets': largeAssets,
    };
  }
} 