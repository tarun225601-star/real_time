import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instagram_clone/models/video_model.dart';

class VideoUrls {
  static Future<List<VideoModel>> getVideos() async {
    final response = await http.get(Uri.parse('https://api.example.com/videos'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}