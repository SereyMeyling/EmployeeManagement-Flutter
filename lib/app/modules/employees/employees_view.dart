import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../home/state_views.dart';
import 'employee_controller.dart';

class EmployeesView extends GetView<EmployeeController> {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: () => Get.toNamed(Routes.employeeForm),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text(
          'Add Employee',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.employees.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error.value != null && controller.employees.isEmpty) {
            return ErrorState(
              message: controller.error.value!,
              onRetry: controller.fetch,
            );
          }

          if (controller.employees.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              message: 'No employees yet',
            );
          }

          final employees = controller.employees;

          final activeCount =
              employees.where((e) => e.status.toUpperCase() == 'ACTIVE').length;

          final inactiveCount = employees.length - activeCount;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.fetch,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          20,
                          20,
                          16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Employee Management',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172033),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Manage your team members and accounts',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Statistics
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    title: 'Total Employees',
                                    value: employees.length.toString(),
                                    icon: Icons.people_alt_outlined,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Active',
                                    value: activeCount.toString(),
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Inactive',
                                    value: inactiveCount.toString(),
                                    icon: Icons.pause_circle_outline,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'All Employees',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172033),
                                  ),
                                ),
                                Text(
                                  '${employees.length} members',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Employee list
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final employee = employees[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _EmployeeCard(
                                employee: employee,
                                onEdit: () {
                                  Get.toNamed(
                                    Routes.employeeForm,
                                    arguments: employee,
                                  );
                                },
                                onDelete: () {
                                  controller.confirmDelete(employee);
                                },
                              ),
                            );
                          },
                          childCount: employees.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// Statistics Card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Employee Card
class _EmployeeCard extends StatelessWidget {
  final dynamic employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee.status.toUpperCase() == 'ACTIVE';

    final fullName = '${employee.firstName} ${employee.lastName}'.trim();

    final avatarText = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFE8F0FF),
                child: Text(
                  avatarText,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isEmpty ? 'Unnamed Employee' : fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${employee.username}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                status: employee.status,
                isActive: isActive,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 13),
          _InfoRow(
            icon: Icons.email_outlined,
            text: employee.email.isEmpty ? 'No email' : employee.email,
          ),
          const SizedBox(height: 9),
          _InfoRow(
            icon: Icons.phone_outlined,
            text: employee.phoneNumber.isEmpty
                ? 'No phone number'
                : employee.phoneNumber,
          ),
          const SizedBox(height: 9),
          _InfoRow(
            icon: Icons.badge_outlined,
            text: 'Role: ${employee.role}',
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(
                    color: Color(0xFF2563EB),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Status Badge
class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isActive;

  const _StatusBadge({
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Employee Information Row
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
