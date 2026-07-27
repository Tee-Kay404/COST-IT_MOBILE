enum Environment {
  dev("dev"),
  staging("staging"),
  prod("prod");

  final String value;
  const Environment(this.value);

  factory Environment.fromString(String value) {
    return Environment.values.firstWhere(
      (type) => type.value == value,
      orElse: () => Environment.prod,
    );
  }
}

class AppConfig {
  final Environment environment;
  // final AWSConfig awsConfig;
  String currencyString = "NGN";
  static late AppConfig _instance;

  factory AppConfig({
    required Environment environment,
    // required AWSConfig awsConfig,
  }) {
    _instance = AppConfig._internal(environment);
    return _instance;
  }

  AppConfig._internal(this.environment);

  static AppConfig get instance => _instance;

  String get baseAppUrl {
    switch (_instance.environment) {
      case Environment.dev:
        return "https://cost-it-fqf0hwf2a2h7b4ej.southafricanorth-01.azurewebsites.net/api/v1/";
      case Environment.staging:
        return "https://cost-it-fqf0hwf2a2h7b4ej.southafricanorth-01.azurewebsites.net/api/v1/";
      case Environment.prod:
        return "https://cost-it-fqf0hwf2a2h7b4ej.southafricanorth-01.azurewebsites.net/api/v1/";
    }
  }

  String get baseSocketUrl {
    switch (_instance.environment) {
      case Environment.dev:
        return "https://notes-stack.onrender.com";
      case Environment.staging:
        return "https://notes-stack.onrender.com";
      case Environment.prod:
        return "https://notes-stack.onrender.com";
    }
  }

  Duration get sendTimeout {
    return const Duration(milliseconds: 60000);
  }

  Duration get receiveTimeout {
    return const Duration(milliseconds: 60000);
  }

  static String get alchemyApiKey => const String.fromEnvironment(
    'ALCHEMY_API_KEY',
    defaultValue: "GWDWKSEj9z6TqlIa5K2ZiUVGbRxH51rx",
  );

  static String get zeroXApiKey => const String.fromEnvironment(
    'ZERO_X_API_KEY',
    defaultValue: 'b7bad48e-cfc5-42a9-95db-c94cbcc102e8',
  );
}
