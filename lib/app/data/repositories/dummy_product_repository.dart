import 'package:dio/dio.dart';

import '../models/dummy_product_model.dart';

class DummyProductRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // READ: Get all products
  Future<List<DummyProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/products');

      final List<dynamic> products = response.data['products'];

      return products.map((json) => DummyProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data ?? e.message ?? 'Failed to load products',
      );
    }
  }

  // CREATE: Add product
  Future<DummyProductModel> createProduct(
    DummyProductModel product,
  ) async {
    try {
      final response = await _dio.post(
        '/products/add',
        data: product.toJson(),
      );

      return DummyProductModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data ?? e.message ?? 'Failed to create product',
      );
    }
  }

  // UPDATE: Edit product
  Future<void> updateProduct(
    int id,
    DummyProductModel product,
  ) async {
    try {
      await _dio.put(
        '/products/$id',
        data: product.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data ?? e.message ?? 'Failed to update product',
      );
    }
  }

  // DELETE: Delete product
  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data ?? e.message ?? 'Failed to delete product',
      );
    }
  }
}
