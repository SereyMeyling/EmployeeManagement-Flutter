import 'package:get/get.dart';

import '../../../data/models/dummy_product_model.dart';
import '../../../data/repositories/dummy_product_repository.dart';

class DummyProductController extends GetxController {
  final DummyProductRepository _repository;

  DummyProductController(this._repository);

  final products = <DummyProductModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // READ
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = null;

      final result = await _repository.getProducts();

      products.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // CREATE
  Future<bool> createProduct(DummyProductModel product) async {
    try {
      isSaving.value = true;

      final createdProduct = await _repository.createProduct(product);

      products.insert(0, createdProduct);

      Get.snackbar(
        'Success',
        'Product created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Create failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // UPDATE
  Future<bool> updateProduct(
    int id,
    DummyProductModel updatedProduct,
  ) async {
    try {
      isSaving.value = true;

      await _repository.updateProduct(id, updatedProduct);

      final index = products.indexWhere(
        (product) => product.id == id,
      );

      if (index != -1) {
        products[index] = updatedProduct;
        products.refresh();
      }

      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Update failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // DELETE
  Future<bool> deleteProduct(int id) async {
    try {
      isSaving.value = true;

      await _repository.deleteProduct(id);

      products.removeWhere(
        (product) => product.id == id,
      );

      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Delete failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
