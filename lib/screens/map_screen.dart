import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import '../data/mock.dart';
import '../models/place.dart';
import '../ui/design.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _filters = const [
    {'id': 'all', 'label': 'Все объекты', 'types': <String>[]},
    {'id': 'transport', 'label': 'Транспорт', 'types': ['airport', 'station']},
    {'id': 'civic', 'label': 'Сервисы', 'types': ['civic', 'service']},
    {'id': 'health', 'label': 'Здоровье', 'types': ['health']},
    {'id': 'recreation', 'label': 'Отдых', 'types': ['park', 'culture']},
  ];

  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Place> get _filteredPlaces {
    final query = _searchController.text.toLowerCase();
    final filter = _filters.firstWhere((f) => f['id'] == _activeFilter);
    final List<String> filterTypes = List<String>.from(filter['types'] as List<String>);

    return mockPlaces.where((place) {
      final matchesQuery = query.isEmpty || place.name.toLowerCase().contains(query) || place.description.toLowerCase().contains(query);
      final matchesFilter = _activeFilter == 'all' || filterTypes.contains(place.type);
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final places = _filteredPlaces;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(47.8043, 67.7078),
              initialZoom: 12.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'smart_city',
              ),
              MarkerLayer(
                markers: places
                    .map(
                      (place) => Marker(
                        width: 48,
                        height: 48,
                        point: LatLng(place.lat, place.lng),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => context.push('/map/place/${place.id}'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 6)),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(_iconForType(place.type), color: AppColors.primary),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: CardContainer(
                  padding: const EdgeInsets.all(16),
                  showShadow: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.tabMap, style: Theme.of(context).textTheme.titleSmall),
                              Text('Жезказган — городской план', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                          const Spacer(),
                          SquareIconButton(
                            icon: Icons.navigation_outlined,
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Определение местоположения (мок)'))),
                          ),
                        ],
                      ),
                      Gaps.m,
                      SearchTextField(
                        controller: _searchController,
                        hintText: 'Поиск улицы, объекта или сервиса',
                        onClear: () {
                          _searchController.clear();
                        },
                      ),
                      Gaps.s,
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final filter = _filters[index];
                            return FilterPill(
                              label: filter['label'] as String,
                              isActive: _activeFilter == filter['id'],
                              onTap: () => setState(() => _activeFilter = filter['id'] as String),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 190,
                child: places.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CardContainer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_off_outlined, color: AppColors.textHint, size: 32),
                              Gaps.s,
                              Text('Нет объектов по запросу', style: Theme.of(context).textTheme.titleSmall),
                              Text('Измените фильтр или попробуйте другой поиск', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: places.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final place = places[index];
                          return SizedBox(
                            width: 250,
                            child: CardContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      StatusChip(label: _typeLabel(place.type), color: AppColors.accent),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_right),
                                        onPressed: () => context.push('/map/place/${place.id}'),
                                      ),
                                    ],
                                  ),
                                  Text(place.name, style: Theme.of(context).textTheme.titleSmall),
                                  Gaps.xs,
                                  Text(place.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Icon(_iconForType(place.type), size: 18, color: AppColors.textSecondary),
                                      const SizedBox(width: 6),
                                      Text('${place.lat.toStringAsFixed(3)}, ${place.lng.toStringAsFixed(3)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'airport':
        return Icons.flight_takeoff;
      case 'station':
        return Icons.train;
      case 'civic':
        return Icons.apartment;
      case 'service':
        return Icons.account_balance_outlined;
      case 'health':
        return Icons.local_hospital;
      case 'park':
        return Icons.park;
      case 'culture':
        return Icons.museum_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'airport':
        return 'Аэропорт';
      case 'station':
        return 'Вокзал';
      case 'civic':
        return 'Акимат';
      case 'service':
        return 'Сервис';
      case 'health':
        return 'Медицина';
      case 'park':
        return 'Парк';
      case 'culture':
        return 'Культура';
      default:
        return 'Объект';
    }
  }
}
