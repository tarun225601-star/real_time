name: dark_studio_app
description: A professional dark themed Flutter app.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=2.19.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  webview_flutter: ^4.7.0
  http: ^1.2.0
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
```

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _darkModeFuture;

  @override
  void initState() {
    super.initState();
    _darkModeFuture = _loadThemePreference();
  }

  Future<bool> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _darkModeFuture,
      builder: (context, snapshot) {
        final isDark = snapshot.data ?? true;
        return MaterialApp(
          title: 'Dark Studio',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0B132B),
            primaryColor: const Color(0xFF00F5D4),
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF00F5D4),
              secondary: const Color(0xFF00F5D4),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0B132B),
              elevation: 0,
            ),
            cardColor: const Color(0xFF1E2A3A),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white70),
              bodyMedium: TextStyle(color: Colors.white70),
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F5D4),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> _demoData = [
    {
      'title': 'Flutter Documentation',
      'subtitle': 'Official docs for Flutter developers.',
      'url': 'https://flutter.dev/docs',
    },
    {
      'title': 'Dart Packages',
      'subtitle': 'Explore packages on pub.dev.',
      'url': 'https://pub.dev',
    },
    {
      'title': 'GitHub',
      'subtitle': 'Openâsource projects and code.',
      'url': 'https://github.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Studio'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _demoData.length,
        itemBuilder: (context, index) {
          final item = _demoData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(item['title']!, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text(item['subtitle']!, style: Theme.of(context).textTheme.bodyMedium),
              trailing: const Icon(Icons.open_in_new, color: Color(0xFF00F5D4)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      title: item['title']!,
                      url: item['url']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({Key? key, required this.title, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00F5D4),
              ),
            ),
        ],
      ),
    );
  }
}