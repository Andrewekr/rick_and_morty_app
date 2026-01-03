import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/characters/presentation/characters_page.dart';
import '../../features/favorites/presentation/favorites_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/characters',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/characters',
            builder: (context, state) => const CharactersPage(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
        ],
      ),
    ],
  );
}

/// Общий Scaffold с BottomNavigationBar
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/favorites')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/characters');
              break;
            case 1:
              context.go('/favorites');
              break;
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
