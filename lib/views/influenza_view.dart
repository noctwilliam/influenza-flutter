import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:influenza/utilities/go_router.dart';
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
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
          key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'),
        );
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: navigationShell,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
              label: 'Predict', icon: Icon(Icons.online_prediction)),
          NavigationDestination(label: 'History', icon: Icon(Icons.history)),
          NavigationDestination(label: 'Profile', icon: Icon(Icons.person)),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class InfluenzaHome extends StatelessWidget {
  const InfluenzaHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Influenza App'),
        actions: [
          IconButton(
            onPressed: () async {
              final signOut = await showLogOutDialog(context);
              if (signOut) {
                await AuthService.firebase().logOut();
                goRouter.pushReplacement(loginRoute);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    goRouter.goNamed('home');
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
                    goRouter.goNamed('predict');
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
                    goRouter.goNamed('history');
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
                    goRouter.goNamed('faq');
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
        ),
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
