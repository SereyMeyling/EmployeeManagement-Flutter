import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/employee_repository.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _repo;
  EmployeeController(this._repo);

  final employees = <EmployeeModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onReady() {
    super.onReady();
    if (employees.isEmpty) fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    error.value = null;
    try {
      employees.assignAll(await _repo.getEmployees());
    } on AppException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Could not read employees from the server.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmDelete(EmployeeModel e) async {
    final ok = await Get.dialog<bool>(AlertDialog(
      title: const Text('Delete employee'),
      content: Text('Delete "${e.userAccountId}"? This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Get.back(result: true),
          child: const Text('Delete'),
        ),
      ],
    ));
    if (ok != true || e.id == null) return;

    isLoading.value = true;
    try {
      await _repo.deleteEmployee(e.id!);
      employees.removeWhere((x) => x.id == e.id);
      Get.snackbar('Deleted', '${e.userAccountId} was removed',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
    } on AppException catch (err) {
      Get.snackbar('Delete failed', err.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12));
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    employees.clear();
    error.value = null;
  }
}
