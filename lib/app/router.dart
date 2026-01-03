import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/features/characters/presentation/characters_page.dart';
import '/features/favorites/presentation/favorites_page.dart';
import 'theme/theme_controller.dart';

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
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: CharactersPage(),
              );
            },
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: FavoritesPage(),
              );
            },
          ),
        ],
      ),
    ],
  );
}

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/favorites')) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: const Icon(Icons.dark_mode),
            onPressed: ThemeController.toggleTheme,
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
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
