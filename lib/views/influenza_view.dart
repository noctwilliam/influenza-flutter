import 'package:flutter/material.dart';
import 'package:influenza/constants/routes.dart';
import 'package:influenza/enums/menu_action.dart';
import 'dart:developer' as devtools show log;
import 'package:influenza/services/auth/auth_service.dart';
import 'package:influenza/views/history_view.dart';
import 'package:influenza/views/predict_view.dart';
import 'package:influenza/views/profile_view.dart';

class InfluenzaView extends StatefulWidget {
  const InfluenzaView({super.key});

  @override
  State<InfluenzaView> createState() => _InfluenzaViewState();
}

class _InfluenzaViewState extends State<InfluenzaView> {
  int currentPageIndex = 0;
  final List<Widget> _pages = [
    const InfluenzaHome(),
    const PredictView(),
    const HistoryView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (MenuAction value) async {
              devtools.log(value.toString());
              final navigator = Navigator.of(context);
              switch (value) {
                case MenuAction.logout:
                  final logout = await showLogOutDialog(context);
                  if (logout) {
                    await AuthService.firebase().logOut();
                    navigator.pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<MenuAction>>[
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.online_prediction),
            label: 'Predict',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class InfluenzaHome extends StatefulWidget {
  const InfluenzaHome({
    super.key,
  });

  @override
  State<InfluenzaHome> createState() => _InfluenzaHomeState();
}

class _InfluenzaHomeState extends State<InfluenzaHome> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.teal[600],
              onTap: () {
                debugPrint('sek kito');
              },
              child: SizedBox(
                width: 350,
                height: 110,
                child: Center(
                  child: Text('Home',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                debugPrint('tap tap bich');
              },
              child: SizedBox(
                width: 350,
                height: 110,
                child: Center(
                  child: Text(
                    'Predict Severity',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                debugPrint('tap tap bich');
              },
              child: SizedBox(
                width: 350,
                height: 110,
                child: Center(
                  child: Text(
                    'Severity History',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                debugPrint('tap tap bich');
              },
              child: SizedBox(
                width: 350,
                height: 110,
                child: Center(
                  child: Text(
                    'FAQ',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sign out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
