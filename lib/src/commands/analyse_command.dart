import 'dart:convert';
import 'dart:io';
import 'base_command.dart';
import 'analyze_dependencies_command.dart';

/// Command to run various analyses on the Flutter project
class AnalyseCommand extends BaseCommand {
  @override
  String get name => 'analyse';

  @override
  String get description =>
      'Analyze assets, dependencies, and code in your Flutter project';

  @override
  String getOptions() {
    return '''
  --type=<type>    Type of analysis (assets, dependencies, all) [default: all]
  --json           Output in JSON format
  --export=<path>  Export report to file (JSON format)
''';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    String analysisType = 'all';
    String? exportPath;

    // Parse arguments manually since they come as strings
    for (final arg in args) {
      if (arg.startsWith('--type=')) {
        analysisType = arg.substring(7); // Remove '--type='
      } else if (arg.startsWith('--export=')) {
        exportPath = arg.substring(9); // Remove '--export='
      }
    }

    if (!['assets', 'dependencies', 'all'].contains(analysisType)) {
      printError('Invalid analysis type: $analysisType');
      printInfo('Valid types: assets, dependencies, all');
      return;
    }

    printInfo('🔍 Running Analysis...\n');

    final results = <String, dynamic>{};

    // Run asset analysis
    if (analysisType == 'assets' || analysisType == 'all') {
      final assetResults = await _analyzeAssets();
      results['assets'] = assetResults;
    }

    // Run dependency analysis
    if (analysisType == 'dependencies' || analysisType == 'all') {
      final depCommand = AnalyzeDependenciesCommand();
      depCommand.initLogger(jsonOutput: jsonOutput, useColors: useColors);

      printInfo('\n');
      await depCommand.execute(args);
    }

    // Export if requested
    if (exportPath != null) {
      await _exportResults(results, exportPath);
    }

    if (!jsonOutput) {
      printSuccess('\n✅ Analysis complete!');
    }
  }

  Future<Map<String, dynamic>> _analyzeAssets() async {
    printInfo('📦 Analyzing Assets...\n');

    final assetsDir = Directory('assets');
    if (!await assetsDir.exists()) {
      printWarning('No assets directory found.');
      return {
        'total': 0,
        'unused': [],
        'large': {},
        'totalSize': 0,
      };
    }

    final allAssets = <String>[];
    final unusedAssets = <String>[];
    final largeAssets = <String, int>{};
    int totalSize = 0;
    final maxAssetSize = 1048576; // 1MB default

    final progress = createProgress('Scanning assets');

    await for (final entity in assetsDir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = entity.path;
        final size = await entity.length();
        totalSize += size;

        allAssets.add(relativePath);

        // Check if used
        final isUsed = await _isAssetUsed(relativePath);
        if (!isUsed) {
          unusedAssets.add(relativePath);
        }

        // Check if large
        if (size > maxAssetSize) {
          largeAssets[relativePath] = size;
        }
      }
    }

    progress.complete('Found ${allAssets.length} assets');

    if (!jsonOutput) {
      printInfo('Total assets: ${allAssets.length}');
      printInfo('Total size: ${_formatSize(totalSize)}');

      if (unusedAssets.isNotEmpty) {
        printWarning('\n⚠️  Unused assets: ${unusedAssets.length}');
        for (final asset in unusedAssets.take(5)) {
          logger.info('  • $asset');
        }
        if (unusedAssets.length > 5) {
          logger.info('  ... and ${unusedAssets.length - 5} more');
        }
      } else {
        printSuccess('\n✓ No unused assets found!');
      }

      if (largeAssets.isNotEmpty) {
        printWarning(
            '\n⚠️  Large assets (>${_formatSize(maxAssetSize)}): ${largeAssets.length}');
        for (final entry in largeAssets.entries.take(5)) {
          logger.info('  • ${entry.key} (${_formatSize(entry.value)})');
        }
        if (largeAssets.length > 5) {
          logger.info('  ... and ${largeAssets.length - 5} more');
        }
      }
    }

    return {
      'total': allAssets.length,
      'unused': unusedAssets,
      'large': largeAssets,
      'totalSize': totalSize,
    };
  }

  Future<bool> _isAssetUsed(String assetPath) async {
    final libDir = Directory('lib');
    if (!await libDir.exists()) return false;

    final assetName = assetPath.split('/').last;

    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = await entity.readAsString();
        if (content.contains(assetPath) || content.contains(assetName)) {
          return true;
        }
      }
    }

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
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Future<void> _exportResults(Map<String, dynamic> results, String path) async {
    try {
      final file = File(path);
      await file.writeAsString(json.encode(results));
      printSuccess('Report exported to: $path');
    } catch (e) {
      printError('Failed to export report: $e');
    }
  }
}
