import 'package:flutter/material.dart';
import 'package:instagram_clone/models/video_model.dart';
import 'package:instagram_clone/widgets/like_button.dart';
import 'package:instagram_clone/widgets/share_button.dart';

class VideoScreen extends StatefulWidget {
  final VideoModel video;

  VideoScreen({required this.video});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: VideoPlayer(
              video: widget.video,
            ),
          ),
          Row(
            children: [
              LikeButton(
                video: widget.video,
              ),
              ShareButton(
                video: widget.video,
              ),
            ],
          ),
        ],
      ),
    );
  }
}