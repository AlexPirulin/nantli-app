import 'package:flutter/material.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(const NantliApp());
}

class NantliApp extends StatelessWidget {
  const NantliApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF2D1B4D);
    const accentPurple = Color(0xFF4A2C82);

    return MaterialApp(
      title: 'Nantli',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          primary: primaryPurple,
          onPrimary: Colors.white,
          secondary: accentPurple,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFFBA68C8),
          primary: const Color(0xFFE1BEE7),
          onPrimary: primaryPurple,
          secondary: const Color(0xFFCE93D8),
          surface: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
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
    const primaryPurple = Color(0xFF2D1B4D);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withOpacity(isDarkMode ? 0.1 : 0.05),
                    colorScheme.surface,
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      isDarkMode 
                          ? 'assets/images/logo_dark.png' 
                          : 'assets/images/logo_light.png',
                      height: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          Icon(Icons.child_care_rounded, size: 120, color: colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Nantli',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: isDarkMode ? Colors.white : primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Confianza y cuidado para tus pequeños, a un solo toque de distancia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black45,
                      height: 1.6,
                    ),
                  ),
                  const Spacer(flex: 3),
                  Column(
                    children: [
                      _buildButton(
                        context,
                        label: 'Iniciar Sesión',
                        isPrimary: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        context,
                        label: 'Registrarme',
                        isPrimary: false,
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

  Widget _buildButton(BuildContext context, {required String label, required bool isPrimary, required VoidCallback onPressed}) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: isPrimary 
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.primary, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(label, style: TextStyle(color: colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
    );
  }
}
