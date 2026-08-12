import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:instagram_clone/models/video_model.dart';
import 'package:instagram_clone/services/video_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<VideoModel> _videos = [];
  final VideoService _videoService = VideoService();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  _loadVideos() async {
    final videos = await _videoService.getVideos();
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
                return VideoPlayerWidget(video: _videos[index]);
              },
            ),
    );
  }
}