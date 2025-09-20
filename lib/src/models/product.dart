//product.dart
class Product {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      image: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]
          : '',
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'image': image,
      'price': price,
    };
  }
}
