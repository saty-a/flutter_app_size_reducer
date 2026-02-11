import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:console_bars/console_bars.dart';
import 'base_command.dart';
import '../utils/config_loader.dart';

class OptimizeCommand extends BaseCommand {
  @override
  String get name => 'optimize';

  @override
  String get description => 'Optimize large assets';

  @override
  String getOptions() {
    return '''
  --dry-run    Show what would be optimized without actually optimizing
  --force      Skip confirmation prompt
  --quality=<n> Set JPEG quality (1-100, default: 85)
''';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    final dryRun = args.contains('--dry-run');
    final force = args.contains('--force');

    // Parse quality parameter
    int quality = 85;
    for (final arg in args) {
      if (arg.startsWith('--quality=')) {
        final qualityStr = arg.split('=')[1];
        quality = int.tryParse(qualityStr) ?? 85;
        if (quality < 1 || quality > 100) {
          print('Invalid quality value. Using default: 85');
          quality = 85;
        }
      }
    }

    // Load configuration
    try {
      final config = await ConfigLoader.load();
      final maxAssetSize = config.assets.maxAssetSize;
      final excludeExtensions = config.assets.excludeExtensions;
      final excludePaths = config.assets.excludePaths;

      final assetsDir = Directory('assets');
      if (!await assetsDir.exists()) {
        printWarning('No assets directory found.');
        return;
      }

    final progress = CliProgress(
      description: 'Scanning assets',
      totalSteps: 100,
    );

    final largeAssets = <String, int>{};

    await for (final entity in assetsDir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = path.relative(entity.path, from: '.');
        final extension =
            path.extension(relativePath).toLowerCase().replaceAll('.', '');

        // Skip excluded extensions and paths
        if (excludeExtensions.contains(extension) ||
            excludePaths.any((path) => relativePath.startsWith(path))) {
          continue;
        }

        final size = await entity.length();
        if (size > maxAssetSize) {
          largeAssets[relativePath] = size;
        }

        progress.increment();
      }
    }

    if (largeAssets.isEmpty) {
      print('\nNo large assets found.');
      return;
    }

    print('\nFound ${largeAssets.length} large assets:');
    for (final entry in largeAssets.entries) {
      print('- ${entry.key} (${_formatSize(entry.value)})');
    }

    if (dryRun) {
      print('\nThis was a dry run. No files were optimized.');
      return;
    }

    if (!force) {
      print('\nDo you want to optimize these files? (y/N)');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y') {
        print('Operation cancelled.');
        return;
      }
    }

    print('\nOptimizing assets...');
    for (final entry in largeAssets.entries) {
      try {
        final file = File(entry.key);
        final bytes = await file.readAsBytes();
        final image = img.decodeImage(bytes);

        if (image != null) {
          final optimized = img.encodeJpg(image, quality: quality);
          if (optimized.length < bytes.length) {
            await file.writeAsBytes(optimized);
            print(
                'Optimized: ${entry.key} (${_formatSize(bytes.length)} -> ${_formatSize(optimized.length)})');
          } else {
            print('Skipped: ${entry.key} (optimization would increase size)');
          }
        } else {
          print('Skipped: ${entry.key} (not an image or unsupported format)');
        }
      } catch (e) {
        print('Error optimizing ${entry.key}: $e');
      }
    }
    print('\nOptimization completed.');
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class CliProgress {
  late final FillingBar _progressBar;
  Timer? _updateTimer;
  int _currentProgress = 0;
  final int _totalSteps;

  CliProgress({
    required String description,
    required int totalSteps,
  }) : _totalSteps = totalSteps {
    _progressBar = FillingBar(
      desc: description,
      total: totalSteps,
      time: true,
      percentage: true,
      fill: '=',
      space: ' ',
      scale: 0.5,
    );
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentProgress < _totalSteps) {
        _progressBar.increment();
        _currentProgress++;
      } else {
        timer.cancel();
      }
    });
  }

  void increment() {
    _currentProgress++;
  }

  void incrementBy(int steps) {
    _currentProgress += steps;
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}
