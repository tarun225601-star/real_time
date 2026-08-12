import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instagram_clone/models/video_model.dart';
import 'package:instagram_clone/utils/constants.dart';

class VideoService {
  static Future<List<VideoModel>> getVideos() async {
    final response = await http.get(Uri.parse(Constants.BASE_URL + '/videos'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  static Future<void> init() async {
    // Initialize video service
  }
}