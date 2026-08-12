import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/screens/video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram Clone'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            videoUrl: 'https://example.com/video.mp4',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPlayerScreen()),
              );
            },
          );
        },
      ),
    );
  }
}