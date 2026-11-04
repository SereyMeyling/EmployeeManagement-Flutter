import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/api_constants.dart';
import '../home/state_views.dart';
import 'product_controller.dart';

class ProductsView extends GetView<ProductController> {
  const ProductsView({super.key});

  String? _img(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    return '${ApiConstants.baseUrl}/api/public/view/image?filename=$url';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value != null && controller.products.isEmpty) {
        return ErrorState(message: controller.error.value!, onRetry: controller.fetch);
      }
      if (controller.products.isEmpty) {
        return const EmptyState(icon: Icons.inventory_2_outlined, message: 'No products yet');
      }
      return RefreshIndicator(
        onRefresh: controller.fetch,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final p = controller.products[i];
            final img = _img(p.imageUrl);
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: img == null
                        ? const ColoredBox(
                            color: Color(0x11000000), child: Icon(Icons.image_outlined))
                        : Image.network(img,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
                  ),
                ),
                title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text([
                  if (p.categoryName != null) p.categoryName!,
                  if (p.description != null && p.description!.isNotEmpty) p.description!,
                ].join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: p.price == null
                    ? null
                    : Text('\$${p.price!.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
              ),
            );
          },
        ),
      );
    });
  }
}
