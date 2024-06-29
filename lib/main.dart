import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petlv/firebase_options.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:petlv/screens/services/buttocks_bar.dart';
import 'package:petlv/screens/sign_in_screen.dart';
import 'package:petlv/screens/sign_up_screen.dart';
import 'package:petlv/themes/theme.dart';
import 'package:petlv/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petlv',
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkMode,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SignInScreen();
          } else {
            return BottomNavBarScreen();
          }
        },
      ),
    );
  }
}
