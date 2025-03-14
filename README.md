# Flutter App Size Reducer

A Flutter plugin for analyzing and reducing app size through CLI commands.

## Features

- Analyze app size and get detailed breakdown
- Get recommendations for size optimization
- Optimize app size based on configurable options
- CLI interface for easy integration with CI/CD pipelines

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_app_size_reducer: ^0.0.1
```

## Usage

### CLI Usage

```bash
# Analyze app size
flutter pub run flutter_app_size_reducer --analyze

# Optimize app size
flutter pub run flutter_app_size_reducer --optimize

# Optimize with custom config
flutter pub run flutter_app_size_reducer --optimize --config=config.yaml
```

### Programmatic Usage

```dart
import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';

// Get current app size
final appSize = await FlutterAppSizeReducer.getAppSize();

// Analyze app size and get recommendations
final analysis = await FlutterAppSizeReducer.analyzeAppSize();

// Optimize app size
final success = await FlutterAppSizeReducer.optimizeAppSize({
  'removeUnusedAssets': true,
  'optimizeImages': true,
  'removeUnusedDependencies': true,
});
```

## Configuration

Create a `config.yaml` file to customize optimization settings:

```yaml
optimization:
  removeUnusedAssets: true
  optimizeImages: true
  removeUnusedDependencies: true
  imageQuality: 85
  maxImageSize: 1024
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 