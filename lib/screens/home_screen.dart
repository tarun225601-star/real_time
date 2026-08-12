import 'package:flutter/material.dart';
import 'package:instagram_clone/models/video_model.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/video_player.dart';
import 'package:instagram_clone/screens/video_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<VideoModel> _videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  _loadVideos() async {
    final videos = await VideoUrls.getVideos();
    setState(() {
      _videos = videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram Clone'),
      ),
      body: _videos.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return VideoPlayer(
                  video: _videos[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoScreen(
                          video: _videos[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}