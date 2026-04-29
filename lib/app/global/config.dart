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
        return "http://localhost:3120/api/";
      case Environment.staging:
        return "http://localhost:3120/api/";
      case Environment.prod:
        return "http://localhost:3120/api/";
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
    return const Duration(milliseconds: 50000);
  }

  Duration get receiveTimeout {
    return const Duration(milliseconds: 50000);
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

// class AwsConfig {
//   // Get values from dotenv first, fallback to const String.fromEnvironment for backward compatibility
//   static String get accessKey => const String.fromEnvironment('AWS_ACCESS_KEY');
//   static String get secretKey => const String.fromEnvironment('AWS_SECRET_KEY');
//   static String get region => const String.fromEnvironment('AWS_REGION');
//   static String get bucket => const String.fromEnvironment('AWS_BUCKET_NAME');

//   static dev() {}
// }

// class AWSConfig {
//   final String accessKey;
//   final String secretKey;
//   final String region;
//   final String bucket;

//   const AWSConfig({
//     required this.accessKey,
//     required this.secretKey,
//     required this.region,
//     required this.bucket,
//   });

//   @override
//   String toString() {
//     return "AWSConfig(accessKey: $accessKey, secretKey: $secretKey,"
//         " region: $region, bucket: $bucket)";
//   }
// }

// class StripeConfig {
//   // Stripe API keys
//   static String publishableKey = const String.fromEnvironment(
//     'STRIPE_PUBLISHABLE_KEY',
//   );

//   static String secretKey = const String.fromEnvironment('STRIPE_SECRET_KEY');
// }
