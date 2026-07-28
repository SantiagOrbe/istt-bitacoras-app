import 'user_role.dart';

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String company;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.company,
    required this.role,
  });
}