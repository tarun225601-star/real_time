class VideoModel {
  final String id;
  final String url;
  final String thumbnail;
  final String title;
  final String description;

  VideoModel({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.title,
    required this.description,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      description: json['description'],
    );
  }
}