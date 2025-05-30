abstract class BaseCommand {
  String get name;
  String get description;
  String getOptions();
  Future<void> execute([List<String> args = const []]);

  void printUsage() {
    print('''
Usage: flutter_app_size_reducer $name [options]

$description

Options:
${getOptions()}
''');
  }
}
