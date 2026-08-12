import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Video Reels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  final _videoController = VideoPlayerController.asset(
    'assets/video.mp4',
  )..initialize().then((_) {
    setState(() {});
  });
  bool _isLiked = false;
  final List<Video> _videos = [
    Video(
      'https://picsum.photos/200/300',
      'Creator Name',
      'This is a sample caption',
      'Music Title',
    ),
    Video(
      'https://picsum.photos/200/301',
      'Creator Name 2',
      'This is another sample caption',
      'Music Title 2',
    ),
  ];

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              VideoPlayer(_videoController),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.black.withOpacity(0.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _videos[index].creatorName,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _videos[index].caption,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _videos[index].musicTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CommentSheet(),
                          );
                        },
                      ),
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

class Video {
  final String imageUrl;
  final String creatorName;
  final String caption;
  final String musicTitle;

  Video(this.imageUrl, this.creatorName, this.caption, this.musicTitle);
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}

class CommentSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Text('Comment Sheet'),
      ),
    );
  }
}
