// frontend_app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const RealTimeTranslatorApp());
}

class RealTimeTranslatorApp extends StatelessWidget {
  const RealTimeTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neural Speech Bridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const TranslationScreen(),
    );
  }
}

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  // ध्यान दें: यहाँ अपने FastAPI सर्वर का WebSocket URL डालना 
  // (अगर लोकल टेस्ट कर रहे हो तो अपने कंप्यूटर का IP एड्रेस डालें, localhost मोबाइल पर काम नहीं करता)
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8000/ws/translate'),
  );

  bool isTranslating = false;

  @override
  void initState() {
    super.initState();
    // सर्वर से आने वाले ट्रांसलेटेड ऑडियो को सुनना
    _channel.stream.listen(
      (message) {
        // यहाँ सर्वर से मिलने वाले ऑडियो बाइट्स प्रोसेस होंगे
        print("Received audio chunk from server");
      },
      onError: (error) {
        print("WebSocket Error: $error");
      },
      onDone: () {
        print("WebSocket Connection Closed");
      },
    );
  }

  void toggleTranslation() {
    setState(() {
      isTranslating = !isTranslating;
    });

    if (isTranslating) {
      print("Translation & Audio Streaming Started...");
      // यहाँ माइक से रिकॉर्डिंग शुरू करके WebSocket पर भेजने का कोड आएगा
    } else {
      print("Translation Stopped.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neural Voice Bridge MVP'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isTranslating ? Icons.mic : Icons.mic_off,
              size: 80,
              color: isTranslating ? Colors.greenAccent : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              isTranslating ? "Listening & Translating..." : "Tap to Start Talking",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            FloatingActionButton.large(
              onPressed: toggleTranslation,
              backgroundColor: isTranslating ? Colors.red : Colors.blue,
              child: Icon(isTranslating ? Icons.stop : Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
