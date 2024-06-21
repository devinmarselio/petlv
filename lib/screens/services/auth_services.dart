import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/screens/services/buttocks_bar.dart';
import 'package:petlv/screens/sign_in_screen.dart';

class AuthServices {
  static String _message = '';
  static Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
        ],
        clientId:
            '37974253661-bf7jutp8u17m02uf1jbi9r6p5gfnfus8.apps.googleusercontent.com', //ANDROID CLIENT ID
        // '37974253661-6f2242raggt8urteh7kp6uvr1n1mk7bt.apps.googleusercontent.com', // WEB CLIENT ID
      ).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
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
      _message = 'Please enter a valid email';
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
      );
      _message = 'Sign In Successful';
    } on FirebaseAuthException catch (error) {
      print('Error code: ${error.code}');
      if (error.code == 'user-not-found') {
        // Jika email tidak terdaftar, tampilkan pesan kesalahan
        _message = 'No user found with that email';
      } else if (error.code == 'wrong-password') {
        // Jika password salah, tampilkan pesan kesalahan
        _message = 'Wrong password. Please try again.';
      } else {
        // Jika terjadi kesalahan lain, tampilkan pesan kesalahan umum
        _message = error.message ?? 'An error occurred';
      }
    } catch (error) {
      // Tangani kesalahan lain yang tidak terkait dengan otentikasi
      _message = '$error';
    }
  }

  static Future<void> signUpWithEmail(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _message = 'Please fill in all fields.';
      return;
    } else if (password != confirmPassword) {
      _message = 'Password doesn\'t match';
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
      );
      _message = 'Sign Up Successful';
    } on FirebaseAuthException catch (error) {
      print('Error code: ${error.code}');
      if (error.code == 'weak-password') {
        // Jika password lemah, tampilkan pesan kesalahan
        _message = 'The password provided is too weak.';
      } else if (error.code == 'email-already-in-use') {
        // Jika email pernah terdaftar, tampilkan pesan kesalahan
        _message = 'The account already exists for that email.';
      } else if (error.code == 'invalid-email') {
        // Jika email tidak valid, tampilkan pesan kesalahan
        _message = 'The email address is not valid.';
      } else {
        // Jika terjadi kesalahan lain, tampilkan pesan kesalahan umum
        _message = error.message ?? 'An error occurred';
      }
    } catch (error) {
      // Tangani kesalahan lain yang tidak terkait dengan otentikasi
      _message = '$error';
    }
  }

  static Future<dynamic> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _message = 'Email for Reset Password has been sent';
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        // Handle the case where the user is not found
        _message = 'User not found';
      }
    } catch (error) {
      _message = '$error';
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
    return _message;
  }
}
