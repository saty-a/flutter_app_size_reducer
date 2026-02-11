import 'dart:io';
import 'package:path/path.dart' as path;
import 'base_command.dart';
import '../models/config_model.dart';
import '../utils/config_loader.dart';

/// Command to initialize the configuration file
class InitCommand extends BaseCommand {
  @override
  String get name => 'init';

  @override
  String get description =>
      'Initialize configuration file with default settings';

  @override
  String getOptions() {
    return '''
  --force          Overwrite existing configuration file
  --path=<path>    Custom path for configuration file
''';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    final force = args.contains('--force');
    String? configPath;

    // Parse custom path
    for (final arg in args) {
      if (arg.startsWith('--path=')) {
        configPath = arg.substring(7); // Remove '--path='
      }
    }

    final configFile = File(configPath ?? ConfigLoader.configFileName);
    final configExists = await configFile.exists();

    if (configExists && !force) {
      printWarning(
        'Configuration file already exists: ${configFile.path}',
      );

      final overwrite = await confirm(
        'Do you want to overwrite it?',
        defaultValue: false,
      );

      if (!overwrite) {
        printInfo('Initialization cancelled.');
        return;
      }
    }

    // Create config with interactive prompts or defaults
    final useInteractive = !jsonOutput && stdin.hasTerminal;
    final config = useInteractive
        ? await _createInteractiveConfig()
        : AppSizeConfig.defaults();

    try {
      final progress = createProgress('Creating configuration file');

      await ConfigLoader.save(config, configFile.path);

      progress.complete('Configuration file created successfully!');

      printSuccess('Created: ${path.absolute(configFile.path)}');
      printInfo('\nYou can now run: dart run flutter_app_size_reducer analyse');
    } catch (e) {
      printError('Failed to create configuration file: $e');
      rethrow;
    }
  }

  Future<AppSizeConfig> _createInteractiveConfig() async {
    printInfo('\n📝 Let\'s set up your configuration!\n');

    // Asset configuration
    final maxAssetSizeChoice = chooseOne(
      'Maximum asset size threshold:',
      ['512 KB', '1 MB (default)', '2 MB', '5 MB', 'Custom'],
      defaultValue: '1 MB (default)',
    );

    int maxAssetSize;
    switch (maxAssetSizeChoice) {
      case '512 KB':
        maxAssetSize = 524288;
        break;
      case '2 MB':
        maxAssetSize = 2097152;
        break;
      case '5 MB':
        maxAssetSize = 5242880;
        break;
      case 'Custom':
        printInfo('Enter size in bytes:');
        final input = stdin.readLineSync() ?? '1048576';
        maxAssetSize = int.tryParse(input) ?? 1048576;
        break;
      default:
        maxAssetSize = 1048576;
    }

    // Dependency configuration
    final checkDeps = await confirm(
      'Check for unused dependencies?',
      defaultValue: true,
    );

    final checkOutdated = await confirm(
      'Check for outdated dependencies?',
      defaultValue: true,
    );

    // Code analysis configuration
    final analyzeCode = await confirm(
      'Enable code analysis (unused code detection)?',
      defaultValue: true,
    );

    // Build tracking
    final trackBuilds = await confirm(
      'Track build history?',
      defaultValue: true,
    );

    // Reporting
    final reportFormat = chooseOne(
      'Default report format:',
      ['markdown', 'json', 'html', 'all'],
      defaultValue: 'markdown',
    );

    return AppSizeConfig(
      assets: AssetConfig(
        maxAssetSize: maxAssetSize,
        excludeExtensions: const ['ttf', 'otf', 'json', 'xml', 'html'],
        excludePaths: const ['assets/fonts/', 'assets/config/'],
        optimizeImages: true,
        optimizeQuality: 85,
        imageFormats: const ['png', 'jpg', 'jpeg', 'gif', 'webp'],
      ),
      dependencies: DependencyConfig(
        checkUnused: checkDeps,
        checkOutdated: checkOutdated,
        excludePackages: const [],
        suggestAlternatives: true,
      ),
      code: CodeConfig(
        detectUnusedCode: analyzeCode,
        detectUnusedImports: analyzeCode,
        analyzeDirs: const ['lib'],
        excludeDirs: const ['lib/generated/', 'lib/*.g.dart'],
        minComplexity: 10,
      ),
      build: BuildConfig(
        buildTypes: const ['apk'],
        trackHistory: trackBuilds,
        maxHistoryEntries: 10,
        sizeBudget: 0,
      ),
      reporting: ReportingConfig(
        outputFormat: reportFormat,
        openHtmlReports: false,
        reportDir: '.reports',
        includeCharts: true,
        useColors: true,
      ),
    );
  }
}
