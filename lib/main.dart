import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Entry point of the application.
/// Wraps the app in a guarded zone to catch uncaught asynchronous errors
/// and sets up a global Flutter error handler for synchronous errors.
void main() {
  // Capture Flutter framework errors.
  FlutterError.onError = (FlutterErrorDetails details) {
    // In debug mode, use Flutter's default error handling.
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In release mode, report the error to a logging service.
      Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
    }
  };

  // Capture all uncaught asynchronous errors.
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (error, stack) {
      // TODO: Replace with your own error reporting (e.g., Sentry, Firebase Crashlytics).
      debugPrint('Uncaught async error: $error\n$stack');
    },
  );
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Define a custom error widget that replaces the red screen of death.
  static Widget _errorWidgetBuilder(BuildContext context, FlutterErrorDetails details) {
    // Log the error details.
    debugPrint('FlutterError: ${details.exceptionAsString()}\n${details.stack}');
    // Return a userâfriendly UI.
    return Scaffold(
      appBar: AppBar(title: const Text('Something went wrong')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'An unexpected error occurred.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Attempt to restart the app by rebuilding the widget tree.
                  // In a real app you might navigate to a safe screen or clear state.
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
                    (route) => false,
                  );
                },
                child: const Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Override the default error widget builder.
    ErrorWidget.builder = _errorWidgetBuilder;

    return MaterialApp(
      title: 'ErrorâHandled Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

/// Example home page that deliberately throws errors to demonstrate handling.
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Simulate a synchronous error.
  void _throwSyncError() {
    setState(() {
      // This will cause a division by zero exception.
      _counter = 10 ~/ 0;
    });
  }

  // Simulate an asynchronous error.
  Future<void> _throwAsyncError() async {
    await Future.delayed(const Duration(seconds: 1));
    // This exception will be caught by runZonedGuarded.
    throw Exception('Simulated async exception');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Check Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pressed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('Increment Counter (Safe)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _throwSyncError,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Throw Synchronous Error'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _throwAsyncError,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              child: const Text('Throw Asynchronous Error'),
            ),
          ],
        ),
      ),
    );
  }
}