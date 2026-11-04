import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/token_storage.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Employee Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: TokenStorage.hasToken ? Routes.home : Routes.login,
      getPages: AppPages.pages,
    );
  }
}



// {
//   "id": 0,
//   "firstName": "TestAdmin2026",
//   "lastName": "Employee2026",
//   "username": "admin_test_2026",
//   "email": "admin_test_2026@example.com",
//   "phoneNumber": "098765432",
//   "password": "Admin@123456",
//   "confirmPassword": "Admin@123456",
//   "profile": "",
//   "role": "ADMIN",
//   "status": "ACTIVE"
// }