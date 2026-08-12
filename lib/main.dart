import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _profilePicture;
  String? _username;
  String? _bio;

  Future<void> _createProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('bio', _bioController.text);
    if (_profilePicture != null) {
      await prefs.setString('profilePicture', _profilePicture!.path);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedScreen()),
    );
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickProfilePicture,
              child: Text('Pick Profile Picture'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createProfile,
              child: Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<XFile?> _mediaFiles = [];
  List<String> _songTitles = [];
  List<int> _likeCounters = [];
  List<String> _comments = [];
  List<bool> _followButtons = [];

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _mediaFiles.addAll(pickedFiles);
        _songTitles.addAll(List.generate(pickedFiles.length, (index) => ''));
        _likeCounters.addAll(List.generate(pickedFiles.length, (index) => 0));
        _comments.addAll(List.generate(pickedFiles.length, (index) => ''));
        _followButtons.addAll(List.generate(pickedFiles.length, (index) => false));
      });
    }
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null) {
      final videoPlayerController = VideoPlayerController.file(File(file.path));
      await videoPlayerController.initialize();
      await videoPlayerController.play();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoPlayerController),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: _mediaFiles.isEmpty
          ? Center(
              child: Text('No media files'),
            )
          : PageView.builder(
              itemCount: _mediaFiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: _mediaFiles[index] != null
                            ? Image.file(File(_mediaFiles[index]!.path))
                            : Container(),
                      ),
                      SizedBox(height: 20),
                      Text(_songTitles[index]),
                      SizedBox(height: 10),
                      Text('Likes: ${_likeCounters[index]}'),
                      SizedBox(height: 10),
                      Text(_comments[index]),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Follow button logic
                        },
                        child: Text(_followButtons[index] ? 'Unfollow' : 'Follow'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _playVideo(_mediaFiles[index]);
                        },
                        child: Text('Play Video'),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickMedia,
        tooltip: 'Pick Media',
        child: Icon(Icons.add),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController _videoPlayerController;

  VideoPlayerScreen(this._videoPlayerController);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void dispose() {
    widget._videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VideoPlayer(widget._videoPlayerController),
      ),
    );
  }
}