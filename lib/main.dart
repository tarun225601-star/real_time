import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeTok',
      theme: ThemeData(
        primaryColor: const Color(0xFF0B132B),
        accentColor: const Color(0xFF00F5D4),
        scaffoldBackgroundColor: const Color(0xFF0B132B),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const FeedTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeedTab extends StatelessWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            // Video player placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey,
              child: const Center(child: Text('Video Player')),
            ),
            // Interaction layer
            Positioned(
              right: 0,
              top: 0,
              child: Column(
                children: const [
                  Icon(Icons.favorite_border, color: Color(0xFF00F5D4)),
                  Icon(Icons.person, color: Color(0xFF00F5D4)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User avatar and name
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF00F5D4),
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              const Text('Username', style: TextStyle(color: Color(0xFF00F5D4))),
            ],
          ),
        ),
        // 3-column grid of placeholder photo/video thumbnails
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: List.generate(
              20,
              (index) => Container(
                margin: const EdgeInsets.all(4.0),
                color: Colors.grey,
                child: const Center(child: Text('Thumbnail')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}