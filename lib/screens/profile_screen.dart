import 'package:flutter/material.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../data/mock.dart';
import '../ui/design.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // светлый фон
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t.profile,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Блок профиль пользователя
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                // Фото пользователя (заглушка)
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFE8EAED),
                  child: const Icon(Icons.person, color: Color(0xFFAAB0BF), size: 48),
                ),
                const SizedBox(width: 20),
                // Информация о пользователе
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Айтжанова Райхан',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'aitraihan@gmail.com',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Язык
          ProfileSection(
            title: t.language,
            child: DropdownButton<Locale>(
              value: appState.locale,
              hint: Text(t.changeLanguage),
              items: const [
                DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
                DropdownMenuItem(value: Locale('kk'), child: Text('Қазақша')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
              onChanged: (loc) => context.read<AppState>().setLocale(loc),
            ),
          ),
          // Сохраненные посты
          ProfileSection(
            title: t.savedPosts,
            child: Column(
              children: [
                if (appState.savedPostIds.isEmpty)
                  Align(alignment: Alignment.centerLeft, child: Text(t.emptyList))
                else
                  ...appState.savedPostIds.map((id) {
                    final matches = mockPosts.where((p) => p.id == id).toList();
                    final title = matches.isNotEmpty ? matches.first.title : 'Post $id';
                    return ListTile(
                      title: Text(title),
                      onTap: () => context.push('/home/post/$id'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<AppState>().toggleSavedPost(id),
                      ),
                    );
                  }),
              ],
            ),
          ),
          // Сохраненные места
          ProfileSection(
            title: t.savedPlaces,
            child: Column(
              children: [
                if (appState.savedPlaceIds.isEmpty)
                  Align(alignment: Alignment.centerLeft, child: Text(t.emptyList))
                else
                  ...appState.savedPlaceIds.map((id) {
                    final matches = mockPlaces.where((p) => p.id == id).toList();
                    final title = matches.isNotEmpty ? matches.first.name : 'Place $id';
                    return ListTile(
                      title: Text(title),
                      onTap: () => context.push('/map/place/$id'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<AppState>().toggleSavedPlace(id),
                      ),
                    );
                  }),
              ],
            ),
          ),
          // Сохраненные расписания
          ProfileSection(
            title: t.savedSchedules,
            child: Column(
              children: [
                if (appState.savedScheduleIds.isEmpty)
                  Align(alignment: Alignment.centerLeft, child: Text(t.emptyList))
                else
                  ...appState.savedScheduleIds.map((id) {
                    final matches = mockSchedule.where((s) => s.id == id).toList();
                    final title = matches.isNotEmpty ? matches.first.title : 'Schedule $id';
                    return ListTile(
                      title: Text(title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<AppState>().toggleSavedSchedule(id),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Вспомогательный виджет для секций профиля
class ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;
  const ProfileSection({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
