import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShortTok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1D23),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeFeedScreen(),
          ExploreScreen(),
          UploadScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({Key? key}) : super(key: key);

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: const [
              VideoPlayerScreen(
                videoUrl: 'https://example.com/video1.mp4',
                creatorUsername: 'johnDoe',
                videoCaption: 'This is a sample video',
              ),
              VideoPlayerScreen(
                videoUrl: 'https://example.com/video2.mp4',
                creatorUsername: 'janeDoe',
                videoCaption: 'This is another sample video',
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Column(
              children: const [
                LikeButton(),
                CommentButton(),
                ShareButton(),
                ProfileButton(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: const [
                  CreatorUsername(),
                  VideoCaption(),
                  SoundTicker(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String creatorUsername;
  final String videoCaption;

  const VideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    required this.creatorUsername,
    required this.videoCaption,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
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
    return _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
      ),
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
          if (_isLiked) {
            _likeCount++;
          } else {
            _likeCount--;
          }
        });
      },
    );
  }
}

class CommentButton extends StatelessWidget {
  const CommentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.comment),
      onPressed: () {},
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {},
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () {},
    );
  }
}

class CreatorUsername extends StatelessWidget {
  const CreatorUsername({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'johnDoe',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}

class VideoCaption extends StatelessWidget {
  const VideoCaption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'This is a sample video',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}

class SoundTicker extends StatelessWidget {
  const SoundTicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sound: sample sound',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: const [
          TrendingHashtag(),
          PopularVideo(),
          SearchBar(),
        ],
      ),
    );
  }
}

class TrendingHashtag extends StatelessWidget {
  const TrendingHashtag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '#trendinghashtag',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}

class PopularVideo extends StatelessWidget {
  const PopularVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Popular Video',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Search',
      ),
    );
  }
}

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Upload Video'),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: const [
                UserVideo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        CircleAvatar(),
        Text(
          'johnDoe',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          'Follower: 100',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          'Following: 100',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class UserVideo extends StatelessWidget {
  const UserVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'User Video',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}