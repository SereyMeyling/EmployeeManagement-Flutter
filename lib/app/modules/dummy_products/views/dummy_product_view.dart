import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dummy_product_controller.dart';

class DummyProductView extends GetView<DummyProductController> {
  const DummyProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DummyJSON Products'),
        actions: [
          IconButton(
            onPressed: controller.fetchProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value!),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchProducts,
                  child: const Text('Try Again'),
                ),
              ],
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
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Image.network(
                    product.thumbnail,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 50,
                      );
                    },
                  ),
                  title: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${product.category}'),
                      Text('Brand: ${product.brand}'),
                      Text('Stock: ${product.stock}'),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
