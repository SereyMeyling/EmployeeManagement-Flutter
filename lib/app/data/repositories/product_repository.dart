import '../../core/api_constants.dart';
import '../../core/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();

  Future<List<Map<String, dynamic>>> getCategories();

  Future<void> createCategory(String name);

  Future<void> createProduct(ProductModel product);
}

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _client;

  ProductRepositoryImpl(this._client);

  // Get Product List
  @override
  Future<List<ProductModel>> getProducts() async {
    final data = await _client.post(
      ApiConstants.productList,
      data: {
        'limit': 100,
        'page': 1,
      },
    );

    return DioClient.extractList(data).map(ProductModel.fromJson).toList();
  }

  // Get Category List
  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final data = await _client.post(
      ApiConstants.categoryList,
      data: {
        'limit': 100,
        'page': 1,
      },
    );

    return DioClient.extractList(data);
  }

  // Create Category
  @override
  Future<void> createCategory(String name) async {
    await _client.post(
      ApiConstants.categoryCreate,
      data: {
        'id': 0,
        'name': name,
      },
    );
  }

  // Create Product
  @override
  Future<void> createProduct(ProductModel product) async {
    final body = product.toJson();

    // Debug: មើលអ្វីដែល app ផ្ញើទៅ server (លុបចេញពេលដំណើរការហើយ)
    // ignore: avoid_print
    print('CREATE PRODUCT BODY: $body');

    final res = await _client.post(
      ApiConstants.productCreate,
      data: body,
    );

    // ignore: avoid_print
    print('CREATE PRODUCT RESPONSE: $res');
  }
}
