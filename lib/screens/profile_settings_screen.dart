import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/screens/services/auth_services.dart';
import 'package:petlv/screens/sign_in_screen.dart';
import 'package:petlv/themes/theme.dart';
import 'package:petlv/themes/theme_provider.dart';

import 'package:provider/provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  SignInScreenState signInScreenState = SignInScreenState();
  GlobalKey<FormState> key = GlobalKey();
  final User? user = FirebaseAuth.instance.currentUser;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();
  ThemeProvider themeProvider = ThemeProvider();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('User Settings', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width / 4,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                  shape: BoxShape.circle),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 70,
                                backgroundImage: _image != null
                                    ? FileImage(File(_image!.path))
                                        as ImageProvider<Object>
                                    : AssetImage(
                                        'assets/images/placeholder_image.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _showImageSourceDialog();
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 9,
                        child: const Center(
                          child: Text(
                            'Change Picture',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Username',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 5.0),
                      SizedBox(
                        height: 60,
                        child: TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              border: OutlineInputBorder(),
                            )),
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Phone Number',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 5.0),
                      SizedBox(
                        height: 60,
                        child: TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              border: OutlineInputBorder(),
                            )),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: SizedBox(
                          width: 350,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: user?.email ?? '');
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Take a new photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _image = pickedFile;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Choose from library'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _image = pickedFile;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
