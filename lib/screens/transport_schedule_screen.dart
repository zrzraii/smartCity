import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock.dart';
import '../models/place.dart';
import '../models/schedule_item.dart';
import '../ui/design.dart';

class TransportScheduleScreen extends StatefulWidget {
  const TransportScheduleScreen({super.key});

  @override
  State<TransportScheduleScreen> createState() => _TransportScheduleScreenState();
}

class _TransportScheduleScreenState extends State<TransportScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _segments = const ['Автобусы', 'Поезда', 'Авиарейсы'];
  String _activeSegment = 'Автобусы';

  final List<Map<String, String>> _busRoutes = const [
    {'line': '№3', 'from': 'Промзона', 'to': 'Центр', 'interval': '8 мин', 'next': '12:14', 'status': 'В пути'},
    {'line': '№5', 'from': 'Жезказганский рудник', 'to': 'Наурыз', 'interval': '10 мин', 'next': '12:18', 'status': 'На остановке'},
    {'line': '№9', 'from': 'Аэропорт', 'to': 'Центральный рынок', 'interval': '12 мин', 'next': '12:25', 'status': 'Отправление'},
    {'line': '№15', 'from': 'Сатпаев', 'to': 'Университет', 'interval': '15 мин', 'next': '12:32', 'status': 'В пути'},
  ];

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

  List<Map<String, String>> get _filteredBusRoutes {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _busRoutes;
    return _busRoutes
        .where((route) => route.values.any((value) => value.toLowerCase().contains(query)))
        .toList();
  }

  List<ScheduleItem> get _trainDepartures {
    final items = mockSchedule.where((item) {
      final place = _placeById(item.placeId);
      return place?.type == 'station';
    }).toList();
    return items..sort((a, b) => a.time.compareTo(b.time));
  }

  List<ScheduleItem> get _flightDepartures {
    final items = mockSchedule.where((item) {
      final place = _placeById(item.placeId);
      return place?.type == 'airport';
    }).toList();
    return items..sort((a, b) => a.time.compareTo(b.time));
  }

  Place? _placeById(String id) {
    try {
      return mockPlaces.firstWhere((place) => place.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const SectionTitle('Транспорт Жезказгана'),
        actions: [
          SquareIconButton(
            icon: Icons.map_outlined,
            onTap: () => context.go('/map'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CardContainer(
            gradient: AppGradients.steppeSky,
            border: Border.all(color: Colors.transparent),
            showShadow: false,
            child: Row(
              children: const [
                Expanded(child: InfoPill(label: 'Активных линий', value: '24 маршрута', icon: Icons.alt_route)),
                SizedBox(width: 12),
                Expanded(child: InfoPill(label: 'Средний интервал', value: '9 минут', icon: Icons.timelapse)),
              ],
            ),
          ),
          Gaps.l,
          SearchTextField(
            controller: _searchController,
            hintText: 'Поиск маршрута или рейса',
            onClear: () => _searchController.clear(),
          ),
          Gaps.m,
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _segments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final segment = _segments[index];
                return FilterPill(
                  label: segment,
                  isActive: _activeSegment == segment,
                  onTap: () => setState(() => _activeSegment = segment),
                );
              },
            ),
          ),
          Gaps.l,
          _buildSegmentContent(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSegmentContent() {
    switch (_activeSegment) {
      case 'Поезда':
        final list = _searchController.text.isEmpty
            ? _trainDepartures
            : _trainDepartures.where((item) => item.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
        return Column(
          children: list
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CardContainer(
                      child: _ScheduleTile(
                        title: item.title,
                        subtitle: 'Отправление ${_formatTime(item.time)} · Центральный вокзал',
                        statusLabel: 'В графике',
                        badgeColor: AppColors.info,
                        icon: Icons.train_outlined,
                      ),
                    ),
                  ))
              .toList(),
        );
      case 'Авиарейсы':
        final list = _searchController.text.isEmpty
            ? _flightDepartures
            : _flightDepartures.where((item) => item.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
        return Column(
          children: list
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CardContainer(
                      child: _ScheduleTile(
                        title: item.title,
                        subtitle: 'Вылет ${_formatTime(item.time)} · Аэропорт Жезказган',
                        statusLabel: 'Регистрация открыта',
                        badgeColor: AppColors.primary,
                        icon: Icons.flight_takeoff,
                      ),
                    ),
                  ))
              .toList(),
        );
      default:
        final routes = _filteredBusRoutes;
        return Column(
          children: routes
              .map((route) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CardContainer(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(route['line']!, style: Theme.of(context).textTheme.titleMedium),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${route['from']} → ${route['to']}', style: Theme.of(context).textTheme.titleSmall),
                                Text('Интервал: ${route['interval']}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Время: ${route['next']}', style: Theme.of(context).textTheme.bodyMedium),
                              StatusChip(label: route['status']!, color: AppColors.success),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
    }
  }

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class _ScheduleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusLabel;
  final Color badgeColor;
  final IconData icon;

  const _ScheduleTile({
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.badgeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: badgeColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        StatusChip(label: statusLabel, color: badgeColor),
      ],
    );
  }
}
