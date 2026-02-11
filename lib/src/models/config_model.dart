import 'package:json_annotation/json_annotation.dart';

part 'config_model.g.dart';

/// Configuration model for flutter_app_size_reducer
@JsonSerializable(explicitToJson: true)
class AppSizeConfig {
  /// Asset analysis configuration
  final AssetConfig assets;

  /// Dependency analysis configuration
  final DependencyConfig dependencies;

  /// Code analysis configuration
  final CodeConfig code;

  /// Build analysis configuration
  final BuildConfig build;

  /// Reporting preferences
  final ReportingConfig reporting;

  const AppSizeConfig({
    required this.assets,
    required this.dependencies,
    required this.code,
    required this.build,
    required this.reporting,
  });

  factory AppSizeConfig.fromJson(Map<String, dynamic> json) =>
      _$AppSizeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppSizeConfigToJson(this);

  /// Create default configuration
  factory AppSizeConfig.defaults() => AppSizeConfig(
        assets: AssetConfig.defaults(),
        dependencies: DependencyConfig.defaults(),
        code: CodeConfig.defaults(),
        build: BuildConfig.defaults(),
        reporting: ReportingConfig.defaults(),
      );
}

/// Asset analysis configuration
@JsonSerializable()
class AssetConfig {
  /// Maximum size for assets in bytes (default: 1MB)
  final int maxAssetSize;

  /// File extensions to exclude from analysis
  final List<String> excludeExtensions;

  /// Paths to exclude from analysis
  final List<String> excludePaths;

  /// Whether to optimize images
  final bool optimizeImages;

  /// Quality for image optimization (0-100)
  final int optimizeQuality;

  /// Image formats to analyze
  final List<String> imageFormats;

  const AssetConfig({
    required this.maxAssetSize,
    required this.excludeExtensions,
    required this.excludePaths,
    required this.optimizeImages,
    required this.optimizeQuality,
    required this.imageFormats,
  });

  factory AssetConfig.fromJson(Map<String, dynamic> json) =>
      _$AssetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AssetConfigToJson(this);

  factory AssetConfig.defaults() => const AssetConfig(
        maxAssetSize: 1048576, // 1MB
        excludeExtensions: ['ttf', 'otf', 'json', 'xml', 'html'],
        excludePaths: ['assets/fonts/', 'assets/config/'],
        optimizeImages: true,
        optimizeQuality: 85,
        imageFormats: ['png', 'jpg', 'jpeg', 'gif', 'webp'],
      );
}

/// Dependency analysis configuration
@JsonSerializable()
class DependencyConfig {
  /// Whether to check for unused dependencies
  final bool checkUnused;

  /// Whether to check for outdated dependencies
  final bool checkOutdated;

  /// Packages to exclude from dependency analysis
  final List<String> excludePackages;

  /// Whether to suggest lighter alternatives
  final bool suggestAlternatives;

  const DependencyConfig({
    required this.checkUnused,
    required this.checkOutdated,
    required this.excludePackages,
    required this.suggestAlternatives,
  });

  factory DependencyConfig.fromJson(Map<String, dynamic> json) =>
      _$DependencyConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DependencyConfigToJson(this);

  factory DependencyConfig.defaults() => const DependencyConfig(
        checkUnused: true,
        checkOutdated: true,
        excludePackages: [],
        suggestAlternatives: true,
      );
}

/// Code analysis configuration
@JsonSerializable()
class CodeConfig {
  /// Whether to detect unused code
  final bool detectUnusedCode;

  /// Whether to detect unused imports
  final bool detectUnusedImports;

  /// Directories to analyze
  final List<String> analyzeDirs;

  /// Directories to exclude from analysis
  final List<String> excludeDirs;

  /// Minimum code complexity to report
  final int minComplexity;

  const CodeConfig({
    required this.detectUnusedCode,
    required this.detectUnusedImports,
    required this.analyzeDirs,
    required this.excludeDirs,
    required this.minComplexity,
  });

  factory CodeConfig.fromJson(Map<String, dynamic> json) =>
      _$CodeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$CodeConfigToJson(this);

  factory CodeConfig.defaults() => const CodeConfig(
        detectUnusedCode: true,
        detectUnusedImports: true,
        analyzeDirs: ['lib'],
        excludeDirs: ['lib/generated/', 'lib/*.g.dart'],
        minComplexity: 10,
      );
}

/// Build analysis configuration
@JsonSerializable()
class BuildConfig {
  /// Build types to analyze (apk, aab, ipa)
  final List<String> buildTypes;

  /// Whether to track build history
  final bool trackHistory;

  /// Maximum number of builds to keep in history
  final int maxHistoryEntries;

  /// Size budget in bytes (0 = no budget)
  final int sizeBudget;

  const BuildConfig({
    required this.buildTypes,
    required this.trackHistory,
    required this.maxHistoryEntries,
    required this.sizeBudget,
  });

  factory BuildConfig.fromJson(Map<String, dynamic> json) =>
      _$BuildConfigFromJson(json);

  Map<String, dynamic> toJson() => _$BuildConfigToJson(this);

  factory BuildConfig.defaults() => const BuildConfig(
        buildTypes: ['apk'],
        trackHistory: true,
        maxHistoryEntries: 10,
        sizeBudget: 0,
      );
}

/// Reporting configuration
@JsonSerializable()
class ReportingConfig {
  /// Output format (json, markdown, html, all)
  final String outputFormat;

  /// Whether to open HTML reports automatically
  final bool openHtmlReports;

  /// Directory to save reports
  final String reportDir;

  /// Whether to include charts in reports
  final bool includeCharts;

  /// Whether to use colors in CLI output
  final bool useColors;

  const ReportingConfig({
    required this.outputFormat,
    required this.openHtmlReports,
    required this.reportDir,
    required this.includeCharts,
    required this.useColors,
  });

  factory ReportingConfig.fromJson(Map<String, dynamic> json) =>
      _$ReportingConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ReportingConfigToJson(this);

  factory ReportingConfig.defaults() => const ReportingConfig(
        outputFormat: 'markdown',
        openHtmlReports: false,
        reportDir: '.reports',
        includeCharts: true,
        useColors: true,
      );
}
