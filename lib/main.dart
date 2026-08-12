import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Short Video Reels',
      home: MyHomePage(),
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
  final List<VideoPlayerController> _controllers = [
    VideoPlayerController.asset('assets/video1.mp4'),
    VideoPlayerController.asset('assets/video2.mp4'),
    VideoPlayerController.asset('assets/video3.mp4'),
  ];
  final List<bool> _liked = [false, false, false];
  final List<String> _captions = ['Caption 1', 'Caption 2', 'Caption 3'];
  final List<String> _musicTitles = ['Music 1', 'Music 2', 'Music 3'];
  final List<String> _creatorNames = ['Creator 1', 'Creator 2', 'Creator 3'];

  @override
  void initState() {
    super.initState();
    _controllers.forEach((controller) {
      controller.initialize().then((_) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    VideoPlayer(_controllers[index]),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent],
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _creatorNames[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _captions[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _musicTitles[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _liked[index] ? Icons.favorite : Icons.favorite_border,
                              color: _liked[index] ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _liked[index] = !_liked[index];
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment, color: Colors.white),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => const CommentSheet(),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
              BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Mock Profile Page'),
      ),
    );
  }
}

class CommentSheet extends StatelessWidget {
  const CommentSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Comments'),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Add a comment',
            ),
          ),
          SizedBox(height: 16),
          Text('Comment 1'),
          Text('Comment 2'),
          Text('Comment 3'),
        ],
      ),
    );
  }
}