import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';


class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).colorScheme.secondary,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: navigationShell.goBranch,
          selectedItemColor: Theme.of(context).colorScheme.surface,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 22,
          items: const [
            BottomNavigationBarItem(
               icon: FaIcon(FontAwesomeIcons.house), 

              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.camera), 
              label: 'story',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userPlus), 
              label: 'friend',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidComment), 
              label: 'chat',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.gear), 
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
