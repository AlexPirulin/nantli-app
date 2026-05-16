import '../models/user_model.dart';

class AuthService {
  // Simulación de base de datos local
  static final Map<String, String> _users = {
    'test@nantli.com': '123456',
  };

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    if (_users.containsKey(email.toLowerCase())) {
      throw Exception('Este correo electrónico ya está registrado.');
    }
    _users[email.toLowerCase()] = password;
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final normalizedEmail = email.toLowerCase();
    
    // Validación segura: mensaje genérico si falla cualquier cosa
    if (!_users.containsKey(normalizedEmail) || _users[normalizedEmail] != password) {
      throw Exception('Correo electrónico o contraseña incorrectos.');
    }
    
    print('Sesión iniciada para: $email');
  }
}
