import 'package:flutter/material.dart';
import 'package:moneyapp/screens/home/home_screen.dart';

class Bottomnav extends StatelessWidget {
  const Bottomnav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndex,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            currentIndex: updatedIndex,
            onTap: (newIndex) => HomeScreen.selectedIndex.value = newIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Categories')
            ]);
      }
    );
  }
}
