// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSizeConfig _$AppSizeConfigFromJson(Map<String, dynamic> json) =>
    AppSizeConfig(
      assets: AssetConfig.fromJson(json['assets'] as Map<String, dynamic>),
      dependencies: DependencyConfig.fromJson(
          json['dependencies'] as Map<String, dynamic>),
      code: CodeConfig.fromJson(json['code'] as Map<String, dynamic>),
      build: BuildConfig.fromJson(json['build'] as Map<String, dynamic>),
      reporting:
          ReportingConfig.fromJson(json['reporting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppSizeConfigToJson(AppSizeConfig instance) =>
    <String, dynamic>{
      'assets': instance.assets.toJson(),
      'dependencies': instance.dependencies.toJson(),
      'code': instance.code.toJson(),
      'build': instance.build.toJson(),
      'reporting': instance.reporting.toJson(),
    };

AssetConfig _$AssetConfigFromJson(Map<String, dynamic> json) => AssetConfig(
      maxAssetSize: (json['maxAssetSize'] as num).toInt(),
      excludeExtensions: (json['excludeExtensions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      excludePaths: (json['excludePaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      optimizeImages: json['optimizeImages'] as bool,
      optimizeQuality: (json['optimizeQuality'] as num).toInt(),
      imageFormats: (json['imageFormats'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AssetConfigToJson(AssetConfig instance) =>
    <String, dynamic>{
      'maxAssetSize': instance.maxAssetSize,
      'excludeExtensions': instance.excludeExtensions,
      'excludePaths': instance.excludePaths,
      'optimizeImages': instance.optimizeImages,
      'optimizeQuality': instance.optimizeQuality,
      'imageFormats': instance.imageFormats,
    };

DependencyConfig _$DependencyConfigFromJson(Map<String, dynamic> json) =>
    DependencyConfig(
      checkUnused: json['checkUnused'] as bool,
      checkOutdated: json['checkOutdated'] as bool,
      excludePackages: (json['excludePackages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      suggestAlternatives: json['suggestAlternatives'] as bool,
    );

Map<String, dynamic> _$DependencyConfigToJson(DependencyConfig instance) =>
    <String, dynamic>{
      'checkUnused': instance.checkUnused,
      'checkOutdated': instance.checkOutdated,
      'excludePackages': instance.excludePackages,
      'suggestAlternatives': instance.suggestAlternatives,
    };

CodeConfig _$CodeConfigFromJson(Map<String, dynamic> json) => CodeConfig(
      detectUnusedCode: json['detectUnusedCode'] as bool,
      detectUnusedImports: json['detectUnusedImports'] as bool,
      analyzeDirs: (json['analyzeDirs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      excludeDirs: (json['excludeDirs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      minComplexity: (json['minComplexity'] as num).toInt(),
    );

Map<String, dynamic> _$CodeConfigToJson(CodeConfig instance) =>
    <String, dynamic>{
      'detectUnusedCode': instance.detectUnusedCode,
      'detectUnusedImports': instance.detectUnusedImports,
      'analyzeDirs': instance.analyzeDirs,
      'excludeDirs': instance.excludeDirs,
      'minComplexity': instance.minComplexity,
    };

BuildConfig _$BuildConfigFromJson(Map<String, dynamic> json) => BuildConfig(
      buildTypes: (json['buildTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      trackHistory: json['trackHistory'] as bool,
      maxHistoryEntries: (json['maxHistoryEntries'] as num).toInt(),
      sizeBudget: (json['sizeBudget'] as num).toInt(),
    );

Map<String, dynamic> _$BuildConfigToJson(BuildConfig instance) =>
    <String, dynamic>{
      'buildTypes': instance.buildTypes,
      'trackHistory': instance.trackHistory,
      'maxHistoryEntries': instance.maxHistoryEntries,
      'sizeBudget': instance.sizeBudget,
    };

ReportingConfig _$ReportingConfigFromJson(Map<String, dynamic> json) =>
    ReportingConfig(
      outputFormat: json['outputFormat'] as String,
      openHtmlReports: json['openHtmlReports'] as bool,
      reportDir: json['reportDir'] as String,
      includeCharts: json['includeCharts'] as bool,
      useColors: json['useColors'] as bool,
    );

Map<String, dynamic> _$ReportingConfigToJson(ReportingConfig instance) =>
    <String, dynamic>{
      'outputFormat': instance.outputFormat,
      'openHtmlReports': instance.openHtmlReports,
      'reportDir': instance.reportDir,
      'includeCharts': instance.includeCharts,
      'useColors': instance.useColors,
    };
