import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializamos Firebase
  runApp(const NantliApp());
}

class NantliApp extends StatelessWidget {
  const NantliApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF2D1B4D);
    const accentLavender = Color(0xFFD1C4E9);

    return MaterialApp(
      title: 'Nantli',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Restauramos el soporte para ambos temas
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          primary: primaryPurple,
          onPrimary: Colors.white,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: accentLavender,
          primary: accentLavender,
          onPrimary: primaryPurple,
          surface: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo dinámico (Oscuro en dark mode, blanco con degradado sutil en light mode)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: isDarkMode 
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2D1B3D), Color(0xFF121212)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colorScheme.primary.withOpacity(0.05), Colors.white],
                    ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  
                  // Logo dinámico
                  Image.asset(
                    isDarkMode ? 'assets/images/logo_dark.png' : 'assets/images/logo_light.png',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.child_care_rounded, size: 120, color: colorScheme.primary),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Text(
                    'Confianza y cuidado para tus pequeños.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  Column(
                    children: [
                      _buildButton(
                        context,
                        label: 'Iniciar Sesión',
                        isPrimary: true,
                        isDarkMode: isDarkMode,
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        context,
                        label: 'Registrarme',
                        isPrimary: false,
                        isDarkMode: isDarkMode,
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required bool isPrimary, required bool isDarkMode, required VoidCallback onPressed}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? const Color(0xFFD1C4E9) : colorScheme.primary,
            foregroundColor: isDarkMode ? const Color(0xFF2D1B4D) : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: isDarkMode ? Colors.white38 : colorScheme.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white : colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
