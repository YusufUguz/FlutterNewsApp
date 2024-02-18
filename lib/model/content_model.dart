class Content {
  String? id;
  String? title;
  String? author;
  String? source;
  String? description;
  String? content;
  String? imageURL;
  String? sourceLogoURL;
  List<dynamic>? categories;
  DateTime? publishedAt;

  Content({
    this.id,
    this.title,
    this.author,
    this.source,
    this.description,
    this.content,
    this.imageURL,
    this.sourceLogoURL,
    this.categories,
    this.publishedAt,
  });
}
