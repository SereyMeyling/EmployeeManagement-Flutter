class ProductModel {
  final int? id;
  final String name;
  final String? productCode;
  final double? price;
  final double? cost;
  final double? stockQuantity;
  final String? description;
  final String? status;
  final String? imageUrl;
  final String? categoryName;
  final int? categoryId;

  ProductModel({
    this.id,
    required this.name,
    this.productCode,
    this.price,
    this.cost,
    this.stockQuantity,
    this.description,
    this.status,
    this.imageUrl,
    this.categoryName,
    this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> j) {
    final category = j['category'];

    return ProductModel(
      id: (j['id'] as num?)?.toInt(),
      name:
          (j['name'] ?? j['productName'] ?? j['title'] ?? 'Unnamed').toString(),
      productCode: j['productCode']?.toString(),
      price: (j['price'] as num?)?.toDouble(),
      cost: (j['cost'] as num?)?.toDouble(),
      stockQuantity: (j['stockQuantity'] as num?)?.toDouble(),
      description: j['description']?.toString(),
      status: j['status']?.toString(),
      imageUrl: (j['image'] ?? j['imageUrl'] ?? j['thumbnail'])?.toString(),
      categoryName: category is Map
          ? category['name']?.toString()
          : j['categoryName']?.toString(),
      categoryId: category is Map ? (category['id'] as num?)?.toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'name': name,
      'productCode': productCode,
      'category': {
        'id': categoryId,
      },
      'price': price,
      'cost': cost,
      'stockQuantity': stockQuantity,
      'description': description,
      'status': status ?? 'ACTIVE',
    };
  }
}
