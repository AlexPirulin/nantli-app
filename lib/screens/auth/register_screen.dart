import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  UserRole _selectedRole = UserRole.tutor;
  bool _isLoading = false;
  final bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
      );

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.mark_email_read, size: 60, color: Color(0xFF2D1B4D)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¡Registro Exitoso!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Hemos enviado un correo de confirmación a ${_emailController.text}.\n\nPor favor, verifica tu bandeja de entrada para activar tu cuenta.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF2D1B4D);
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: titleColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Únete a la comunidad de cuidado infantil más confiable.',
                style: TextStyle(fontSize: 16, color: subtitleColor),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                '¿Quién eres?',
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold, 
                  color: isDarkMode ? Colors.white54 : Colors.black45,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildRoleCard('Soy Tutor', Icons.family_restroom, UserRole.tutor, isDarkMode),
                  const SizedBox(width: 16),
                  _buildRoleCard('Soy Cuidador', Icons.volunteer_activism, UserRole.caregiver, isDarkMode),
                ],
              ),
              
              const SizedBox(height: 32),
              
              _buildTextField(_nameController, 'Nombre Completo', Icons.person_outline, isDarkMode),
              const SizedBox(height: 20),
              _buildTextField(_emailController, 'Correo Electrónico', Icons.email_outlined, isDarkMode, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, 'Contraseña', Icons.lock_outline, isDarkMode, isPassword: true),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? colorScheme.primary : const Color(0xFF2D1B4D),
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: isDarkMode ? Colors.black : Colors.white)
                      : const Text('Registrarme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String label, IconData icon, UserRole role, bool isDarkMode) {
    final isSelected = _selectedRole == role;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? (isDarkMode ? primaryColor : const Color(0xFF2D1B4D)) 
                : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? (isDarkMode ? primaryColor : const Color(0xFF2D1B4D)) 
                  : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2)),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? (isDarkMode ? Colors.black : Colors.white) : (isDarkMode ? Colors.white54 : Colors.black45)),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? (isDarkMode ? Colors.black : Colors.white) : (isDarkMode ? Colors.white54 : Colors.black45))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isDarkMode, {bool isPassword = false, TextInputType? keyboardType}) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: isDarkMode ? primaryColor : const Color(0xFF2D1B4D)),
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        labelStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.black45),
      ),
    );
  }
}
