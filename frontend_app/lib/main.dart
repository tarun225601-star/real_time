import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8000/ws/translate'),
  );

  bool isTranslating = false;

  @override
  void initState() {
    super.initState();
    _channel.stream.listen(
      (message) {
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

  // माइक की परमिशन चेक करने और मांगने का फंक्शन
  Future<bool> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // परमिशन मांगना
      status = await Permission.microphone.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      // अगर यूजर ने हमेशा के लिए ब्लॉक कर दिया हो तो सेटिंग ओपन करवाना
      openAppSettings();
      return false;
    }
    return false;
  }

  void toggleTranslation() async {
    if (!isTranslating) {
      // ट्रांसलेशन शुरू करने से पहले माइक की परमिशन चेक करो
      bool hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) {
        // अगर परमिशन नहीं मिली तो आगे मत बढ़ो
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission is required to translate!")),
        );
        return;
      }
    }

    setState(() {
      isTranslating = !isTranslating;
    });

    if (isTranslating) {
      print("Microphone Permission Granted. Translation & Audio Streaming Started...");
      // यहाँ आगे रिकॉर्डर (जैसे record पैकेज) का शुरू होने वाला कोड डलेगा
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
