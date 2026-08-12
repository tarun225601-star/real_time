class VideoModel {
  final String id;
  final String url;
  final String thumbnail;
  final String title;

  VideoModel({required this.id, required this.url, required this.thumbnail, required this.title});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      title: json['title'],
    );
  }
}