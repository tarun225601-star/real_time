import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:page_view/page_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Time',
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
  final _picker = ImagePicker();
  final _videoPlayerController = VideoPlayerController.network(
    'https://example.com/video.mp4',
  );
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  String _profilePicture = '';
  List<XFile> _selectedFiles = [];
  List<Post> _posts = [];
  bool _isFollowing = false;

  Future<void> _createPost() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (photo != null || video != null) {
      setState(() {
        _selectedFiles.add(photo!);
        _selectedFiles.add(video!);
      });
    }
  }

  Future<void> _playVideo() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('bio', _bioController.text);
    await prefs.setString('profilePicture', _profilePicture);
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _bioController.text = prefs.getString('bio') ?? '';
      _profilePicture = prefs.getString('profilePicture') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Time'),
      ),
      body: PageView(
        children: [
          ProfileScreen(
            usernameController: _usernameController,
            bioController: _bioController,
            profilePicture: _profilePicture,
            saveProfile: _saveProfile,
            loadProfile: _loadProfile,
          ),
          FeedScreen(
            posts: _posts,
            createPost: _createPost,
            playVideo: _playVideo,
            isFollowing: _isFollowing,
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final TextEditingController _usernameController;
  final TextEditingController _bioController;
  final String _profilePicture;
  final Function _saveProfile;
  final Function _loadProfile;

  ProfileScreen({
    required this._usernameController,
    required this._bioController,
    required this._profilePicture,
    required this._saveProfile,
    required this._loadProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ElevatedButton(
          onPressed: () async {
            await _saveProfile();
          },
          child: Text('Save Profile'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _loadProfile();
          },
          child: Text('Load Profile'),
        ),
      ],
    );
  }
}

class FeedScreen extends StatelessWidget {
  final List<Post> _posts;
  final Function _createPost;
  final Function _playVideo;
  final bool _isFollowing;

  FeedScreen({
    required this._posts,
    required this._createPost,
    required this._playVideo,
    required this._isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return PostCard(
          post: _posts[index],
          createPost: _createPost,
          playVideo: _playVideo,
          isFollowing: _isFollowing,
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post _post;
  final Function _createPost;
  final Function _playVideo;
  final bool _isFollowing;

  PostCard({
    required this._post,
    required this._createPost,
    required this._playVideo,
    required this._isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(_post.mediaUrl),
          Text(_post.songTitle),
          Text(_post.likeCounter.toString()),
          Text(_post.commentsSection),
          ElevatedButton(
            onPressed: () async {
              await _createPost();
            },
            child: Text('Create Post'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _playVideo();
            },
            child: Text('Play Video'),
          ),
          ElevatedButton(
            onPressed: () {
              // follow button logic
            },
            child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
          ),
        ],
      ),
    );
  }
}

class Post {
  final String mediaUrl;
  final String songTitle;
  final int likeCounter;
  final String commentsSection;

  Post({
    required this.mediaUrl,
    required this.songTitle,
    required this.likeCounter,
    required this.commentsSection,
  });
}
