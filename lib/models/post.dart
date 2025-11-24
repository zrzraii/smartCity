class Post {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime date;
  final String? author;
  final int? readTimeMinutes;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    this.author,
    this.readTimeMinutes,
  });
}
