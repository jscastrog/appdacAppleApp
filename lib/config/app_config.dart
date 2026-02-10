class AppConfig {
  final Map<String, dynamic> parametros;

  const AppConfig({required this.parametros});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(parametros: json);
  }

  // Método estático para acceso global
  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('Configuración no inicializada. Llama a ConfigLoader.load() primero');
    }
    return _instance!;
  }

  static void setInstance(AppConfig config) {
    _instance = config;
  }
}

/*class ApiConfig {
  final String baseUrl;
  final int timeoutSeconds;
  final int maxRetries;
  final Map<String, String> endpoints;

  const ApiConfig({
    required this.baseUrl,
    required this.timeoutSeconds,
    required this.maxRetries,
    required this.endpoints,
  });

  factory ApiConfig.fromJson(Map<String, dynamic> json) {
    return ApiConfig(
      baseUrl: json['baseUrl'] as String,
      timeoutSeconds: json['timeoutSeconds'] as int,
      maxRetries: json['maxRetries'] as int,
      endpoints: Map<String, String>.from(json['endpoints']),
    );
  }
}*/

/*class UiConfig {
  final String appName;
  final String primaryColor;
  final String secondaryColor;
  final double defaultFontSize;
  final Map<String, double> borderRadius;

  const UiConfig({
    required this.appName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.defaultFontSize,
    required this.borderRadius,
  });

  factory UiConfig.fromJson(Map<String, dynamic> json) {
    return UiConfig(
      appName: json['appName'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      defaultFontSize: (json['defaultFontSize'] as num).toDouble(),
      borderRadius: Map<String, double>.from(
        json['borderRadius'].map((key, value) => MapEntry(key, (value as num).toDouble())),
      ),
    );
  }
}

class FeatureFlags {
  final bool enableAnalytics;
  final bool enableLogging;
  final bool enableDebugMenu;
  final bool showExperimentalFeatures;

  const FeatureFlags({
    required this.enableAnalytics,
    required this.enableLogging,
    required this.enableDebugMenu,
    required this.showExperimentalFeatures,
  });

  factory FeatureFlags.fromJson(Map<String, dynamic> json) {
    return FeatureFlags(
      enableAnalytics: json['enableAnalytics'] as bool,
      enableLogging: json['enableLogging'] as bool,
      enableDebugMenu: json['enableDebugMenu'] as bool,
      showExperimentalFeatures: json['showExperimentalFeatures'] as bool,
    );
  }
}

class AppSettings {
  final int cacheDurationMinutes;
  final int maxCacheSizeMB;
  final bool enableAnimations;
  final int itemsPerPage;
  final Map<String, dynamic> environment;

  const AppSettings({
    required this.cacheDurationMinutes,
    required this.maxCacheSizeMB,
    required this.enableAnimations,
    required this.itemsPerPage,
    required this.environment,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      cacheDurationMinutes: json['cacheDurationMinutes'] as int,
      maxCacheSizeMB: json['maxCacheSizeMB'] as int,
      enableAnimations: json['enableAnimations'] as bool,
      itemsPerPage: json['itemsPerPage'] as int,
      environment: Map<String, dynamic>.from(json['environment']),
    );
  }

  // Helper para obtener variables de entorno
  String getEnv(String key, [String defaultValue = '']) {
    return environment[key]?.toString() ?? defaultValue;
  }
}*/
