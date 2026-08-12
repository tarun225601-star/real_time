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
  final _videoPlayerController = VideoPlayerController.asset(
    'assets/video.mp4', // replace with your video asset
  );
  final _videoPlayerController2 = VideoPlayerController.asset(
    'assets/video2.mp4', // replace with your video asset
  );
  final _videoPlayerController3 = VideoPlayerController.asset(
    'assets/video3.mp4', // replace with your video asset
  );
  final _videoPlayerController4 = VideoPlayerController.asset(
    'assets/video4.mp4', // replace with your video asset
  );
  final _videoPlayerController5 = VideoPlayerController.asset(
    'assets/video5.mp4', // replace with your video asset
  );
  int _currentIndex = 0;
  bool _isLiked = false;
  bool _isCommentSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController2.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController3.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController4.initialize().then((_) {
      setState(() {});
    });
    _videoPlayerController5.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _videoPlayerController2.dispose();
    _videoPlayerController3.dispose();
    _videoPlayerController4.dispose();
    _videoPlayerController5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  _videoPlayerController.index == index
                      ? VideoPlayer(_videoPlayerController)
                      : _videoPlayerController2.index == index
                          ? VideoPlayer(_videoPlayerController2)
                          : _videoPlayerController3.index == index
                              ? VideoPlayer(_videoPlayerController3)
                              : _videoPlayerController4.index == index
                                  ? VideoPlayer(_videoPlayerController4)
                                  : VideoPlayer(_videoPlayerController5),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black54,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Creator Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Caption',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Music Title',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCommentSheetOpen = true;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          _isCommentSheetOpen
              ? Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write a comment',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isCommentSheetOpen = false;
                            });
                          },
                          child: const Text('Post'),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Page'),
      ),
    );
  }
}