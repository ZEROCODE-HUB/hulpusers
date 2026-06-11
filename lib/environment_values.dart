import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';

class FFDevEnvironmentValues {
  // En debug se usa 'Test' por defecto (Supabase local).
  // En release siempre 'Production', o el valor explícito del flag --dart-define=ENVIRONMENT=...
  static const String _envFlag =
      String.fromEnvironment('ENVIRONMENT', defaultValue: '');

  static String get currentEnvironment {
    if (_envFlag.isNotEmpty) return _envFlag;
    return kDebugMode ? 'Test' : 'Production';
  }

  static String get environmentValuesPath =>
      currentEnvironment == 'Test'
          ? 'assets/environment_values/environment_test.json'
          : 'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _privateKey = data['privateKey'];
      _publicKey = data['publicKey'];
      _isProduction = data['isProduction'];
      _supabaseUrl = data['supabaseUrl'];
      _supabaseAnonKey = data['supabaseAnonKey'];
      _integrityKey = data['integrityKey'];
      _n8nWebhookUrl = data['n8nWebhookUrl'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _privateKey = '';
  String get privateKey => _privateKey;

  String _publicKey = '';
  String get publicKey => _publicKey;

  bool _isProduction = false;
  bool get isProduction => _isProduction;

  String _supabaseUrl = '';
  String get supabaseUrl => _supabaseUrl;

  String _supabaseAnonKey = '';
  String get supabaseAnonKey => _supabaseAnonKey;

  String _integrityKey = '';
  String get integrityKey => _integrityKey;

  String _n8nWebhookUrl = '';
  String get n8nWebhookUrl => _n8nWebhookUrl;
}
