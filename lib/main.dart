import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petlv/firebase_options.dart';
import 'package:petlv/screens/services/buttocks_bar.dart';
import 'package:petlv/screens/sign_in_screen.dart';
import 'package:petlv/screens/sign_up_screen.dart';
import 'package:petlv/themes/theme.dart';
import 'package:petlv/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NotificationHandler {
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle notification when app is in background
    print('Handling a background message ${message.messageId}');
    print('Notification data: ${message.data}');
    if (message.notification != null) {
      print('Notification also contained a notification: ${message.notification}');
    }
  }

  static Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
    // Handle notification when app is in foreground
    print('Handling a foreground message ${message.messageId}');
    print('Notification data: ${message.data}');
    if (message.notification != null) {
      print('Notification also contained a notification: ${message.notification}');
    }
  }

  static Future<void> _firebaseMessagingTerminatedHandler(RemoteMessage message) async {
    // Handle notification when app is terminated
    print('Handling a terminated message ${message.messageId}');
    print('Notification data: ${message.data}');
    if (message.notification != null) {
      print('Notification also contained a notification: ${message.notification}');
    }
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(NotificationHandler._firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(NotificationHandler._firebaseMessagingForegroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(NotificationHandler._firebaseMessagingTerminatedHandler);

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
            return BottomNavBarScreen();
          } else {
            return SignInScreen();
          }
        },
      ),
    );
  }
}
