import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/employee_repository.dart';
import 'employee_controller.dart';

class EmployeeFormController extends GetxController {
  final EmployeeRepository _repo = Get.find();

  final formKey = GlobalKey<FormState>();

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final profileCtrl = TextEditingController();

  final role = 'USER'.obs;
  final status = 'ACTIVE'.obs;

  final isSaving = false.obs;

  EmployeeModel? editing;

  bool get isEdit => editing != null;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;

    if (arg is EmployeeModel) {
      editing = arg;

      firstNameCtrl.text = arg.firstName;
      lastNameCtrl.text = arg.lastName;
      usernameCtrl.text = arg.username;
      emailCtrl.text = arg.email;
      phoneCtrl.text = arg.phoneNumber;
      profileCtrl.text = arg.profile ?? '';

      role.value = arg.role;
      status.value = arg.status;
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    if (!isEdit && passwordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar(
        'Validation Error',
        'Password and Confirm Password do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;

    try {
      final model = EmployeeModel(
        id: editing?.id,
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        username: usernameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),
        password: passwordCtrl.text.isEmpty ? null : passwordCtrl.text,
        confirmPassword:
            confirmPasswordCtrl.text.isEmpty ? null : confirmPasswordCtrl.text,
        profile: profileCtrl.text.trim(),
        role: role.value,
        status: status.value,
      );

      if (isEdit) {
        await _repo.updateEmployee(model);
      } else {
        await _repo.createEmployee(model);
      }

      await Get.find<EmployeeController>().fetch();

      Get.back();

      Get.snackbar(
        'Success',
        isEdit ? 'Employee updated' : 'Employee created',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    } on AppException catch (e) {
      Get.snackbar(
        'Save failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    profileCtrl.dispose();

    super.onClose();
  }
}
