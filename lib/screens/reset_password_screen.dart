import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petlv/screens/services/auth_services.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  child: Image.asset(
                    color: Theme.of(context).colorScheme.secondary,
                    'assets/images/logopetlv.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Enter you email address and we will send you instructions to reset you password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Email address',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 5.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 60,
                width: 350,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Color(0xffC67C4E),
                      textStyle: const TextStyle(
                        fontSize: 18,
                      )),
                  onPressed: () async {
                    await AuthServices.resetPassword(
                        email: _emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AuthServices.getErrorMessage())),
                    );
                  },
                  child:
                      const Text('Send', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
