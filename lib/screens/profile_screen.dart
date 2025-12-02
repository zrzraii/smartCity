import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import '../data/mock.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final user = mockCurrentUser;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.profile, style: Theme.of(context).textTheme.titleLarge),
            Text(user.city, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          SquareIconButton(
            icon: Icons.settings_outlined,
            onTap: () => context.push('/profile/settings'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CardContainer(
            gradient: AppGradients.copperDawn,
            border: Border.all(color: Colors.transparent),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: fadedColor(Colors.white, 0.2),
                  child: const Icon(Icons.person_outline, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${user.firstName} ${user.lastName}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                      Text(user.email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                      Gaps.s,
                      Row(
                        children: const [
                          Expanded(child: _ProfileStat(label: 'Документы', value: '12 активных')),
                          Expanded(child: _ProfileStat(label: 'Сервисы', value: '8 подключено')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.xl,
          SectionHeader(title: 'Мои сервисы', subtitle: 'Часто используемые разделы'),
          Gaps.m,
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: _quickActions.map((action) {
              return GestureDetector(
                onTap: () => context.push(action['route'] as String),
                child: CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: fadedColor(AppColors.primary, 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(action['icon'] as IconData, color: AppColors.primary),
                      ),
                      const Spacer(),
                      Text(action['title'] as String, style: Theme.of(context).textTheme.titleSmall),
                      Gaps.xs,
                      Text(action['subtitle'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          Gaps.xl,
          SectionHeader(title: 'Сохранённые материалы', subtitle: 'Новости, места и расписания'),
          Gaps.s,
          CardContainer(
            child: Column(
              children: [
                _SavedRow(
                  title: t.savedPosts,
                  count: appState.savedPostIds.length,
                  onTap: appState.savedPostIds.isEmpty ? null : () => context.go('/news'),
                ),
                const Divider(),
                _SavedRow(
                  title: t.savedPlaces,
                  count: appState.savedPlaceIds.length,
                  onTap: appState.savedPlaceIds.isEmpty ? null : () => context.go('/map'),
                ),
                const Divider(),
                _SavedRow(
                  title: t.savedSchedules,
                  count: appState.savedScheduleIds.length,
                  onTap: appState.savedScheduleIds.isEmpty ? null : () => context.push('/home/transport'),
                ),
              ],
            ),
          ),
          Gaps.xl,
          SectionHeader(title: 'Предпочтения', subtitle: 'Язык, уведомления и безопасность'),
          Gaps.s,
          CardContainer(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language),
                  title: Text(t.language),
                  subtitle: Text(t.changeLanguage),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: appState.locale,
                      items: const [
                        DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
                        DropdownMenuItem(value: Locale('kk'), child: Text('Қазақша')),
                        DropdownMenuItem(value: Locale('en'), child: Text('English')),
                      ],
                      onChanged: (loc) => context.read<AppState>().setLocale(loc),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: const Text('Уведомления'),
                  subtitle: const Text('Настроить push и e-mail оповещения'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/profile/settings'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.devices_other_outlined),
                  title: const Text('Активные сеансы'),
                  subtitle: const Text('Управление устройствами и безопасностью'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/profile/settings'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

final _quickActions = [
  {'title': 'Идентификация', 'subtitle': 'Паспорт и адреса', 'icon': Icons.badge_outlined, 'route': '/home/services/identification'},
  {'title': 'Транспорт', 'subtitle': 'Водитель и ТС', 'icon': Icons.directions_bus_outlined, 'route': '/home/services/transport'},
  {'title': 'Медицина', 'subtitle': 'Карта и записи', 'icon': Icons.local_hospital, 'route': '/home/services/medicine'},
  {'title': 'Семья', 'subtitle': 'Свидетельства', 'icon': Icons.family_restroom, 'route': '/home/services/family'},
];

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
      ],
    );
  }
}

class _SavedRow extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onTap;
  const _SavedRow({required this.title, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(count == 0 ? 'Нет элементов' : '$count элементов'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
