import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import 'ui/design.dart';
import 'state/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/alerts_screen.dart' as alerts;
import 'screens/settings_screen.dart' as settings;
import 'screens/news_screen.dart';
import 'screens/services_screen.dart';
import 'screens/service_category_screen.dart';
import 'screens/service_form_screen.dart';
import 'screens/appeals_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/place_detail_screen.dart';
import 'screens/transport_schedule_screen.dart';

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
            // Home Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                  routes: [
                    GoRoute(
                      path: 'news',
                      name: 'news',
                      builder: (context, state) => const NewsScreen(),
                    ),
                    GoRoute(
                      path: 'services',
                      name: 'services',
                      builder: (context, state) => const ServicesScreen(),
                    ),
                    GoRoute(
                      path: 'services/:categoryId',
                      name: 'serviceCategory',
                      builder: (context, state) {
                        final id = state.pathParameters['categoryId']!;
                        return ServiceCategoryScreen(categoryId: id);
                      },
                    ),
                    GoRoute(
                      path: 'post/:id',
                      name: 'post',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return PostDetailScreen(postId: id);
                      },
                    ),
                    GoRoute(
                      path: 'services/:serviceId/:itemId',
                      name: 'serviceForm',
                      builder: (context, state) {
                        final serviceId = state.pathParameters['serviceId']!;
                        final itemId = state.pathParameters['itemId']!;
                        return ServiceFormScreen(serviceId: serviceId, itemId: itemId);
                      },
                    ),
                    GoRoute(
                      path: 'appeals',
                      name: 'appeals',
                      builder: (context, state) => const AppealsScreen(),
                    ),
                    GoRoute(
                      path: 'transport',
                      name: 'transport',
                      builder: (context, state) => const TransportScheduleScreen(),
                    ),
                  ],
                ),
              ],
            ),
            // News Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/news',
                  name: 'news_root',
                  builder: (context, state) => const NewsScreen(),
                ),
              ],
            ),
            // Map Branch
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
            // Alerts Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/alerts',
                  name: 'alerts',
                  builder: (context, state) => const alerts.AlertsScreen(),
                ),
              ],
            ),
            // Profile Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => const ProfileScreen(),
                  routes: [
                    GoRoute(
                      path: 'settings',
                      name: 'settings',
                      builder: (context, state) => const settings.SettingsScreen(),
                    ),
                  ],
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
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: fadedColor(AppColors.primary, 0.1),
        height: 60,
        selectedIndex: currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: t.tabHome,
          ),
          const NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Новости',
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: t.tabMap,
          ),
          const NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Оповещения',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: t.tabProfile,
          ),
        ],
      ),
    );
  }
}
