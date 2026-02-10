import 'dart:convert';
import 'package:appdac/config/log.dart';
import 'package:flutter/services.dart';
import 'app_config.dart';

class ConfigLoader {
  static const String _configPath = 'assets/config/app_config.json';

  /// Carga la configuración desde el archivo JSON
  static Future<AppConfig> load() async {
    try {
      final jsonString = await rootBundle.loadString(_configPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final config = AppConfig.fromJson(jsonMap);
      AppConfig.setInstance(config);
      
      return config;

    } catch (e) {
      // Fallback a configuración por defecto si hay error
      logear('Error cargando configuración: $e');
      final config = AppConfig.fromJson(<String,dynamic>{});
      AppConfig.setInstance(config);
      return config;
    }
  }


}