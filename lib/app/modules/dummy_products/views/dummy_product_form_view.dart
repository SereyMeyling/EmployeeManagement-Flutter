import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/dummy_product_model.dart';
import '../controllers/dummy_product_controller.dart';

class DummyProductFormView extends StatefulWidget {
  final DummyProductModel? product;

  const DummyProductFormView({
    super.key,
    this.product,
  });

  @override
  State<DummyProductFormView> createState() => _DummyProductFormViewState();
}

class _DummyProductFormViewState extends State<DummyProductFormView> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.find<DummyProductController>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController stockController;
  late final TextEditingController categoryController;
  late final TextEditingController brandController;
  late final TextEditingController thumbnailController;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    titleController = TextEditingController(
      text: product?.title ?? '',
    );

    descriptionController = TextEditingController(
      text: product?.description ?? '',
    );

    priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );

    stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );

    categoryController = TextEditingController(
      text: product?.category ?? '',
    );

    brandController = TextEditingController(
      text: product?.brand ?? '',
    );

    thumbnailController = TextEditingController(
      text: product?.thumbnail ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    brandController.dispose();
    thumbnailController.dispose();

    super.dispose();
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = DummyProductModel(
      id: widget.product?.id ?? 0,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      stock: int.parse(stockController.text.trim()),
      category: categoryController.text.trim(),
      brand: brandController.text.trim().isEmpty
          ? 'Unknown'
          : brandController.text.trim(),
      thumbnail: thumbnailController.text.trim(),
    );

    bool success;

    if (isEdit) {
      success = await controller.updateProduct(
        widget.product!.id,
        product,
      );
    } else {
      success = await controller.createProduct(product);
    }

    if (success && mounted) {
      Get.back();
    }
  }

  Widget buildField({
    required String label,
    required TextEditingController textController,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: keyboardType,
          enableInteractiveSelection: true,
          validator: validator ?? validateRequired,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Product' : 'Create Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField(
                label: 'Product Title',
                textController: titleController,
              ),
              buildField(
                label: 'Description',
                textController: descriptionController,
                maxLines: 3,
              ),
              buildField(
                label: 'Price',
                textController: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }

                  final price = double.tryParse(value.trim());

                  if (price == null || price < 0) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),
              buildField(
                label: 'Stock',
                textController: stockController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stock is required';
                  }

                  final stock = int.tryParse(value.trim());

                  if (stock == null || stock < 0) {
                    return 'Enter a valid stock number';
                  }

                  return null;
                },
              ),
              buildField(
                label: 'Category',
                textController: categoryController,
              ),
              buildField(
                label: 'Brand',
                textController: brandController,
                validator: (_) => null,
              ),
              buildField(
                label: 'Thumbnail URL',
                textController: thumbnailController,
                keyboardType: TextInputType.url,
                validator: (_) => null,
              ),
              const SizedBox(height: 12),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value ? null : saveProduct,
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            isEdit ? Icons.save : Icons.add,
                          ),
                    label: Text(
                      controller.isSaving.value
                          ? 'Please wait...'
                          : isEdit
                              ? 'Update Product'
                              : 'Create Product',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
