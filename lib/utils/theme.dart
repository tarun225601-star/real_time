import 'package:flutter/material.dart';
import 'package:real_time/services/shared_preferences_service.dart';

class AppTheme with ChangeNotifier {
  static const _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  static const _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.grey,
  );

  bool _isDarkMode = false;

  ThemeData get currentTheme => _isDarkMode? _darkTheme : _lightTheme;

  void toggleTheme() async {
    _isDarkMode =!_isDarkMode;
    await SharedPreferencesService.setTheme(_isDarkMode);
    notifyListeners();
  }

  Future<void> initTheme() async {
    final isDarkMode = await SharedPreferencesService.getTheme();
    if (isDarkMode!= null) {
      _isDarkMode = isDarkMode;
    }
    notifyListeners();
  }
}

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool showSettings;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.showSettings = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: showSettings
         ? [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ApiKeyDialog();
                    },
                  );
                },
              ),
            ]
          : null,
    );
  }
}

class ApiKeyDialog extends StatefulWidget {
  const ApiKeyDialog({Key? key}) : super(key: key);

  @override
  State<ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<ApiKeyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter API Key'),
              TextFormField(
                controller: _apiKeyController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter API key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    SharedPreferencesService.setApiKey(_apiKeyController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}