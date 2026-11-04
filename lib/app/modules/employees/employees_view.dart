import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../home/state_views.dart';
import 'employee_controller.dart';

class EmployeesView extends GetView<EmployeeController> {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.employeeForm),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.employees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null && controller.employees.isEmpty) {
          return ErrorState(message: controller.error.value!, onRetry: controller.fetch);
        }
        if (controller.employees.isEmpty) {
          return const EmptyState(icon: Icons.people_outline, message: 'No employees yet');
        }
        return Stack(children: [
          RefreshIndicator(
            onRefresh: controller.fetch,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: controller.employees.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final e = controller.employees[i];
                final active = e.status.toUpperCase() == 'ACTIVE';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(e.userAccountId.isEmpty
                          ? '?'
                          : e.userAccountId[0].toUpperCase()),
                    ),
                    title: Text(e.userAccountId,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        'Shop: ${e.shopId ?? '-'}  •  Outlet: ${e.outletId ?? '-'}\n${e.status}'),
                    isThreeLine: true,
                    onTap: () => Get.toNamed(Routes.employeeForm, arguments: e),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.circle, size: 10, color: active ? Colors.green : Colors.grey),
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => Get.toNamed(Routes.employeeForm, arguments: e),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => controller.confirmDelete(e),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          if (controller.isLoading.value)
            const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
        ]);
      }),
    );
  }
}
