class ProductModel {
  final int? id;
  final String name;
  final double? price;
  final String? description;
  final String? imageUrl;
  final String? categoryName;

  ProductModel({
    this.id,
    required this.name,
    this.price,
    this.description,
    this.imageUrl,
    this.categoryName,
  });

  // Field names are tolerant; tweak once you expand the `Product` schema.
  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
        id: (j['id'] as num?)?.toInt(),
        name: (j['name'] ?? j['productName'] ?? j['title'] ?? 'Unnamed').toString(),
        price: double.tryParse('${j['price'] ?? j['unitPrice'] ?? ''}'),
        description: j['description']?.toString(),
        imageUrl: (j['image'] ?? j['imageUrl'] ?? j['thumbnail'])?.toString(),
        categoryName: (j['categoryName'] ??
                (j['category'] is Map ? j['category']['name'] : null))
            ?.toString(),
      );
}
