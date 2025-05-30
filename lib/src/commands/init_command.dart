import 'dart:io';
import 'dart:convert';
import 'base_command.dart';

class InitCommand extends BaseCommand {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize configuration file';

  @override
  String getOptions() {
    return '';
  }

  @override
  Future<void> execute([List<String> args = const []]) async {
    final configFile = File('flutter_app_size_reducer.yaml');

    if (await configFile.exists()) {
      print(
          'Configuration file already exists. Do you want to overwrite it? (y/N)');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y') {
        print('Operation cancelled.');
        return;
      }
    }

    final config = {
      'config': {
        'max-asset-size': 1024 * 1024, // 1MB default
        'exclude-extensions': [
          'ttf',
          'otf',
          'json',
          'xml',
          'html',
        ],
        'exclude-paths': [
          'assets/fonts/',
          'assets/config/',
        ],
        'optimize-images': true,
        'optimize-quality': 85,
      }
    };

    await configFile
        .writeAsString(const JsonEncoder.withIndent('  ').convert(config));
    print('Configuration file created successfully at ${configFile.path}');
  }
}
