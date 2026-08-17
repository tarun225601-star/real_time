import 'package:flutter/material.dart';
import 'package:real_time/screens/login_screen.dart';
import 'package:real_time/screens/home_screen.dart';
import 'package:real_time/screens/vendor_admin_screen.dart';
import 'package:real_time/screens/settings_screen.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/services/firebase_auth_service.dart';

class Routes {
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String vendorAdminScreen = '/vendor-admin';
  static const String settingsScreen = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case vendorAdminScreen:
        return MaterialPageRoute(builder: (context) => VendorAdminScreen());
      case settingsScreen:
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      default:
        return MaterialPageRoute(builder: (context) => LoginScreen());
    }
  }

  static void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, loginScreen);
  }

  static void navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, homeScreen);
  }

  static void navigateToVendorAdminScreen(BuildContext context) {
    Navigator.pushNamed(context, vendorAdminScreen);
  }

  static void navigateToSettingsScreen(BuildContext context) {
    Navigator.pushNamed(context, settingsScreen);
  }

  static void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final _apiKeyController = TextEditingController();
        final _apiSecretController = TextEditingController();

        return AlertDialog(
          title: Text('Settings'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(labelText: 'API Key'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter API key';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apiSecretController,
                  decoration: InputDecoration(labelText: 'API Secret'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter API secret';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  SharedPreferencesService.saveApiKey(_apiKeyController.text);
                  SharedPreferencesService.saveApiSecret(_apiSecretController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}