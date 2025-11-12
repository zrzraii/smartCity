import 'package:flutter/material.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data/mock.dart';
import '../models/place.dart';
import '../models/schedule_item.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final place = mockPlaces.firstWhere((p) => p.id == placeId);
    final isSaved = context.watch<AppState>().savedPlaceIds.contains(place.id);
    final schedule = mockSchedule.where((s) => s.placeId == place.id).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(place.name),
          actions: [
            IconButton(
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => context.read<AppState>().toggleSavedPlace(place.id),
              tooltip: isSaved ? t.saved : t.save,
            )
          ],
          bottom: TabBar(tabs: [
            Tab(text: t.info),
            Tab(text: t.schedule),
          ]),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CardContainer(
              child: _InfoTab(place: place),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CardContainer(
              child: _ScheduleTab(items: schedule),
            ),
          ),
        ]),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final Place place;
  const _InfoTab({required this.place});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(place.description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  final List<ScheduleItem> items;
  const _ScheduleTab({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).emptyList));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final it = items[index];
        final saved = context.watch<AppState>().savedScheduleIds.contains(it.id);
        return ListTile(
          leading: const Icon(Icons.schedule),
          title: Text(it.title),
          subtitle: Text(TimeOfDay.fromDateTime(it.time).format(context)),
          trailing: IconButton(
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => context.read<AppState>().toggleSavedSchedule(it.id),
          ),
        );
      },
    );
  }
}
