import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para escuchar cambios en el estado de la autenticación
  Stream<User?> get user => _auth.authStateChanges();

  // Registro con Email y Contraseña Real
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      
      if (user != null) {
        // Actualizar el nombre del perfil en Firebase
        await user.updateDisplayName(name);
        // Enviar correo de verificación real
        await user.sendEmailVerification();
        
        // TODO: Aquí podrías guardar el 'role' en Firestore
        print('Usuario registrado y correo de verificación enviado');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Este correo electrónico ya está registrado.');
      } else if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else {
        throw Exception('Ocurrió un error al registrarse. Inténtalo de nuevo.');
      }
    }
  }

  // Inicio de Sesión Real con Email y Contraseña
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // Seguridad: mensaje genérico para no dar pistas
      throw Exception('Correo electrónico o contraseña incorrectos.');
    }
  }

  // Inicio de Sesión Real con Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        await _auth.signInWithCredential(credential);
        print('Inicio de sesión con Google exitoso');
      }
    } catch (e) {
      print('Error en Google Sign-In: $e');
      throw Exception('Error al iniciar sesión con Google.');
    }
  }

  // Cerrar Sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
