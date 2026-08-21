import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  // Capture all uncaught asynchronous errors.
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Global Flutter framework error handling.
      FlutterError.onError = (FlutterErrorDetails details) {
        // In debug mode, use the default Flutter error presentation.
        if (kDebugMode) {
          FlutterError.dumpErrorToConsole(details);
          FlutterError.presentError(details);
        } else {
          // In release mode you might want to report the error to an analytics service.
          // For this example we just log it.
          Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
        }
      };

      // Custom widget for rendering errors in the widget tree.
      ErrorWidget.builder = (FlutterErrorDetails details) {
        // You can customize the UI as needed.
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    details.exceptionAsString(),
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      };

      runApp(const MyApp());
    },
    // Capture any uncaught asynchronous errors that escape Flutter's error handling.
    (Object error, StackTrace stack) {
      // In production you would send this to a remote logging service.
      debugPrint('Uncaught async error: $error\n$stack');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlackâScreen Guard Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
      // Optional: show a red banner in debug mode for visual confirmation.
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _triggerSyncError() {
    // Synchronous error â will be caught by FlutterError.onError.
    throw StateError('Synchronous test error');
  }

  void _triggerAsyncError() {
    // Asynchronous error â will be caught by runZonedGuarded.
    Future<void>.delayed(const Duration(seconds: 1), () {
      throw StateError('Asynchronous test error');
    });
  }

  void _triggerWidgetError(BuildContext context) {
    // Force a widget build error.
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FaultyWidgetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlackâScreen Guard Demo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _triggerSyncError,
                child: const Text('Trigger Synchronous Error'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _triggerAsyncError,
                child: const Text('Trigger Asynchronous Error'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _triggerWidgetError(context),
                child: const Text('Trigger Widget Build Error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FaultyWidgetPage extends StatelessWidget {
  const FaultyWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This will cause a buildâtime exception (division by zero).
    final int zero = 0;
    final int result = 42 ~/ zero; // <-- throws IntegerDivisionByZeroException

    return Scaffold(
      appBar: AppBar(title: const Text('Faulty Widget')),
      body: Center(child: Text('Result: $result')),
    );
  }
}