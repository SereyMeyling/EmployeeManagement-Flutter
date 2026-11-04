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

    if (employees.isEmpty) {
      fetch();
    }
  }

  // READ EMPLOYEES
  Future<void> fetch() async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await _repo.getEmployees();

      employees.assignAll(result);
    } on AppException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = 'Could not read employees from the server.';
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE EMPLOYEE
  Future<void> confirmDelete(EmployeeModel e) async {
    final fullName = '${e.firstName} ${e.lastName}'.trim();

    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text('Delete Employee'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "$fullName"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true || e.id == null) return;

    isLoading.value = true;

    try {
      await _repo.deleteEmployee(e.id!);

      // Remove from current list after successful API response.
      employees.removeWhere((x) => x.id == e.id);

      Get.snackbar(
        'Success',
        '$fullName has been deleted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } on AppException catch (err) {
      Get.snackbar(
        'Delete Failed',
        err.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } catch (err) {
      Get.snackbar(
        'Error',
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // CLEAR EMPLOYEES
  void clear() {
    employees.clear();
    error.value = null;
  }
}
