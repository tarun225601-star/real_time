import 'package:real_time/models/vendor_model.dart';
import 'package:real_time/models/user_model.dart';
import 'package:real_time/services/firestore_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_time/utils/constants.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  // Login with email and password
  Future<UserModel> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        final UserModel userModel = await _firestoreService.getUser(user.uid);
        return userModel;
      } else {
        throw Exception('User not found');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        final UserModel userModel = UserModel(
          id: user.uid,
          email: email,
          name: name,
        );
        await _firestoreService.createUser(userModel);
        return userModel;
      } else {
        throw Exception('User not found');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Login with phone number
  Future<UserModel> loginWithPhoneNumber(String phoneNumber) async {
    try {
      final VerificationId verificationId = await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          final UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          final User? user = userCredential.user;
          if (user != null) {
            final UserModel userModel =
                await _firestoreService.getUser(user.uid);
            return userModel;
          } else {
            throw Exception('User not found');
          }
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          // Handle code sent
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // Handle code auto retrieval timeout
        },
      );
      return Future.value();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Save API keys using SharedPreferences
  Future<void> saveApiKeys(String apiKey, String apiSecret) async {
    await _sharedPreferencesService.saveString(
      Constants.apiKeyKey,
      apiKey,
    );
    await _sharedPreferencesService.saveString(
      Constants.apiSecretKey,
      apiSecret,
    );
  }

  // Get API keys using SharedPreferences
  Future<Map<String, String>> getApiKeys() async {
    final String apiKey = await _sharedPreferencesService.getString(
      Constants.apiKeyKey,
    );
    final String apiSecret = await _sharedPreferencesService.getString(
      Constants.apiSecretKey,
    );
    return {
      Constants.apiKeyKey: apiKey,
      Constants.apiSecretKey: apiSecret,
    };
  }

  // Show settings dialog to save API keys
  Future<void> showSettingsDialog() async {
    // Show dialog to save API keys
  }
}