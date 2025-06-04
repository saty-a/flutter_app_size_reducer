# Flutter App Size Reducer

[![pub package](https://img.shields.io/pub/v/flutter_app_size_reducer.svg)](https://pub.dev/packages/flutter_app_size_reducer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI](https://github.com/saty-a/flutter_app_size_reducer/actions/workflows/ci.yml/badge.svg)](https://github.com/saty-a/flutter_app_size_reducer/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/saty-a/flutter_app_size_reducer/branch/main/graph/badge.svg)](https://codecov.io/gh/saty-a/flutter_app_size_reducer)

A Flutter package that helps reduce your app size by analyzing, cleaning, and optimizing assets.

## Features

- 🔍 **Asset Analysis**: Find unused and large assets in your Flutter project
- 🧹 **Asset Cleaning**: Remove unused assets to reduce app size
- 🚀 **Asset Optimization**: Optimize large assets to improve performance
- 📊 **Detailed Reports**: Get comprehensive reports about your assets
- 🔧 **Configurable**: Customize the behavior through a configuration file
- 🛠️ **CLI Support**: Use through command-line interface or programmatically

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
  dependencies:
    flutter_app_size_reducer: ^<latest_version>
```
Then run:
flutter pub get


## Usage

### Command Line Interface

Initialize the configuration:

```bash
dart run flutter_app_size_reducer init
```

Analyze your assets:

```bash
dart run flutter_app_size_reducer analyse
```

### Programmatic Usage

```dart
import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';

void main() async {
  // Initialize configuration
  await FlutterAppSizeReducer.init();
  
  // Analyze assets
  final results = await FlutterAppSizeReducer.analyze();
  print('Unused assets: ${results['unusedAssets']}');
  print('Large assets: ${results['largeAssets']}');
  
  // Clean unused assets
  await FlutterAppSizeReducer.clean(dryRun: true);
  
  // Optimize assets
  await FlutterAppSizeReducer.optimize(quality: 80);
}
```

## Configuration

Create a `flutter_app_size_reducer.yaml` file in your project root:

```yaml
# Asset directories to analyze
asset_directories:
  - assets/
  - images/

# File extensions to consider as assets
asset_extensions:
  - .png
  - .jpg
  - .jpeg
  - .gif
  - .webp

# Maximum size for assets (in bytes)
max_asset_size: 100000

# Quality for optimized images (0-100)
optimization_quality: 80

# Exclude patterns
exclude_patterns:
  - "**/*.min.*"
  - "**/generated/*"
```

## Example

Check out the [example](example) directory for a complete usage example.

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/saty-a/flutter_app_size_reducer/issues).

# Changelog

## 1.0.2

* Initial release
* Added asset analysis functionality
* Added asset cleaning functionality
* Added asset optimization functionality
* Added configuration system
* Added CLI interface
* Added programmatic API
* Added example app
* Added comprehensive documentation
* Added test coverage

funding:
  - type: github
    url: https://github.com/sponsors/saty-a

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported to the community leaders responsible for enforcement at
https://github.com/saty-a/flutter_app_size_reducer/issues.
All complaints will be reviewed and investigated promptly and fairly.