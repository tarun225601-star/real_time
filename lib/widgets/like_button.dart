import 'package:flutter/material.dart';
import 'package:instagram_clone/models/video_model.dart';
import 'package:instagram_clone/utils/shared_preferences.dart';

class LikeButton extends StatefulWidget {
  final VideoModel video;

  LikeButton({required this.video});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  _checkIfLiked() async {
    final likedVideos = await SharedPreferencesUtil.getLikedVideos();
    if (likedVideos.contains(widget.video.id)) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
      ),
      onPressed: () {
        if (_isLiked) {
          SharedPreferencesUtil.removeLikedVideo(widget.video.id);
        } else {
          SharedPreferencesUtil.addLikedVideo(widget.video.id);
        }
        setState(() {
          _isLiked = !_isLiked;
        });
      },
    );
  }
}