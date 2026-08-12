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
    'assets/video.mp4',
  );
  final _videoPlayerController2 = VideoPlayerController.asset(
    'assets/video2.mp4',
  );
  final _videoPlayerController3 = VideoPlayerController.asset(
    'assets/video3.mp4',
  );
  final _videoPlayerController4 = VideoPlayerController.asset(
    'assets/video4.mp4',
  );
  final _videoPlayerController5 = VideoPlayerController.asset(
    'assets/video5.mp4',
  );
  final _videoPlayerController6 = VideoPlayerController.asset(
    'assets/video6.mp4',
  );
  final _videoPlayerController7 = VideoPlayerController.asset(
    'assets/video7.mp4',
  );
  final _videoPlayerController8 = VideoPlayerController.asset(
    'assets/video8.mp4',
  );
  final _videoPlayerController9 = VideoPlayerController.asset(
    'assets/video9.mp4',
  );
  final _videoPlayerController10 = VideoPlayerController.asset(
    'assets/video10.mp4',
  );
  int _currentIndex = 0;
  bool _isLiked = false;
  final List<VideoPlayerController> _controllers = [
    VideoPlayerController.asset('assets/video.mp4'),
    VideoPlayerController.asset('assets/video2.mp4'),
    VideoPlayerController.asset('assets/video3.mp4'),
    VideoPlayerController.asset('assets/video4.mp4'),
    VideoPlayerController.asset('assets/video5.mp4'),
    VideoPlayerController.asset('assets/video6.mp4'),
    VideoPlayerController.asset('assets/video7.mp4'),
    VideoPlayerController.asset('assets/video8.mp4'),
    VideoPlayerController.asset('assets/video9.mp4'),
    VideoPlayerController.asset('assets/video10.mp4'),
  ];

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
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              VideoPlayer(_controllers[index]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.black54,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Creator Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Caption',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Music Title',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: _isLiked ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLiked = !_isLiked;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.comment,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: Text('Comment Sheet'),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Text('This is a mock profile page'),
      ),
    );
  }
}