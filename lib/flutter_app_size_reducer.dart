import 'dart:async';
import 'package:flutter/services.dart';

class FlutterAppSizeReducer {
  static const MethodChannel _channel = MethodChannel('flutter_app_size_reducer');

  /// Get the current app size
  static Future<Map<String, dynamic>> getAppSize() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAppSize');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw Exception('Failed to get app size: ${e.message}');
    }
  }

  /// Analyze app size and get recommendations
  static Future<Map<String, dynamic>> analyzeAppSize() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('analyzeAppSize');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw Exception('Failed to analyze app size: ${e.message}');
    }
  }

  /// Optimize app size based on recommendations
  static Future<bool> optimizeAppSize(Map<String, dynamic> options) async {
    try {
      final bool result = await _channel.invokeMethod('optimizeAppSize', options);
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to optimize app size: ${e.message}');
    }
  }
} 