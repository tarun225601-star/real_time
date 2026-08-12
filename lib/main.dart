import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Video> _videos = [
    Video(
      videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
      username: 'user1',
      description: 'Video 1',
      likeCount: 100,
    ),
    Video(
      videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
      username: 'user2',
      description: 'Video 2',
      likeCount: 200,
    ),
    Video(
      videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
      username: 'user3',
      description: 'Video 3',
      likeCount: 300,
    ),
  ];
  List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    for (var video in _videos) {
      _videoControllers.add(VideoPlayerController.network(video.videoUrl));
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: _videos.length,
        onPageChanged: (index) {
          for (var i = 0; i < _videoControllers.length; i++) {
            if (i != index) {
              _videoControllers[i].pause();
            }
          }
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              VideoPlayer(_videoControllers[index])..initialize().then((_) {
                _videoControllers[index].play();
              }),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _videos[index].username,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _videos[index].description,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      Text(
                        _videos[index].likeCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.chat_bubble_outline),
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                    ],
                  ),
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
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
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

class Video {
  final String videoUrl;
  final String username;
  final String description;
  final int likeCount;

  Video({
    required this.videoUrl,
    required this.username,
    required this.description,
    required this.likeCount,
  });
}