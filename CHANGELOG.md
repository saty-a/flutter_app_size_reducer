# CHANGELOG

## 2.0.0 - Major Revamp 🎉

This is a major release with significant new features and improvements!

### 🚀 New Features

- **Enhanced CLI Experience** - Beautiful colored output with `mason_logger`
  - Interactive configuration prompts  
  - Progress indicators for long-running operations
  - Better error messages and help system
  - Global flags: `--json`, `--version`, `--no-color`, `--verbose`

- **Dependency Analysis** - NEW powerful dependency management
  - Detect unused dependencies in `pubspec.yaml`
  - Show package information from pub.dev
  - Interactive cleanup prompts
  - Support for both dependencies and dev_dependencies

- **Improved Configuration System**
  - Strongly-typed configuration model with JSON serialization
  - Comprehensive sections for assets, dependencies, code, build, and reporting
  - Automatic migration from v1 to v2 config format
  - Interactive configuration setup during `init`

- **Enhanced Analysis Command**
  - Multiple analysis types: `--type=assets`, `--type=dependencies`, `--type=all`
  - Export analysis results to JSON: `--export=report.json`
  - Better formatted output with statistics

### 🛠️ Improvements

- Redesigned command structure with categorized help
- Better progress indicators
- More informative output
- Improved error handling
- Added command aliases (`analyze` for `analyse`)
- **Added short command name `fasr`** for easier CLI usage
- Support for global activation via `dart pub global activate`

### ⚠️ Breaking Changes

- Configuration file format changed from simple JSON to comprehensive YAML sections
- `analyse` command API changed (added new parameters)
- Programmatic API `analyze()` method signature changed

### 📝 Migration Guide

To migrate from v1.x to v2.0:

1. **Backup your old config**: `cp flutter_app_size_reducer.yaml flutter_app_size_reducer.yaml.backup`
2. **Re-initialize**: `dart run flutter_app_size_reducer init`
3. **Or manually update** your config to the new format (see README for structure)

The new configuration format provides much more control and new features!

## 1.0.4

* Added GIF support to the optimizer.
* Added a new flag to the `analyse` command to export the report to a JSON file.

## 1.0.3

* Improved error handling for corrupted or invalid image files during optimization.
* Enhanced performance of asset analysis for large projects with 1000+ assets.
* Fixed issue where exclude patterns were not applied correctly to nested directories.
* Added progress indicators for long-running operations in CLI mode.
* Updated documentation with troubleshooting section and common issues.

## 1.0.2

* Fixed bug where WebP images were not being properly optimized.
* Improved asset path resolution for Windows platform.
* Added validation for configuration file to provide helpful error messages.
* Fixed issue with dry-run mode not showing correct file paths.
* Enhanced CLI output formatting for better readability.

## 1.0.1

* Fixed missing dependency declaration in `pubspec.yaml`.
* Corrected asset size calculation to use actual file size in bytes.
* Fixed issue where `init` command would overwrite existing configuration file without warning.
* Improved error messages when asset directories don't exist.
* Updated example app with more comprehensive usage scenarios.

## 0.0.1

* Initial stable release of flutter_app_size_reducer.
* Added comprehensive asset analysis functionality to identify unused and large assets.
* Implemented asset cleaning feature to remove unused assets from Flutter projects.
* Introduced asset optimization capabilities with configurable quality settings.
* Added flexible configuration system through `flutter_app_size_reducer.yaml` file.
* Provided CLI interface with commands: `init`, `analyse`, `clean`, and `optimize`.
* Exposed programmatic API for integration into existing Flutter tooling and workflows.
* Included detailed reporting system for asset analysis results.
* Added support for multiple image formats: PNG, JPG, JPEG, GIF, and WebP.
* Implemented exclude patterns to skip specific files or directories.
* Added dry-run mode for safe testing before actual cleanup.
* Provided comprehensive documentation and usage examples.
* Included example application demonstrating all features.
* Added test coverage for core functionality.

### Features

* **Asset Analysis**: Scans project directories to find unused and oversized assets
* **Asset Cleaning**: Safely removes unused assets with dry-run option
* **Asset Optimization**: Reduces image file sizes while maintaining visual quality
* **Configuration**: Customizable settings via YAML configuration file
* **CLI Tools**: Easy-to-use command-line interface for all operations
* **Programmatic API**: Integrate functionality into custom build scripts or tools
