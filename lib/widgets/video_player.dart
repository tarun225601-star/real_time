import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram_clone/models/video_model.dart';

class VideoPlayer extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onTap;

  VideoPlayer({required this.video, required this.onTap});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.video.url,
    )..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: _controller.value.isInitialized
          ? VideoPlayer(
              _controller,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}