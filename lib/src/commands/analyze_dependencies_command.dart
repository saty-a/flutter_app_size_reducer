import 'dart:convert';
import 'dart:io';
import 'base_command.dart';
import '../services/dependency_analyzer.dart';

/// Command to analyze dependencies
class AnalyzeDependenciesCommand extends BaseCommand {
  @override
  String get name => 'dependencies';

  @override
  String get description => 'Analyze project dependencies for unused packages';

  @override
  String getOptions() {
    return '''
  --json           Output in JSON format
  --unused-only    Show only unused dependencies
''';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    final unusedOnly = args.contains('--unused-only');

    final progress = createProgress('Analyzing dependencies');

    try {
      final analyzer = DependencyAnalyzer();
      final result = await analyzer.analyze();

      progress.complete('Analysis complete!');

      if (jsonOutput) {
        _printJsonOutput(result);
      } else {
        _printFormattedOutput(result, unusedOnly);
      }

      // Offer to clean unused dependencies (only with TTY)
      if (result.hasUnused && !jsonOutput && stdout.hasTerminal) {
        printInfo(
            '\n💡 Tip: You can remove unused dependencies to reduce app size.');

        final shouldClean = await confirm(
          'Would you like to remove unused dependencies?',
          defaultValue: false,
        );

        if (shouldClean) {
          printInfo('Please manually remove unused dependencies or use:');
          printInfo(
              '  flutter pub remove ${result.unusedDependencies.join(' ')}');
        }
      }
    } catch (e) {
      progress.fail('Analysis failed');
      printError('Error: $e');
      rethrow;
    }
  }

  void _printFormattedOutput(DependencyAnalysisResult result, bool unusedOnly) {
    printInfo('\n📦 Dependency Analysis\n');

    if (!unusedOnly) {
      printInfo('Total Dependencies: ${result.totalDependencies}');
      printInfo('Total Dev Dependencies: ${result.totalDevDependencies}');
      printInfo('');
    }

    // Unused dependencies
    if (result.unusedDependencies.isNotEmpty) {
      printWarning(
          '⚠️  Unused Dependencies (${result.unusedDependencies.length}):');
      for (final dep in result.unusedDependencies) {
        logger.info('  • $dep');
      }
      printInfo('');
    } else {
      printSuccess('✓ No unused dependencies found!');
    }

    // Unused dev dependencies
    if (result.unusedDevDependencies.isNotEmpty) {
      printWarning(
          '⚠️  Unused Dev Dependencies (${result.unusedDevDependencies.length}):');
      for (final dep in result.unusedDevDependencies) {
        logger.info('  • $dep');
      }
      printInfo('');
    } else if (!unusedOnly) {
      printSuccess('✓ No unused dev dependencies found!');
    }

    // Package info
    if (!unusedOnly && result.packageInfo.isNotEmpty) {
      printInfo('📋 Package Information:\n');
      for (final entry in result.packageInfo.entries) {
        final info = entry.value;
        logger.info('  ${info.name}');
        logger.info('    Latest version: ${info.latestVersion}');
        if (info.description != null) {
          logger.info('    ${info.description}');
        }
        logger.info('');
      }
    }

    // Summary
    if (result.hasUnused) {
      printWarning(
        '💡 Found ${result.totalUnused} unused ${result.totalUnused == 1 ? 'dependency' : 'dependencies'}',
      );
    } else {
      printSuccess('🎉 All dependencies are being used!');
    }
  }

  void _printJsonOutput(DependencyAnalysisResult result) {
    final output = {
      'total_dependencies': result.totalDependencies,
      'total_dev_dependencies': result.totalDevDependencies,
      'unused_dependencies': result.unusedDependencies,
      'unused_dev_dependencies': result.unusedDevDependencies,
      'total_unused': result.totalUnused,
      'package_info': result.packageInfo.map(
        (name, info) => MapEntry(
          name,
          {
            'latest_version': info.latestVersion,
            'description': info.description,
          },
        ),
      ),
    };

    logger.info(json.encode(output));
  }
}
