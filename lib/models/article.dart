class Article {
  final String title;
  final String description;
  final String videoUrl;
  final String link;

  Article({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.link,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      link: json['link'],
    );
  }
}
