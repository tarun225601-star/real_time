import 'package:http/http.dart' as http;

class HttpClient {
  static Future<String> getShareUrl(String videoId) async {
    final response = await http.get(Uri.parse('https://api.example.com/share/$videoId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get share url');
    }
  }

  static Future<void> shareUrl(String url) async {
    // Implement sharing logic here
  }
}