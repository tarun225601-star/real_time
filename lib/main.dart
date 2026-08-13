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

  final List<Widget> _children = [
    const VideoFeed(),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class VideoFeed extends StatefulWidget {
  const VideoFeed({Key? key}) : super(key: key);

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      itemCount: 10,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            // Video player placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey,
              child: const Center(
                child: Text(
                  'Video Player',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Interaction layer
            Positioned(
              right: 0,
              top: 0,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFF00F5D4),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Color(0xFF00F5D4),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // User avatar
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: const Center(
            child: Text(
              'Avatar',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // User name
        const Text(
          'User Name',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        // Photo/video thumbnails
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: List.generate(
              12,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    'Thumbnail',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
