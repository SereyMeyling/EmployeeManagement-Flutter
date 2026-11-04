class EmployeeModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String? password;
  final String? confirmPassword;
  final String? profile;
  final String role;
  final String status;

  EmployeeModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.password,
    this.confirmPassword,
    this.profile,
    this.role = 'USER',
    this.status = 'ACTIVE',
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: (json['id'] as num?)?.toInt(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      profile: json['profile']?.toString(),
      role: (json['role'] ?? 'USER').toString(),
      status: (json['status'] ?? 'ACTIVE').toString(),
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    return {
      'id': id ?? 0,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      if (includePassword) 'password': password ?? '',
      if (includePassword) 'confirmPassword': confirmPassword ?? '',
      'profile': profile ?? '',
      'role': role,
      'status': status,
    };
  }
}
