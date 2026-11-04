/// Employees are backed by the admin user-management endpoints.
/// Fields follow the BaseUserReq schema shown in Swagger.
class EmployeeModel {
  final int? id;
  final String userAccountId;
  final String? shopId;
  final String? deviceId;
  final String status;
  final int? outletId;

  EmployeeModel({
    this.id,
    required this.userAccountId,
    this.shopId,
    this.deviceId,
    this.status = 'ACTIVE',
    this.outletId,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> j) => EmployeeModel(
        id: (j['id'] as num?)?.toInt(),
        userAccountId:
            (j['userAccountId'] ?? j['phoneNumber'] ?? j['username'] ?? '').toString(),
        shopId: j['shopId']?.toString(),
        deviceId: j['deviceId']?.toString(),
        status: (j['status'] ?? 'ACTIVE').toString(),
        outletId: (j['outletId'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'id': id ?? 0,
        'userAccountId': userAccountId,
        'shopId': shopId ?? '',
        'deviceId': deviceId ?? '',
        'status': status,
        'outletId': outletId ?? 0,
      };
}
