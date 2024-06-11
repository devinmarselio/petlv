import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/screens/sign_in_screen.dart';

class AuthServices {
  static String _errorMessage = '';
  static Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
        ],
        clientId:
            //'37974253661-bf7jutp8u17m02uf1jbi9r6p5gfnfus8.apps.googleusercontent.com', //ANDROID CLIENT ID
            '37974253661-6f2242raggt8urteh7kp6uvr1n1mk7bt.apps.googleusercontent.com', // WEB CLIENT ID
      ).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  static Future<void> signInWithEmail(TextEditingController emailController,
      TextEditingController passwordController, BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || !isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email';
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      _errorMessage = 'Sign In Successful';
    } on FirebaseAuthException catch (error) {
      print('Error code: ${error.code}');
      if (error.code == 'user-not-found') {
        // Jika email tidak terdaftar, tampilkan pesan kesalahan
        _errorMessage = 'No user found with that email';
      } else if (error.code == 'wrong-password') {
        // Jika password salah, tampilkan pesan kesalahan
        _errorMessage = 'Wrong password. Please try again.';
      } else {
        // Jika terjadi kesalahan lain, tampilkan pesan kesalahan umum
        _errorMessage = error.message ?? 'An error occurred';
      }
    } catch (error) {
      // Tangani kesalahan lain yang tidak terkait dengan otentikasi
      _errorMessage = '$error';
    }
  }

  static Future<bool> signOut(BuildContext context) async {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInScreen()));
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  // Fungsi untuk memeriksa validitas email
  static bool isValidEmail(String email) {
    String emailRegex =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  static String getErrorMessage() {
    return _errorMessage;
  }
}
