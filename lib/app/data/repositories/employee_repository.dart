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

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    // status=ALL includes deleted users, so ask for ACTIVE/non-deleted ones.
    final data = await _client.post(ApiConstants.employeeList, data: {
      'id': 0,
      'userAccountId': '',
      'shopId': '',
      'deviceId': '',
      'status': '',
      'outletId': 0,
    });
    return DioClient.extractList(data).map(EmployeeModel.fromJson).toList();
  }

  @override
  Future<void> createEmployee(EmployeeModel e) =>
      _client.post(ApiConstants.employeeCreate, data: e.toJson());

  @override
  Future<void> updateEmployee(EmployeeModel e) =>
      _client.post(ApiConstants.employeeUpdate, data: e.toJson());

  @override
  Future<void> deleteEmployee(int id) =>
      _client.post(ApiConstants.employeeDelete, data: {'id': id});
}
