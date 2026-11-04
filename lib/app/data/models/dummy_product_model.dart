class DummyProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String thumbnail;
  final int stock;
  final String brand;

  DummyProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.stock,
    required this.brand,
  });

  factory DummyProductModel.fromJson(Map<String, dynamic> json) {
    return DummyProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail']?.toString() ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      brand: json['brand']?.toString() ?? 'Unknown',
    );
  }

  DummyProductModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    String? thumbnail,
    int? stock,
    String? brand,
  }) {
    return DummyProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'thumbnail': thumbnail,
      'stock': stock,
      'brand': brand,
    };
  }
}
