import 'package:flutter/material.dart';
import 'package:instagram_clone/models/video_model.dart';
import 'package:instagram_clone/utils/http_client.dart';

class ShareButton extends StatefulWidget {
  final VideoModel video;

  ShareButton({required this.video});

  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () async {
        final url = await HttpClient.getShareUrl(widget.video.id);
        await HttpClient.shareUrl(url);
      },
    );
  }
}