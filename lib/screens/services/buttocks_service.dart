import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Theme.of(context).colorScheme.secondary ,
      backgroundColor: Theme.of(context).colorScheme.background,
      currentIndex: currentIndex,
      onTap: onTap,
      items:  [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite ), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.dangerous ), label: 'Missing'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
      ],
    );
  }
}