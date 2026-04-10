import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';
import 'package:flutter_app_size_reducer/src/commands/optimize_command.dart';
import 'package:flutter_app_size_reducer/src/utils/logger.dart';

const String version = '2.0.2';

// ANSI formatting helpers
String _bold(String s) => '\x1B[1m$s\x1B[0m';
String _cyan(String s) => '\x1B[96m$s\x1B[0m';
String _dim(String s) => '\x1B[2m$s\x1B[0m';
String _italic(String s) => '\x1B[3m$s\x1B[0m';

void main(List<String> arguments) async {
  final logger = Logger();

  final parser = ArgParser(allowTrailingOptions: false)
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the version.',
    )
    ..addFlag(
      'json',
      negatable: false,
      help: 'Output in JSON format.',
    )
    ..addFlag(
      'color',
      defaultsTo: true,
      help: 'Enable colored output.',
    )
    ..addFlag(
      'verbose',
      negatable: false,
      help: 'Enable verbose logging.',
    );

  try {
    // Find the command name first
    String? commandName;
    final commandArgs = <String>[];

    for (var i = 0; i < arguments.length; i++) {
      final arg = arguments[i];
      if (!arg.startsWith('-') && commandName == null) {
        commandName = arg;
      } else if (commandName != null) {
        commandArgs.add(arg);
      }
    }

    // Parse only the global options before the command
    final globalArgs = arguments
        .takeWhile((arg) => arg.startsWith('-') || arg == commandName)
        .toList();
    final results = parser.parse(globalArgs);

    // Handle global flags
    if (results['help'] as bool) {
      _printUsage(logger);
      exit(0);
    }

    if (results['version'] as bool) {
      logger.info('flutter_app_size_reducer version $version');
      exit(0);
    }

    final jsonOutput = results['json'] as bool;
    final useColors = results['color'] as bool;

    if (commandName == null) {
      _printUsage(logger);
      exit(1);
    }

    // Execute the command with command-specific arguments
    final commandInstance = _getCommand(commandName);
    commandInstance.initLogger(jsonOutput: jsonOutput, useColors: useColors);

    try {
      await commandInstance.execute(commandArgs);
      exit(0);
    } catch (e, stackTrace) {
      if (jsonOutput) {
        logger.err('{"error": "${e.toString()}"}');
      } else {
        logger.err('Error: $e');
        if (results['verbose'] as bool) {
          logger.info('Stack trace:\n$stackTrace');
        }
      }
      exit(1);
    }
  } on ArgParserException catch (e) {
    logger.err('Error: ${e.message}');
    _printUsage(logger);
    exit(1);
  } catch (e) {
    logger.err('Error: $e');
    exit(1);
  }
}

BaseCommand _getCommand(String name) {
  switch (name) {
    case 'init':
      return InitCommand();
    case 'analyse':
    case 'analyze':
      return AnalyseCommand();
    case 'clean':
      return CleanCommand();
    case 'optimize':
      return OptimizeCommand();
    case 'doctor':
      // TODO: Implement DoctorCommand
      throw UnimplementedError('Doctor command coming soon!');
    default:
      throw ArgumentError('Unknown command: $name');
  }
}

void _printUsage(Logger logger) {
  logger.info('''
${_cyan('Flutter App Size Reducer')} - v$version
A comprehensive Flutter development toolkit for app size optimization.

${_bold('Usage:')}
  fasr <command> [arguments]
  flutter_app_size_reducer <command> [arguments]

${_bold('Global Options:')}
  -h, --help       Print this usage information
  -v, --version    Print the version
  --json           Output in JSON format
  --[no-]color     Enable colored output (defaults to on)
  --verbose        Enable verbose logging

${_bold('Available Commands:')}

  ${_cyan('Analysis Commands:')}
    analyse, analyze    Analyze assets, dependencies, and code
    doctor              Health check and optimization recommendations

  ${_cyan('Cleanup Commands:')}
    clean              Clean unused assets
    optimize           Optimize large assets

  ${_cyan('Setup Commands:')}
    init               Initialize configuration file

${_bold('Examples:')}
  # Initialize configuration
  fasr init

  # Analyze your project
  fasr analyse

  # Analyze only dependencies
  fasr analyse --type=dependencies

  # Clean unused assets (dry run)
  fasr clean --dry-run

  # Optimize images with quality 80
  fasr optimize --quality=80

${_dim('Run "fasr <command> --help" for more information about a command.')}

${_dim('💡 Tip: Install globally with:')} ${_italic('dart pub global activate flutter_app_size_reducer')}
''');
}
