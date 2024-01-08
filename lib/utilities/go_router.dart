import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:influenza/views/faq_view.dart';
import 'package:influenza/views/history_view.dart';
import 'package:influenza/views/influenza_view.dart';
import 'package:influenza/views/login_view.dart';
import 'package:influenza/views/predict_view.dart';
import 'package:influenza/views/profile_view.dart';
import 'package:influenza/views/verify_email_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _influenzaRouteKey = GlobalKey<NavigatorState>(debugLabel: 'Influenza');
final _predictRouteKey = GlobalKey<NavigatorState>(debugLabel: 'Predict');
final _historyRouteKey = GlobalKey<NavigatorState>(debugLabel: 'History');
final _profileRouteKey = GlobalKey<NavigatorState>(debugLabel: 'Profile');
// final _faqRouteKey = GlobalKey<NavigatorState>(debugLabel: 'FAQ');

GoRouter? globalGoRouter;

GoRouter getGoRouter() {
  return globalGoRouter ??= goRouter;
}

void goandRemoveUntil(String routeName) {
  getGoRouter().go(routeName);
  _rootNavigatorKey.currentState!.popUntil((route) => route.isFirst);
}

final goRouter = GoRouter(
  initialLocation: '/',
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // Stateful navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _influenzaRouteKey,
          routes: [
            GoRoute(
              name: 'home',
              path: '/',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: InfluenzaHome(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _predictRouteKey,
          routes: [
            // Shopping Cart
            GoRoute(
              name: 'predict',
              path: '/predict',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PredictView(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _historyRouteKey,
          routes: [
            GoRoute(
              name: 'history',
              path: '/history',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryView(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileRouteKey,
          routes: [
            GoRoute(
              name: 'profile',
              path: '/profile',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: ProfileView(),
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'faq',
      path: '/faq',
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: FaqView(),
        );
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: LoginView(),
        );
      },
    ),
    GoRoute(
      name: 'verify',
      path: '/verify',
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: VerifyEmailView(),
        );
      },
    ),
  ],
);

void main() {
  // turn off the # in the URLs on the web
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
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

// /// Widget for the root/initial pages in the bottom navigation bar.
// class RootScreen extends StatelessWidget {
//   /// Creates a RootScreen
//   const RootScreen({required this.label, super.key});

//   /// The label
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tab root - $label'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text('Screen $label',
//                 style: Theme.of(context).textTheme.titleLarge),
//             const Padding(padding: EdgeInsets.all(4)),
//             const Text('View details'),
//           ],
//         ),
//       ),
//     );
//   }
// }
