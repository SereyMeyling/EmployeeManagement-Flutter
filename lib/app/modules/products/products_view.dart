import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dummy_products/controllers/dummy_product_controller.dart';
import '../dummy_products/views/dummy_product_form_view.dart';

class ProductsView extends GetView<DummyProductController> {
  const ProductsView({super.key});

  // EDIT PRODUCT
  void editProduct(product) {
    Get.to(
      () => DummyProductFormView(product: product),
    );
  }

  // DELETE CONFIRMATION
  void confirmDelete(int id, String title) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "$title"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: controller.isSaving.value
                ? null
                : () async {
                    Get.back();
                    await controller.deleteProduct(id);
                  },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Refresh Products',
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchProducts,
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error.value != null && controller.products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 55,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.error.value!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.fetchProducts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: controller.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final product = controller.products[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: Image.network(
                                product.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return const ColoredBox(
                                    color: Color(0x11000000),
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Category: ${product.category}'),
                                Text('Brand: ${product.brand}'),
                                Text('Stock: ${product.stock}'),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              editProduct(product);
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                            ),
                            label: const Text('Edit'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              confirmDelete(
                                product.id,
                                product.title,
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 18,
                            ),
                            label: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),

      // CREATE PRODUCT
      floatingActionButton: FloatingActionButton(
        heroTag: 'products_add_fab',
        tooltip: 'Add Product',
        onPressed: () {
          Get.to(
            () => const DummyProductFormView(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
