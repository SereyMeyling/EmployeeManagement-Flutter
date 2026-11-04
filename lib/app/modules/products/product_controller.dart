import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repo;

  ProductController(this._repo);

  // Products
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;

  // Categories
  final categories = <Map<String, dynamic>>[].obs;
  final isLoadingCategories = false.obs;
  final isCreatingCategory = false.obs;

  final error = RxnString();

  @override
  void onReady() {
    super.onReady();

    if (products.isEmpty) {
      fetch();
    }
  }

  // Fetch Products
  Future<void> fetch() async {
    isLoading.value = true;
    error.value = null;

    try {
      products.assignAll(await _repo.getProducts());
    } on AppException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = 'Could not read products from the server.';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Categories
  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;

    try {
      final result = await _repo.getCategories();
      categories.assignAll(result);
    } on AppException catch (e) {
      Get.snackbar(
        'Category Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load product categories.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Create Category
  Future<int?> createCategory(String name) async {
    if (name.trim().isEmpty) return null;

    isCreatingCategory.value = true;

    try {
      await _repo.createCategory(name.trim());

      await fetchCategories();

      final newCategory = categories.firstWhereOrNull(
        (category) =>
            category['name']?.toString().toLowerCase() ==
            name.trim().toLowerCase(),
      );

      final newId = (newCategory?['id'] as num?)?.toInt();

      if (newId == null) {
        Get.snackbar(
          'Warning',
          'Category was submitted, but its ID could not be found.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return newId;
    } on AppException catch (e) {
      Get.snackbar(
        'Create Category Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not create category.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isCreatingCategory.value = false;
    }
  }

  // Create Product
  Future<bool> createProduct(ProductModel product) async {
    isCreating.value = true;

    try {
      await _repo.createProduct(product);
      await fetch();
      return true; // លុប Get.snackbar ចេញ
    } on AppException catch (e) {
      Get.snackbar('Create Product Failed', e.message,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Could not create product.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // Clear Data
  void clear() {
    products.clear();
    categories.clear();
    error.value = null;
  }
}
