import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/theme/theme.dart';
import 'package:petlv/theme/theme_provider.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeProvider themeProvider = ThemeProvider();
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
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
                                backgroundImage: const AssetImage(
                                    'assets/images/placeholder_image.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 9,
                      child: const Center(
                        child: Expanded(
                            child: Text(
                          'userName',
                          style: TextStyle(fontSize: 18),
                        )),
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 350,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.primary)),
                        onPressed: () {},
                        child: Text(
                          'User Settings',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
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
                              color: Theme.of(context).colorScheme.secondary),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
