import '../../core/api_constants.dart';
import '../../core/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _client;
  ProductRepositoryImpl(this._client);

  @override
  Future<List<ProductModel>> getProducts() async {
    final data = await _client.post(ApiConstants.productList, data: {});
    return DioClient.extractList(data).map(ProductModel.fromJson).toList();
  }
}
