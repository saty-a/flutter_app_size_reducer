# Flutter App Size Reducer - Example Project

This is an example Flutter project demonstrating the usage of **flutter_app_size_reducer v2.0** - a comprehensive development toolkit for app optimization and analysis.

## 🚀 Quick Start

### 1. Install the Tool

**Recommended: Global Installation**

```bash
# Install globally for easy access
dart pub global activate flutter_app_size_reducer

# Verify installation
fasr --version
```

**Alternative: Project Dependency**

```bash
# Add to pubspec.yaml
dev_dependencies:
  flutter_app_size_reducer: ^2.0.0

# Then install
flutter pub get
```

## 📖 Usage Examples

### Initialize Configuration

Create a configuration file for your project:

```bash
# Using short command (recommended)
fasr init

# Or with full command
dart run flutter_app_size_reducer init
```

This creates `flutter_app_size_reducer.yaml` with customizable settings for:
- Asset size thresholds
- Dependency tracking
- Code analysis
- Build optimization
- Report generation

### Analyze Your Project

**Full Analysis (Assets + Dependencies)**

```bash
fasr analyse
```

**Dependency Analysis Only**

```bash
fasr analyse --type=dependencies
```

This will:
- ✅ Scan pubspec.yaml for all dependencies
- ✅ Detect unused packages (not imported anywhere)
- ✅ Fetch latest versions from pub.dev
- ✅ Show package descriptions
- ✅ Suggest cleanup actions

Example output:
```
📦 Dependency Analysis

Total Dependencies: 15
Total Dev Dependencies: 5

⚠️  Unused Dependencies (3):
  • package_a
  • package_b
  • package_c

📋 Package Information:

  http
    Latest version: 1.2.0
    Description: A composable, Future-based library for making HTTP requests.
```

**Asset Analysis Only**

```bash
fasr analyse --type=assets
```

This will:
- ✅ Scan assets directory recursively
- ✅ Find unused assets (not referenced in code/pubspec)
- ✅ Identify large assets exceeding size threshold
- ✅ Calculate total asset size

**Export Results**

```bash
# Export to JSON for CI/CD integration
fasr analyse --export=report.json

# Export dependency analysis
fasr analyse --type=dependencies --export=deps.json
```

### Clean Unused Assets

**Preview (Dry Run)**

```bash
fasr clean --dry-run
```

Shows what will be deleted without actually deleting.

**Clean for Real**

```bash
fasr clean
```

Removes unused assets after user confirmation.

**Skip Confirmation**

```bash
fasr clean --force
```

### Optimize Large Assets

**Optimize with default quality (85)**

```bash
fasr optimize
```

**Custom quality setting**

```bash
fasr optimize --quality=80
```

**Preview first**

```bash
fasr optimize --dry-run
```

## 🎯 Advanced Usage

### Global Flags

All commands support these global flags:

```bash
# Disable colored output (for logs)
fasr --no-color analyse

# Enable verbose logging
fasr --verbose analyse

# JSON output (for CI/CD)
fasr --json analyse

# Show help
fasr --help

# Show version
fasr --version
```

### CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Check Dependencies
on: [pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
      
      - name: Install flutter_app_size_reducer
        run: dart pub global activate flutter_app_size_reducer
      
      - name: Analyze dependencies
        run: |
          fasr init --force
          fasr analyse --type=dependencies --export=deps.json
      
      - name: Upload report
        uses: actions/upload-artifact@v2
        with:
          name: dependency-report
          path: deps.json
```

### Programmatic API

You can also use flutter_app_size_reducer as a Dart library:

```dart
import 'package:flutter_app_size_reducer/flutter_app_size_reducer.dart';

Future<void> main() async {
  // Analyze dependencies
  final analyzer = DependencyAnalyzer();
  final result = await analyzer.analyze();
  
  print('Total dependencies: ${result.totalDependencies}');
  print('Unused: ${result.unusedDependencies.length}');
  
  for (final pkg in result.unusedDependencies) {
    print('  - $pkg');
  }
  
  // Load configuration
  final config = await ConfigLoader.load();
  print('Max asset size: ${config.assets.maxAssetSize}');
}
```

## 📋 Configuration Example

The `flutter_app_size_reducer.yaml` file allows extensive customization:

```yaml
assets:
  maxAssetSize: 1048576  # 1 MB in bytes
  excludeExtensions:
    - ttf
    - otf
  excludePaths:
    - assets/fonts/
  optimizeImages: true
  optimizeQuality: 85

dependencies:
  checkUnused: true
  checkOutdated: true
  suggestAlternatives: true

code:
  detectUnusedCode: true
  detectUnusedImports: true
  analyzeDirs:
    - lib
  minComplexity: 10

build:
  buildTypes:
    - apk
  trackHistory: true
  sizeBudget: 0  # 0 = no limit

reporting:
  outputFormat: markdown
  openHtmlReports: false
  reportDir: .reports
  includeCharts: true
  useColors: true
```

## 🎨 Output Examples

### Dependency Analysis

```
🔍 Running Analysis...

✓ Analysis complete! (2.3s)

📦 Dependency Analysis

Total Dependencies: 13
Total Dev Dependencies: 5

[WARN] ⚠️  Unused Dependencies (2):
  • args
  • yaml

📋 Package Information:

  http
    Latest version: 1.2.0

  provider
    Latest version: 6.0.5
```

### Asset Analysis

```
📦 Analyzing Assets...

Total Assets: 45
Total Size: 2.3 MB

[WARN] Large Assets:
  • images/banner.png (1.5 MB)
  • images/background.jpg (800 KB)

[WARN] Unused Assets (3):
  • images/old_logo.png
  • icons/deprecated_icon.svg
  • fonts/unused_font.ttf

✅ Analysis complete!
```

## 💡 Tips & Best Practices

1. **Use Global Installation**: Install globally once, use everywhere
   ```bash
   dart pub global activate flutter_app_size_reducer
   fasr --help
   ```

2. **Regular Analysis**: Run analysis before each release
   ```bash
   fasr analyse --export=pre-release-report.json
   ```

3. **CI Integration**: Automate checks in your pipeline
   - Use `--json` flag for machine-readable output
   - Use `--no-color` in CI environments
   - Export results as artifacts

4. **Dependency Cleanup**: Regularly check for unused dependencies
   ```bash
   fasr analyse --type=dependencies
   ```

5. **Asset Optimization**: Optimize images before committing
   ```bash
   fasr optimize --quality=85
   ```

## 🔗 Links

- **Package**: [pub.dev/packages/flutter_app_size_reducer](https://pub.dev/packages/flutter_app_size_reducer)
- **GitHub**: [github.com/saty-a/flutter_app_size_reducer](https://github.com/saty-a/flutter_app_size_reducer)
- **Issues**: [GitHub Issues](https://github.com/saty-a/flutter_app_size_reducer/issues)

## 📝 License

MIT License - see LICENSE file for details.

---

## 🎯 New in v2.0

- ✅ **Short Command**: Use `fasr` instead of long command name
- ✅ **Dependency Analysis**: Detect unused packages with pub.dev integration
- ✅ **Enhanced CLI**: Beautiful colored output with progress indicators
- ✅ **Export Reports**: JSON export for CI/CD
- ✅ **Global Flags**: `--json`, `--no-color`, `--verbose`
- ✅ **Improved Config**: Comprehensive YAML configuration
- ✅ **Better UX**: Interactive prompts and helpful messages

Try it today: `dart pub global activate flutter_app_size_reducer`
