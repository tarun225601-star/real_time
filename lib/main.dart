import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  List<Video> _videos = [];
  final _storage = FlutterSecureStorage();
  final _dio = Dio();
  final _videoPlayerController = VideoPlayerController.network(
    'https://example.com/video.mp4',
  );
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    final response = await _dio.get('https://example.com/videos');
    if (response.statusCode == 200) {
      final jsonData = response.data;
      setState(() {
        _videos = jsonData.map((json) => Video.fromJson(json)).toList();
      });
    } else {
      Fluttertoast.showToast(msg: 'Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TikTok Clone'),
      ),
      body: _videos.isEmpty
          ? Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Chewie(
                        controller: _chewieController,
                      ),
                      Text(_videos[index].title),
                      Text(_videos[index].description),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class Video {
  final String title;
  final String description;
  final String videoUrl;

  Video({this.title, this.description, this.videoUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
    );
  }
}