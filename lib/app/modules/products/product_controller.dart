import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repo;
  ProductController(this._repo);

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onReady() {
    super.onReady();
    // Controller is permanent; only load if we are already signed in.
    if (products.isEmpty) fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    error.value = null;
    try {
      products.assignAll(await _repo.getProducts());
    } on AppException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Could not read products from the server.';
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    products.clear();
    error.value = null;
  }
}
