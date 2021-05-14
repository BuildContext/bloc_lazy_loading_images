class Model {
  int id;
  String imageUrl;

  Model({required this.id, required this.imageUrl});

  factory Model.fromJson(Map<String, dynamic> json) =>
      Model(id: json['id'], imageUrl: json['image_url']);
}
