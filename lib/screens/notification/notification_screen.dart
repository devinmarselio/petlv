import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petlv/screens/profile_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  _loadNotifications() async {
    final notificationCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('notifications');
    final notificationSnapshot = await notificationCollection.get();
    final notifications = notificationSnapshot.docs.map((doc) {
      return NotificationModel(
        title: doc['title'],
        timestamp: doc['timestamp'],
      );
    }).toList();
    setState(() {
      _notifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Image.asset(
          color: Theme.of(context).colorScheme.secondary,
          'assets/images/petlv_logo_1_removebg.png',
          width: 100,
          height: 100,
        ),
        actions: [
          IconButton(
            onPressed: () async => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const ProfileScreen()), // ProfilScreen
            ),
            icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.secondary)),
              child: const Icon(Icons.person_2_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(4, 1)),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Notification',
                      style: TextStyle(
                          color: Color(0xffC67C4E),
                          fontWeight: FontWeight.bold,
                          fontSize: 34),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(_notifications[index].title),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class NotificationModel {
  String title;
  Timestamp timestamp;

  NotificationModel({required this.title, required this.timestamp});
}
