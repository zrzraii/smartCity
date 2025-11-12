import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

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
    return Scaffold(
      body: widget.navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6337EF),
        shape: const CircleBorder(),
        child: const Icon(Icons.close, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: _BarItem(
                  icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  label: t.tabHome,
                  selected: currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
              ),
              const SizedBox(width: 56), // notch space
              Expanded(
                child: _BarItem(
                  icon: currentIndex == 1 ? Icons.map : Icons.map_outlined,
                  label: t.tabMap,
                  selected: currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: currentIndex == 2 ? Icons.person : Icons.person_outline,
                  label: t.tabProfile,
                  selected: currentIndex == 2,
                  onTap: () => _onTap(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _BarItem({required this.icon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF6337EF) : const Color(0xFF77838F);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}
