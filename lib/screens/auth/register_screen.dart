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
  bool _obscurePassword = true;

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
      if (mounted) _showSuccessDialog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.mark_email_read, size: 60, color: Color(0xFF2D1B4D)),
        content: const Text('¡Registro Exitoso! Vamos a configurar tu perfil de Tutor.', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              if (_selectedRole == UserRole.tutor) {
                Navigator.pushReplacementNamed(context, '/tutor-setup');
              } else {
                Navigator.pushReplacementNamed(context, '/caregiver-setup');
              }
            }, 
            child: const Text('Comenzar')
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D1B4D);
    final accentColor = isDarkMode ? const Color(0xFFD1C4E9) : colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: BackButton(color: textColor),
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
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 32),
              
              // Selector de Rol
              Row(
                children: [
                  _buildRoleCard('Soy Tutor', Icons.family_restroom, UserRole.tutor, isDarkMode),
                  const SizedBox(width: 16),
                  _buildRoleCard('Soy Cuidador', Icons.volunteer_activism, UserRole.caregiver, isDarkMode),
                ],
              ),
              
              const SizedBox(height: 32),
              
              _buildField(_nameController, 'Nombre Completo', Icons.person_outline, isDarkMode),
              const SizedBox(height: 20),
              _buildField(_emailController, 'Correo Electrónico', Icons.email_outlined, isDarkMode, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildField(_passwordController, 'Contraseña', Icons.lock_outline, isDarkMode, isPassword: true),
              
              const SizedBox(height: 32),
              
              // Botón de Registro
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: isDarkMode ? const Color(0xFF2D1B4D) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading 
                      ? CircularProgressIndicator(color: isDarkMode ? const Color(0xFF2D1B4D) : Colors.white) 
                      : const Text('Registrarme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Divisor
              Row(
                children: [
                  Expanded(child: Divider(color: isDarkMode ? Colors.white24 : Colors.black12)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('O continuar con', style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black45)),
                  ),
                  Expanded(child: Divider(color: isDarkMode ? Colors.white24 : Colors.black12)),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Botón de Google (Funcionalidad Real)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      await _authService.signInWithGoogle();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Inicio con Google exitoso!'), backgroundColor: Colors.green),
                        );
                        // Redirigir según el rol seleccionado previamente
                        if (_selectedRole == UserRole.tutor) {
                          Navigator.pushReplacementNamed(context, '/tutor-setup');
                        } else {
                          Navigator.pushReplacementNamed(context, '/caregiver-setup');
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al conectar con Google'), backgroundColor: Colors.redAccent),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 30),
                  ),
                  label: Text(
                    'Continuar con Google',
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
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
    final accentColor = const Color(0xFFD1C4E9);
    final primaryColor = const Color(0xFF2D1B4D);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? (isDarkMode ? accentColor : primaryColor) 
                : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? (isDarkMode ? accentColor : primaryColor) : (isDarkMode ? Colors.white10 : Colors.black12), 
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon, 
                color: isSelected 
                    ? (isDarkMode ? primaryColor : Colors.white) 
                    : (isDarkMode ? Colors.white54 : Colors.black45),
              ),
              const SizedBox(height: 8),
              Text(
                label, 
                style: TextStyle(
                  color: isSelected 
                      ? (isDarkMode ? primaryColor : Colors.white) 
                      : (isDarkMode ? Colors.white54 : Colors.black45), 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, bool isDarkMode, {bool isPassword = false, TextInputType? keyboardType}) {
    final accentColor = const Color(0xFFD1C4E9);
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black45),
        prefixIcon: Icon(icon, color: isDarkMode ? accentColor : const Color(0xFF2D1B4D)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: isDarkMode ? Colors.white54 : Colors.black45),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: isDarkMode ? accentColor : const Color(0xFF2D1B4D))),
      ),
    );
  }
}
