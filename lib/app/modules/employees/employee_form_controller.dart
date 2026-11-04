import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/employee_repository.dart';
import 'employee_controller.dart';

class EmployeeFormController extends GetxController {
  final EmployeeRepository _repo = Get.find();

  final formKey = GlobalKey<FormState>();
  final accountCtrl = TextEditingController();
  final shopCtrl = TextEditingController();
  final outletCtrl = TextEditingController();
  final deviceCtrl = TextEditingController();
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
      accountCtrl.text = arg.userAccountId;
      shopCtrl.text = arg.shopId ?? '';
      outletCtrl.text = arg.outletId?.toString() ?? '';
      deviceCtrl.text = arg.deviceId ?? '';
      status.value = arg.status.toUpperCase() == 'ACTIVE' ? 'ACTIVE' : 'INACTIVE';
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final model = EmployeeModel(
        id: editing?.id,
        userAccountId: accountCtrl.text.trim(),
        shopId: shopCtrl.text.trim(),
        deviceId: deviceCtrl.text.trim(),
        status: status.value,
        outletId: int.tryParse(outletCtrl.text.trim()),
      );
      if (isEdit) {
        await _repo.updateEmployee(model);
      } else {
        await _repo.createEmployee(model);
      }
      await Get.find<EmployeeController>().fetch();
      Get.back();
      Get.snackbar('Success', isEdit ? 'Employee updated' : 'Employee added',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
    } on AppException catch (e) {
      Get.snackbar('Save failed', e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12));
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    accountCtrl.dispose();
    shopCtrl.dispose();
    outletCtrl.dispose();
    deviceCtrl.dispose();
    super.onClose();
  }
}
