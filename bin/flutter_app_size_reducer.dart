import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_app_size_reducer/src/commands/optimize_command.dart';
import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('analyse')
    ..addCommand('clean')
    ..addCommand('optimize');

  try {
    final results = parser.parse(arguments);
    final command = results.command;

    if (command == null) {
      _printUsage();
      exit(1);
    }

    if (command.name == 'help' || arguments.contains('--help')) {
      _printUsage();
      exit(0);
    }

    switch (command.name) {
      case 'init':
        await InitCommand().execute(command.rest);
        break;
      case 'analyse':
        await AnalyseCommand().execute(command.rest);
        break;
      case 'clean':
        await CleanCommand().execute(command.rest);
        break;
      case 'optimize':
        await OptimizeCommand().execute(command.rest);
        break;
      default:
        print('Unknown command: ${command.name}');
        _printUsage();
        exit(1);
    }
  } on ArgParserException catch (e) {
    print('Error: ${e.message}');
    _printUsage();
    exit(1);
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}

void _printUsage() {
  print('''
Flutter App Size Reducer - A tool to analyze and reduce Flutter app size

Usage:
  flutter_app_size_reducer <command> [arguments]

Available commands:
  init     Initialize configuration file
  analyse  Analyze assets and dependencies
  clean    Clean unused assets
  optimize Optimize large assets

Run 'flutter_app_size_reducer help <command>' for more information about a command.

Examples:
  flutter_app_size_reducer init
  flutter_app_size_reducer analyse
  flutter_app_size_reducer clean --dry-run
  flutter_app_size_reducer optimize --quality=80
''');
}
