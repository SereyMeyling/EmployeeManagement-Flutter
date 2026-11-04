import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'employee_form_controller.dart';

class EmployeeFormView extends GetView<EmployeeFormController> {
  const EmployeeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.isEdit ? 'Edit employee' : 'Add employee')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(children: [
              TextFormField(
                controller: controller.accountCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    labelText: 'User account ID *', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Account ID is required';
                  if (v.trim().length < 3) return 'At least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.shopCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    labelText: 'Shop ID', prefixIcon: Icon(Icons.store_outlined)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.outletCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    labelText: 'Outlet ID', prefixIcon: Icon(Icons.storefront_outlined)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return int.tryParse(v.trim()) == null ? 'Numbers only' : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.deviceCtrl,
                decoration: const InputDecoration(
                    labelText: 'Device ID', prefixIcon: Icon(Icons.phone_android)),
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.status.value,
                    decoration: const InputDecoration(
                        labelText: 'Status', prefixIcon: Icon(Icons.toggle_on_outlined)),
                    items: const [
                      DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
                      DropdownMenuItem(value: 'INACTIVE', child: Text('INACTIVE')),
                    ],
                    onChanged: (v) => controller.status.value = v ?? 'ACTIVE',
                  )),
              const SizedBox(height: 28),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: controller.isSaving.value ? null : controller.save,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      icon: controller.isSaving.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save_outlined),
                      label: Text(controller.isEdit ? 'Update' : 'Create'),
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
