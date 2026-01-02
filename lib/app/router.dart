import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/characters/presentation/characters_page.dart';
import '../features/favorites/presentation/favorites_page.dart';

final router = GoRouter(
  initialLocation: '/characters',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/characters',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CharactersPage()),
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FavoritesPage()),
        ),
      ],
    ),
  ],
);

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: location.startsWith('/favorites') ? 1 : 0,
        onTap: (index) {
          if (index == 0) {
            context.go('/characters');
          } else {
            context.go('/favorites');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
