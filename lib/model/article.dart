class Article {
  late final String articleId; // 'late' da die ID später festgelegt wird
  final String articleName;
  final String articleDescription;
  final List<String> platforms;
  final bool isAuction;
  final bool isSold;
  final List<String> photoIds;
  final String id;

  Article(
      {required this.articleId,
      required this.articleName,
      required this.articleDescription,
      required this.platforms,
      required this.isAuction,
      required this.isSold,
      required this.photoIds,
      required this.id});
}
