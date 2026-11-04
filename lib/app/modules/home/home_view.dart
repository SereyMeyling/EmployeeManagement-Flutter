import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_controller.dart';
import '../employees/employees_view.dart';
import '../products/products_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Future<void> _confirmLogout() async {
    final ok = await Get.dialog<bool>(AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Get.back(result: true), child: const Text('Logout')),
      ],
    ));
    if (ok == true) Get.find<AuthController>().logout();
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['Products', 'Employees'];
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(titles[controller.index.value]),
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _confirmLogout,
              ),
            ],
          ),
          body: IndexedStack(
            index: controller.index.value,
            children: const [ProductsView(), EmployeesView()],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.index.value,
            onDestinationSelected: (i) => controller.index.value = i,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Products'),
              NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Employees'),
            ],
          ),
        ));
  }
}
