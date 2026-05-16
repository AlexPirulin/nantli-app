import '../models/user_model.dart';

class AuthService {
  static final Set<String> _registeredEmails = {'test@nantli.com'};

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    if (_registeredEmails.contains(email.toLowerCase())) {
      throw Exception('Este correo electrónico ya está registrado.');
    }
    _registeredEmails.add(email.toLowerCase());
  }
}
