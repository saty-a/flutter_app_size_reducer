import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:process_run/process_run.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('analyze', abbr: 'a', help: 'Analyze app size and get recommendations')
    ..addFlag('optimize', abbr: 'o', help: 'Optimize app size based on recommendations')
    ..addOption('config', abbr: 'c', help: 'Path to configuration file')
    ..addFlag('help', abbr: 'h', help: 'Show this help message');

  try {
    final results = parser.parse(arguments);

    if (results['help']) {
      print('Usage: flutter_app_size_reducer [options]');
      print(parser.usage);
      exit(0);
    }

    if (results['analyze']) {
      await analyzeAppSize();
    } else if (results['optimize']) {
      final configPath = results['config'];
      await optimizeAppSize(configPath);
    } else {
      print('Please specify either --analyze or --optimize');
      print(parser.usage);
      exit(1);
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}

Future<void> analyzeAppSize() async {
  print('Analyzing app size...');
  
  // Get Flutter project size
  final projectSize = await getProjectSize();
  print('Project size: ${formatSize(projectSize)}');

  // Analyze assets
  final assetsSize = await analyzeAssets();
  print('Assets size: ${formatSize(assetsSize)}');

  // Analyze dependencies
  final dependenciesSize = await analyzeDependencies();
  print('Dependencies size: ${formatSize(dependenciesSize)}');

  // Generate recommendations
  print('\nRecommendations:');
  if (assetsSize > 10 * 1024 * 1024) { // 10MB
    print('- Consider optimizing large assets');
  }
  if (dependenciesSize > 20 * 1024 * 1024) { // 20MB
    print('- Review and remove unused dependencies');
  }
}

Future<void> optimizeAppSize(String? configPath) async {
  print('Optimizing app size...');
  
  if (configPath != null) {
    final config = await loadConfig(configPath);
    // Apply optimizations based on config
  }

  // Run Flutter clean
  await run('flutter clean');

  // Remove unused assets
  await removeUnusedAssets();

  // Optimize images
  await optimizeImages();

  print('Optimization complete!');
}

Future<int> getProjectSize() async {
  final result = await run('du -sb .');
  return int.parse(result.outText.split('\t')[0]);
}

Future<int> analyzeAssets() async {
  final result = await run('du -sb assets');
  return int.parse(result.outText.split('\t')[0]);
}

Future<int> analyzeDependencies() async {
  final result = await run('du -sb .dart_tool');
  return int.parse(result.outText.split('\t')[0]);
}

Future<void> removeUnusedAssets() async {
  // Implementation for removing unused assets
}

Future<void> optimizeImages() async {
  // Implementation for image optimization
}

Future<Map<String, dynamic>> loadConfig(String configPath) async {
  final file = File(configPath);
  final contents = await file.readAsString();
  return loadYaml(contents);
}

String formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
  if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
} 