import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido de nuevo!'),
            backgroundColor: Colors.green,
          ),
        );
        // Aquí podrías navegar al Home principal
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
              const SizedBox(height: 20),
              Text(
                '¡Hola de nuevo!', 
                style: TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.w900, 
                  color: textColor,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión para continuar cuidando lo que más quieres.', 
                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white60 : Colors.black54),
              ),
              
              const SizedBox(height: 48),
              
              _buildField(
                _emailController, 
                'Correo Electrónico', 
                Icons.email_outlined, 
                isDarkMode,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Ingresa tu correo' : null,
              ),
              const SizedBox(height: 20),
              _buildField(
                _passwordController, 
                'Contraseña', 
                Icons.lock_outline, 
                isDarkMode, 
                isPassword: true,
                validator: (v) => v!.isEmpty ? 'Ingresa tu contraseña' : null,
              ),
              
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botón de Inicio de Sesión
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: isDarkMode ? const Color(0xFF2D1B4D) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                      ? CircularProgressIndicator(color: isDarkMode ? const Color(0xFF2D1B4D) : Colors.white) 
                      : const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Divisor
              Row(
                children: [
                  Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.black12)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('O', style: TextStyle(color: isDarkMode ? Colors.white30 : Colors.black38)),
                  ),
                  Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.black12)),
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
                          const SnackBar(content: Text('¡Bienvenido con Google!'), backgroundColor: Colors.green),
                        );
                        Navigator.pushReplacementNamed(context, '/'); // O a tu pantalla principal
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
                  icon: Image.asset('assets/images/google_logo.png', height: 24),
                  label: Text(
                    'Entrar con Google',
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta? ', 
                    style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                    child: Text(
                      'Regístrate',
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    bool isDarkMode, 
    {bool isPassword = false, TextInputType? keyboardType, String? Function(String?)? validator}
  ) {
    final accentColor = const Color(0xFFD1C4E9);
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      validator: validator,
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
