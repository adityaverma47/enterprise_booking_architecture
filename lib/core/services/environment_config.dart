/// Environment configuration for different deployment stages
enum Environment { dev, staging, production }

class EnvironmentConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String socketUrl;
  final bool enableLogging;
  final bool enableMockData;

  const EnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.socketUrl,
    this.enableLogging = true,
    this.enableMockData = false,
  });

  static EnvironmentConfig get current => _current;
  static EnvironmentConfig _current = _dev;

  static const EnvironmentConfig _dev = EnvironmentConfig(
    environment: Environment.dev,
    apiBaseUrl: 'https://api-dev.example.com',
    socketUrl: 'wss://socket-dev.example.com',
    enableLogging: true,
    enableMockData: true,
  );

  static const EnvironmentConfig _staging = EnvironmentConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://api-staging.example.com',
    socketUrl: 'wss://socket-staging.example.com',
    enableLogging: true,
    enableMockData: false,
  );

  static const EnvironmentConfig _production = EnvironmentConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.example.com',
    socketUrl: 'wss://socket.example.com',
    enableLogging: false,
    enableMockData: false,
  );

  static void initialize(Environment env) {
    switch (env) {
      case Environment.dev:
        _current = _dev;
        break;
      case Environment.staging:
        _current = _staging;
        break;
      case Environment.production:
        _current = _production;
        break;
    }
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;
}
