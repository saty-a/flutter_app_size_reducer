import 'dart:io';
import 'package:yaml/yaml.dart';
import '../models/config_model.dart';

/// Configuration loader and manager
class ConfigLoader {
  static const String configFileName = 'flutter_app_size_reducer.yaml';

  /// Load configuration from file
  static Future<AppSizeConfig> load([String? configPath]) async {
    final path = configPath ?? configFileName;
    final file = File(path);

    if (!await file.exists()) {
      throw ConfigException(
        'Configuration file not found: $path\n'
        'Run "flutter_app_size_reducer init" to create one.',
      );
    }

    try {
      final content = await file.readAsString();
      final yaml = loadYaml(content) as Map;

      // Convert YAML to JSON-compatible Map
      final jsonMap = _yamlToJson(yaml);

      return AppSizeConfig.fromJson(jsonMap as Map<String, dynamic>);
    } on YamlException catch (e) {
      throw ConfigException('Invalid YAML format: ${e.message}');
    } on TypeError catch (e) {
      throw ConfigException('Invalid configuration structure: $e');
    } catch (e) {
      throw ConfigException('Failed to load configuration: $e');
    }
  }

  /// Save configuration to file
  static Future<void> save(AppSizeConfig config, [String? configPath]) async {
    final path = configPath ?? configFileName;
    final file = File(path);

    final yaml = _toYamlString(config.toJson());
    await file.writeAsString(yaml);
  }

  /// Create default configuration file
  static Future<void> createDefault([String? configPath]) async {
    final path = configPath ?? configFileName;
    final file = File(path);

    if (await file.exists()) {
      throw ConfigException(
        'Configuration file already exists: $path\n'
        'Use --force to overwrite.',
      );
    }

    await save(AppSizeConfig.defaults(), path);
  }

  /// Convert YAML to JSON-compatible structure
  static dynamic _yamlToJson(dynamic yaml) {
    if (yaml is YamlMap) {
      final map = <String, dynamic>{};
      yaml.forEach((key, value) {
        map[key.toString()] = _yamlToJson(value);
      });
      return map;
    } else if (yaml is YamlList) {
      return yaml.map(_yamlToJson).toList();
    } else {
      return yaml;
    }
  }

  /// Convert JSON map to YAML string
  static String _toYamlString(Map<String, dynamic> json, [int indent = 0]) {
    final buffer = StringBuffer();
    final spaces = '  ' * indent;

    json.forEach((key, value) {
      buffer.write('$spaces$key:');
      if (value is Map<String, dynamic>) {
        buffer.writeln();
        buffer.write(_toYamlString(value, indent + 1));
      } else if (value is List) {
        buffer.writeln();
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            buffer.write('$spaces  -');
            buffer.writeln();
            buffer.write(_toYamlString(item, indent + 2));
          } else {
            buffer.writeln('$spaces  - $item');
          }
        }
      } else {
        buffer.writeln(' $value');
      }
    });

    return buffer.toString();
  }

  /// Migrate v1 config to v2
  static Future<AppSizeConfig> migrateFromV1(String v1ConfigPath) async {
    final file = File(v1ConfigPath);
    if (!await file.exists()) {
      throw ConfigException('V1 config file not found: $v1ConfigPath');
    }

    final content = await file.readAsString();
    final yaml = loadYaml(content);

    // Extract v1 config values
    final config = yaml['config'];
    final maxAssetSize = config['max-asset-size'] as int? ?? 1048576;
    final excludeExtensions =
        List<String>.from(config['exclude-extensions'] ?? []);
    final excludePaths = List<String>.from(config['exclude-paths'] ?? []);
    final optimizeImages = config['optimize-images'] as bool? ?? true;
    final optimizeQuality = config['optimize-quality'] as int? ?? 85;

    // Create v2 config with v1 values
    return AppSizeConfig(
      assets: AssetConfig(
        maxAssetSize: maxAssetSize,
        excludeExtensions: excludeExtensions,
        excludePaths: excludePaths,
        optimizeImages: optimizeImages,
        optimizeQuality: optimizeQuality,
        imageFormats: const ['png', 'jpg', 'jpeg', 'gif', 'webp'],
      ),
      dependencies: DependencyConfig.defaults(),
      code: CodeConfig.defaults(),
      build: BuildConfig.defaults(),
      reporting: ReportingConfig.defaults(),
    );
  }
}

/// Configuration exception
class ConfigException implements Exception {
  final String message;

  ConfigException(this.message);

  @override
  String toString() => message;
}
