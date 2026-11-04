import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'employee_form_controller.dart';

class EmployeeFormView extends GetView<EmployeeFormController> {
  const EmployeeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(
          controller.isEdit ? 'Edit Employee' : 'Add Employee',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information
                _sectionTitle(
                  'Personal Information',
                  Icons.person_outline,
                ),
                const SizedBox(height: 12),

                _inputField(
                  controller: controller.firstNameCtrl,
                  label: 'First Name',
                  icon: Icons.person_outline,
                  required: true,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 14),

                _inputField(
                  controller: controller.lastNameCtrl,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                  required: true,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 14),

                _inputField(
                  controller: controller.phoneCtrl,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  required: true,
                  keyboardType: TextInputType.phone,
                  validator: _requiredValidator,
                ),

                const SizedBox(height: 24),

                // Account Information
                _sectionTitle(
                  'Account Information',
                  Icons.account_circle_outlined,
                ),
                const SizedBox(height: 12),

                _inputField(
                  controller: controller.usernameCtrl,
                  label: 'Username',
                  icon: Icons.alternate_email,
                  required: true,
                  validator: (value) {
                    final error = _requiredValidator(value);
                    if (error != null) return error;

                    if (value!.trim().length < 3) {
                      return 'Username must be at least 3 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),

                _inputField(
                  controller: controller.emailCtrl,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  required: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final error = _requiredValidator(value);
                    if (error != null) return error;

                    if (!GetUtils.isEmail(value!.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Password fields
                _inputField(
                  controller: controller.passwordCtrl,
                  label: controller.isEdit
                      ? 'New Password (Optional)'
                      : 'Password',
                  icon: Icons.lock_outline,
                  required: !controller.isEdit,
                  obscureText: true,
                  validator: (value) {
                    if (controller.isEdit && (value == null || value.isEmpty)) {
                      return null;
                    }

                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),

                _inputField(
                  controller: controller.confirmPasswordCtrl,
                  label: controller.isEdit
                      ? 'Confirm New Password'
                      : 'Confirm Password',
                  icon: Icons.lock_reset_outlined,
                  required: !controller.isEdit,
                  obscureText: true,
                  validator: (value) {
                    final password = controller.passwordCtrl.text;

                    if (password.isEmpty && controller.isEdit) {
                      return null;
                    }

                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != password) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                _inputField(
                  controller: controller.profileCtrl,
                  label: 'Profile Image URL (Optional)',
                  icon: Icons.image_outlined,
                  keyboardType: TextInputType.url,
                ),

                const SizedBox(height: 24),

                // Role & Status
                _sectionTitle(
                  'Role & Status',
                  Icons.admin_panel_settings_outlined,
                ),
                const SizedBox(height: 12),

                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.role.value,
                    decoration: _decoration(
                      'Role',
                      Icons.badge_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'USER',
                        child: Text('USER'),
                      ),
                      DropdownMenuItem(
                        value: 'ADMIN',
                        child: Text('ADMIN'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.role.value = value;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 14),

                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.status.value,
                    decoration: _decoration(
                      'Status',
                      Icons.toggle_on_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'ACTIVE',
                        child: Text('ACTIVE'),
                      ),
                      DropdownMenuItem(
                        value: 'INACTIVE',
                        child: Text('INACTIVE'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.status.value = value;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Save Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed:
                          controller.isSaving.value ? null : controller.save,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: controller.isSaving.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              controller.isEdit
                                  ? Icons.save_outlined
                                  : Icons.person_add_alt_1,
                            ),
                      label: Text(
                        controller.isSaving.value
                            ? 'Please wait...'
                            : controller.isEdit
                                ? 'Update Employee'
                                : 'Create Employee',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Header
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2563EB),
          size: 21,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
      ],
    );
  }

  // Text Field
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: _decoration(
        required ? '$label *' : label,
        icon,
      ),
    );
  }

  // Input Decoration
  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF2563EB),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }
}
