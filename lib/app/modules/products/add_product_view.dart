import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/product_model.dart';
import 'product_controller.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final ProductController controller = Get.find<ProductController>();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _priceController = TextEditingController();
  final _costController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    controller.fetchCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value.trim());

    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'Value cannot be negative';
    }

    return null;
  }

  Future<void> _showAddCategoryDialog() async {
    final nameCtrl = TextEditingController();

    final name = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Create New Category'),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'Enter category name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = nameCtrl.text.trim();

              if (value.isEmpty) {
                Get.snackbar(
                  'Validation',
                  'Please enter category name.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back(result: value);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (name == null || name.trim().isEmpty) return;

    final newId = await controller.createCategory(name.trim());

    if (newId != null && mounted) {
      setState(() {
        _selectedCategoryId = newId;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      Get.snackbar(
        'Validation',
        'Please select a product category.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedCategory = controller.categories.firstWhereOrNull(
      (category) => (category['id'] as num?)?.toInt() == _selectedCategoryId,
    );

    final product = ProductModel(
      name: _nameController.text.trim(),
      productCode: _codeController.text.trim(),
      categoryId: _selectedCategoryId,
      categoryName: selectedCategory?['name']?.toString(),
      price: double.parse(_priceController.text.trim()),
      cost: double.parse(_costController.text.trim()),
      stockQuantity: double.parse(_stockController.text.trim()),
      description: _descriptionController.text.trim(),
      status: 'ACTIVE',
    );

    final success = await controller.createProduct(product);

    if (success && mounted) {
      // ត្រឡប់ក្រោយសិន ហើយបង្ហាញ snackbar បន្ទាប់
      Get.back();
      Get.snackbar(
        'Success',
        'Product created successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController textController,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: textController,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    return Obx(() {
      if (controller.isLoadingCategories.value) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final hasCategories = controller.categories.isNotEmpty;

      final selectedExists = controller.categories.any(
        (category) => (category['id'] as num?)?.toInt() == _selectedCategoryId,
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: selectedExists ? _selectedCategoryId : null,
                hint: Text(
                  hasCategories ? 'Select category' : 'No categories yet',
                ),
                decoration: InputDecoration(
                  labelText: 'Product Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: controller.categories
                    .map((category) {
                      final id = (category['id'] as num?)?.toInt();

                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(
                          category['name']?.toString() ?? 'Category $id',
                        ),
                      );
                    })
                    .where((item) => item.value != null)
                    .toList(),
                onChanged: hasCategories
                    ? (value) => setState(() => _selectedCategoryId = value)
                    : null,
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'Add Category',
              onPressed: _showAddCategoryDialog,
              icon: const Icon(Icons.add),
            ),
            IconButton(
              tooltip: 'Reload Categories',
              onPressed: controller.fetchCategories,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTextField(
                label: 'Product Name',
                textController: _nameController,
                validator: _requiredValidator,
              ),
              _buildTextField(
                label: 'Product Code',
                textController: _codeController,
                validator: _requiredValidator,
              ),
              _buildCategoryField(),
              _buildTextField(
                label: 'Price',
                textController: _priceController,
                validator: _numberValidator,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              _buildTextField(
                label: 'Cost',
                textController: _costController,
                validator: _numberValidator,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              _buildTextField(
                label: 'Stock Quantity',
                textController: _stockController,
                validator: _numberValidator,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              _buildTextField(
                label: 'Description',
                textController: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Obx(
                () => SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isCreating.value ? null : _submit,
                    child: controller.isCreating.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create Product'),
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
