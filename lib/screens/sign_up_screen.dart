import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petlv/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  ValueNotifier userCredential = ValueNotifier('');

  Future<dynamic> signInWithGoogle() async {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                child: Image.asset(
                  'assets/images/logopetlv.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Align(
                alignment: Alignment.centerLeft ,
                child: const Text('Username', style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 5.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
                alignment: Alignment.centerLeft ,
                child: const Text('Password', style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 5.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  " Or Sign Up With ",
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ValueListenableBuilder(
              valueListenable: userCredential,
              builder: (context, value, child) {
                return Center(
                  child: SizedBox(
                    height: 60,
                    width: 350,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 5, textStyle: const TextStyle(
                        fontSize: 16,
                      )),
                      onPressed: () async {
                        userCredential.value = await signInWithGoogle();
                        if (userCredential.value != null)
                          print(userCredential.value.user!.email);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
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
            const SizedBox(height: 24.0),
            SizedBox(
              height: 60,
              width: 350,
              child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 5,backgroundColor: Color(0xffC67C4E), textStyle: const TextStyle(
                fontSize: 16,
              )),
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields.')),
                    );
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      // <-- Gunakan FirebaseAuth.instance
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('The password provided is too weak.')),
                      );
                    } else if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'The account already exists for that email.')),
                      );
                    } else if (e.code == 'invalid-email') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('The email address is not valid.')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  }
                },
                child: const Text('Register',style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(
              height: 60,
              width: 350,

              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange, textStyle: const TextStyle(
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
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
