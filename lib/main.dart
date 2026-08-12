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
  final VideoPlayerController _videoController = VideoPlayerController.network(
    'https://www.w3schools.com/html/mov_bbb.mp4',
  )..initialize().then((_) {
    setState(() {});
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              VideoPlayer(VideoPlayerController.network(_videos[index].videoUrl)..initialize().then((_) {
                setState(() {});
              })),
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
                        color: Colors.red,
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
                        color: Colors.blue,
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.share),
                        color: Colors.pink,
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
