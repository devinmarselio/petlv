import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petlv/screens/services/auth_services.dart';
import 'package:petlv/screens/services/buttocks_bar.dart';
import 'package:petlv/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  child: Image.asset(
                    color: Theme.of(context).colorScheme.secondary,
                    'assets/images/logopetlv.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 5.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 5.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Confirm Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 5.0),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                height: 60,
                width: 350,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Color(0xffC67C4E),
                      textStyle: const TextStyle(
                        fontSize: 16,
                      )),
                  onPressed: () async {
                    await AuthServices.signUpWithEmail(
                        _emailController,
                        _passwordController,
                        _confirmPasswordController,
                        context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AuthServices.getErrorMessage())),
                    );
                  },
                  child: const Text('Register',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12.0),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                  textStyle: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already Have Account? | ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: Colors.brown, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    " Or Sign Up With ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ValueListenableBuilder(
                valueListenable: userCredential,
                builder: (context, value, child) {
                  return Center(
                    child: SizedBox(
                      height: 60,
                      width: 350,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            textStyle: const TextStyle(
                              fontSize: 16,
                            )),
                        onPressed: () async {
                          userCredential.value =
                              await AuthServices.signInWithGoogle(context);
                          if (userCredential.value != null)
                            print(userCredential.value.user!.email);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => BottomNavBarScreen()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_icon.png',
                            ),
                            Text('Continue with Google')
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
