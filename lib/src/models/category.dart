class Category {
  Category({
    required this.title,
    required this.path,
  });
  late String title, path;
  factory Category.fromJson(Map json) => Category(
        title: json['title'],
        path: json['path'],
      );

  Map<String, String> toJson() => {'title': title, 'path': path};
}
