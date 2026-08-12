import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<void> addLikedVideo(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedVideos = prefs.getStringList('likedVideos') ?? [];
    likedVideos.add(videoId);
    await prefs.setStringList('likedVideos', likedVideos);
  }

  static Future<void> removeLikedVideo(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedVideos = prefs.getStringList('likedVideos') ?? [];
    likedVideos.remove(videoId);
    await prefs.setStringList('likedVideos', likedVideos);
  }

  static Future<List<String>> getLikedVideos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('likedVideos') ?? [];
  }
}