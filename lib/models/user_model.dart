import 'child_model.dart';

enum UserRole { tutor, caregiver }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? tutorNeeds;
  final List<ChildModel>? children;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.tutorNeeds,
    this.children,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
      'tutorNeeds': tutorNeeds,
      'children': children?.map((c) => c.toJson()).toList(),
    };
  }
}
