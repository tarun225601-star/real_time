// lib/utils/constants.dart

import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/services/firebase_service.dart';

class Constants {
  // App Settings
  static const String appName = 'Quick Commerce';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String apiBaseUrl = 'https://your-api-url.com';
  static const String apiLoginEndpoint = '/login';
  static const String apiRegisterEndpoint = '/register';
  static const String apiProductsEndpoint = '/products';
  static const String apiOrdersEndpoint = '/orders';

  // Firebase Settings
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
  static const String firebaseStorageBucket = 'YOUR_FIREBASE_STORAGE_BUCKET';

  // SharedPreferences Keys
  static const String sharedPreferencesApiKeyKey = 'api_key';
  static const String sharedPreferencesApiSecretKey = 'api_secret';

  // Dialog Settings
  static const String settingsDialogTitle = 'Settings';
  static const String settingsDialogMessage = 'Enter your API key and secret to save locally';
  static const String settingsDialogPositiveButton = 'Save';
  static const String settingsDialogNegativeButton = 'Cancel';

  // Icons
  static const IconData settingsGearIcon = IconData(0xe900, fontFamily: 'MaterialIcons');

  // Error Messages
  static const String invalidApiKeyError = 'Invalid API key';
  static const String invalidApiSecretError = 'Invalid API secret';
  static const String apiConnectionError = 'Failed to connect to API';

  // Success Messages
  static const String apiKeysSavedSuccess = 'API keys saved successfully';

  // Firebase Auth
  static final FirebaseService _firebaseService = FirebaseService();
  static final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  static Future<void> saveApiKeysLocally(String apiKey, String apiSecret) async {
    await _sharedPreferencesService.setString(sharedPreferencesApiKeyKey, apiKey);
    await _sharedPreferencesService.setString(sharedPreferencesApiSecretKey, apiSecret);
  }

  static Future<String> getApiKeyLocally() async {
    return await _sharedPreferencesService.getString(sharedPreferencesApiKeyKey);
  }

  static Future<String> getApiSecretLocally() async {
    return await _sharedPreferencesService.getString(sharedPreferencesApiSecretKey);
  }
}