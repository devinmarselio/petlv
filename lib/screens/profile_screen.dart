import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/screens/profile_settings_screen.dart';
import 'package:petlv/screens/services/auth_services.dart';
import 'package:petlv/screens/sign_in_screen.dart';
import 'package:petlv/themes/theme.dart';
import 'package:petlv/themes/theme_provider.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SignInScreenState signInScreenState = SignInScreenState();
  ThemeProvider themeProvider = ThemeProvider();
  final User? user = FirebaseAuth.instance.currentUser;
  String _username = '';
  String _profilePictureUrl = '';

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Profile', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) => RotationTransition(
                        turns: child.key == const ValueKey('icon1')
                            ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                            : Tween<double>(begin: 0.75, end: 1).animate(anim),
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                  child: themeProvider.themeData == darkMode
                      ? const Icon(Icons.light_mode, key: ValueKey('icon1'))
                      : const Icon(
                          Icons.dark_mode,
                          key: ValueKey('icon2'),
                        ))),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _username = snapshot.data!.get('username') ?? '';
              _profilePictureUrl = snapshot.data!.get('profilePicture') ?? '';
            }
            return Column(
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
                                        border: Border.all(
                                            color: Colors.white, width: 4),
                                        shape: BoxShape.circle),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade300,
                                      radius: 70,
                                      backgroundImage: _profilePictureUrl
                                              .isNotEmpty
                                          ? NetworkImage(_profilePictureUrl)
                                          : const AssetImage(
                                                  'assets/images/placeholder_image.png')
                                              as ImageProvider<Object>?,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 9,
                            child: Center(
                              child: Text(
                                _username.isEmpty ? 'Username' : _username,
                                style: TextStyle(fontSize: 18),
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
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 350,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.primary)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileSettingsScreen()),
                                  );
                                },
                                child: Text(
                                  'User Settings',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ))),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 350,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Manage My Post',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
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
                                bool result =
                                    await AuthServices.signOut(context);
                                if (result)
                                  signInScreenState.userCredential.value = '';
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
