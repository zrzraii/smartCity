import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

// Import design system for colors
import 'ui/design.dart'; // <-- ДОБАВЛЕНО

import 'state/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/place_detail_screen.dart';

class AppRouter {
  static GoRouter build(AppState appState) {
    final rootKey = GlobalKey<NavigatorState>();

    return GoRouter(
      navigatorKey: rootKey,
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return _Shell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                  routes: [
                    GoRoute(
                      path: 'post/:id',
                      name: 'post',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return PostDetailScreen(postId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/map',
                  name: 'map',
                  builder: (context, state) => const MapScreen(),
                  routes: [
                    GoRoute(
                      path: 'place/:id',
                      name: 'place',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return PlaceDetailScreen(placeId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) => null,
    );
  }
}

class _Shell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const _Shell({required this.navigationShell});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int get currentIndex => widget.navigationShell.currentIndex;

  void _onTap(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // Используем стандартный NavigationBar (Material 3)
    return Scaffold(
      body: widget.navigationShell,
      // Убираем FloatingActionButton и BottomAppBar с вырезом
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface, //
        indicatorColor: AppColors.primary.withOpacity(0.1), //
        height: 60,
        selectedIndex: currentIndex,
        onDestinationSelected: _onTap,
        // Используем цвета из вашего ui/design.dart
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, color: AppColors.textSecondary), //
            selectedIcon: const Icon(Icons.home, color: AppColors.primary), //
            label: t.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined, color: AppColors.textSecondary), //
            selectedIcon: const Icon(Icons.map, color: AppColors.primary), //
            label: t.tabMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline, color: AppColors.textSecondary), //
            selectedIcon: const Icon(Icons.person, color: AppColors.primary), //
            label: t.tabProfile,
          ),
        ],
      ),
    );
  }
}