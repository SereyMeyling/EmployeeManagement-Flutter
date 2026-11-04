import '../../core/api_constants.dart';
import '../../core/dio_client.dart';
import '../models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeModel>> getEmployees();
  Future<void> createEmployee(EmployeeModel e);
  Future<void> updateEmployee(EmployeeModel e);
  Future<void> deleteEmployee(int id);
}

class EmployeeRepositoryImpl implements EmployeeRepository {
  final DioClient _client;

  EmployeeRepositoryImpl(this._client);

  // READ
  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final data = await _client.post(
      ApiConstants.employeeList,
    );

    return DioClient.extractList(data)
        .map((json) => EmployeeModel.fromJson(json))
        .toList();
  }

  // CREATE
  @override
  Future<void> createEmployee(EmployeeModel e) async {
    await _client.post(
      ApiConstants.employeeCreate,
      data: e.toJson(includePassword: true),
    );
  }

  // UPDATE
  @override
  Future<void> updateEmployee(EmployeeModel e) async {
    await _client.post(
      ApiConstants.employeeUpdate,
      data: e.toJson(
        includePassword: e.password != null && e.password!.isNotEmpty,
      ),
    );
  }

  // DELETE
  @override
  Future<void> deleteEmployee(int id) async {
    await _client.post(
      ApiConstants.employeeDelete,
      data: {
        'id': id,
      },
    );
  }
}
