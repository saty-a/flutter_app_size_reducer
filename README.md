# Flutter App Size Reducer 🚀

[![pub package](https://img.shields.io/pub/v/flutter_app_size_reducer.svg)](https://pub.dev/packages/flutter_app_size_reducer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI](https://github.com/saty-a/flutter_app_size_reducer/actions/workflows/ci.yml/badge.svg)](https://github.com/saty-a/flutter_app_size_reducer/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/saty-a/flutter_app_size_reducer/branch/main/graph/badge.svg)](https://codecov.io/gh/saty-a/flutter_app_size_reducer)

A comprehensive Flutter development toolkit for app size optimization, dependency analysis, code cleanup, and developer productivity.

> **Version 2.0** brings major improvements with beautiful CLI, dependency analysis, and much more!

## ✨ Features

### 🔍 Asset Analysis
- Find unused assets in your Flutter project
- Identify large assets that should be optimized
- Scan project files for asset references
- Detailed reports with file sizes

### 📦 Dependency Analysis **NEW in v2.0**
- Detect unused dependencies in `pubspec.yaml`
- Show latest package versions from pub.dev
- Find orphaned dev dependencies
- Interactive cleanup suggestions

### 🧹 Smart Cleanup
- Safely remove unused assets
- Interactive selection mode
- Dry-run option to preview changes
- Backup support before deletion

### 🎨 Image Optimization
- Optimize PNG, JPG, JPEG, GIF, WebP images
- Configurable quality settings
- Batch processing
- Before/after size comparison

### 🎯 Beautiful CLI **NEW in v2.0**
- Colored output with progress indicators
- Interactive prompts and confirmations
- JSON output for CI/CD integration
- Command categories and better help

### ⚙️ Flexible Configuration
- Comprehensive YAML configuration
- Customizable thresholds and exclusions
- Per-feature settings
- Easy setup with interactive prompts

## 🚀 Quick Start

### Installation

**Option 1: Global Activation (Recommended)**

Activate the package globally for easy access from anywhere:

```bash
dart pub global activate flutter_app_size_reducer
```

After activation, you can use the short command:

```bash
fasr --help
```

**Option 2: Add as Dev Dependency**

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_app_size_reducer: ^2.0.0
```

Then run:

```bash
flutter pub get
```

### Usage

**With Global Activation (Short Command)**

```bash
# Initialize configuration
fasr init

# Analyze your project  
fasr analyse

# Analyze only dependencies
fasr analyse --type=dependencies

# Clean unused assets
fasr clean --dry-run

# Optimize images
fasr optimize --quality=85
```

**Without Global Activation (Dev Dependency)**

```bash
dart run flutter_app_size_reducer init
dart run flutter_app_size_reducer analyse
# ... etc
```

> 💡 **Pro Tip**: Use global activation for the best experience! Just type `fasr` instead of the long command.

## 📖 Commands

### `init` - Initialize Configuration

```bash
fasr init [options]
```

Options:
- `--path=<path>` - Custom configuration file path

### `analyse` (or `analyze`) - Analyze Project

```bash
fasr analyse [options]
```

Options:
- `--type=<type>` - Analysis type: `assets`, `dependencies`, `all` (default: `all`)
- `--export=<path>` - Export report to file

Examples:
```bash
# Analyze everything
fasr analyse

# Only analyze dependencies
fasr analyse --type=dependencies

# Export results
fasr analyse --export=report.json
```

### `clean` - Clean Unused Assets

```bash
fasr clean [options]
```

Options:
- `--dry-run` - Show what would be deleted without deleting
- `--force` - Skip confirmation prompt

### `optimize` - Optimize Large Assets

```bash
fasr optimize [options]
```

Options:
- `--quality=<n>` - JPEG quality (1-100, default: 85)
- `--dry-run` - Show what would be optimized without optimizing
- `--force` - Skip confirmation prompt

### Global Options

All commands support:
- `--help`, `-h` - Show help
- `--version`, `-v` - Show version
- `--json` - Output in JSON format (for CI/CD)
- `--[no-]color` - Enable/disable colored output
- `--verbose` - Enable verbose logging

## ⚙️ Configuration

The `flutter_app_size_reducer.yaml` file structure:

```yaml
assets:
  maxAssetSize: 1048576  # 1MB in bytes
  excludeExtensions:
    - ttf
    - otf
    - json
  excludePaths:
    - assets/fonts/
    - assets/config/
  optimizeImages: true
  optimizeQuality: 85
  imageFormats:
    - png
    - jpg
    - jpeg
    - gif
    - webp

dependencies:
  checkUnused: true
  checkOutdated: true
  excludePackages: []
  suggestAlternatives: true

code:
  detectUnusedCode: true
  detectUnusedImports: true
  analyzeDirs:
    - lib
  excludeDirs:
    - lib/generated/
  minComplexity: 10

build:
  buildTypes:
    - apk
  trackHistory: true
  maxHistoryEntries: 10
  sizeBudget: 0  # 0 = no budget

reporting:
  outputFormat: markdown  # markdown, json, html, all
  openHtmlReports: false
  reportDir: .reports
  includeCharts: true
  useColors: true
```

## 📊 Programmatic Usage

You can also use the package programmatically in your Dart code:

```dart
import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';

void main() async {
  // Initialize configuration
  await FlutterAppSizeReducer.init();
  
  // Analyze project
  final results = await FlutterAppSizeReducer.analyze();
  print('Analysis complete!');
  
  // Clean unused assets
  await FlutterAppSizeReducer.clean(dryRun: true);
  
  // Optimize images
  await FlutterAppSizeReducer.optimize(quality: 80);
}
```

## 🆕 What's New in v2.0

- **🎨 Beautiful CLI** with colors, progress bars, and better UX
- **📦 Dependency Analysis** - detect unused packages
- **⚙️ Enhanced Configuration** - more options and better structure
- **🔧 Interactive Setup** - guided configuration during init
- **📊 Better Reports** - more detailed and exportable
- **🚀 Improved Performance** - faster scanning and analysis

See [CHANGELOG.md](CHANGELOG.md) for detailed changes.

## 🔄 Migrating from v1.x

Version 2.0 includes breaking changes. To migrate:

1. Backup your old config file
2. Run `dart run flutter_app_size_reducer init` to create a new config
3. Review and adjust settings as needed

The new config format provides much more control and new features!

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💖 Support

If you find this package helpful, please:
- ⭐ Star the repository
- 🐛 Report issues
- 💡 Suggest new features
- 🤝 Contribute code

## 🔗 Links

- [Package on pub.dev](https://pub.dev/packages/flutter_app_size_reducer)
- [Source Code](https://github.com/saty-a/flutter_app_size_reducer)
- [Issue Tracker](https://github.com/saty-a/flutter_app_size_reducer/issues)
- [Changelog](CHANGELOG.md)

---

**Made with ❤️ for the Flutter community**