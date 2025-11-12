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
      appBar: AppBar(title: Text(t.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionTitle(t.language),
          Gaps.s,
          CardContainer(
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
          const SizedBox(height: 24),
          SectionTitle(t.savedPosts),
          Gaps.s,
          CardContainer(
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
          const SizedBox(height: 24),
          SectionTitle(t.savedPlaces),
          Gaps.s,
          CardContainer(
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
          const SizedBox(height: 24),
          SectionTitle(t.savedSchedules),
          Gaps.s,
          CardContainer(
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
