import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import '../data/mock.dart';
import '../models/post.dart';
import '../models/schedule_item.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  final Map<String, String> _postCategories = const {
    'p1': 'Город',
    'p2': 'Культура',
    'p3': 'Транспорт',
    'p4': 'Коммунальные',
    'p5': 'Город',
    'p6': 'Культура',
  };

  final List<String> _newsFilters = const ['Все', 'Город', 'Транспорт', 'Коммунальные', 'Культура'];
  final List<Map<String, dynamic>> _quickActions = [
    {'title': 'Карта города', 'subtitle': 'Районы и объекты', 'icon': Icons.map_outlined, 'route': '/map', 'useGo': true},
    {'title': 'Транспорт', 'subtitle': 'Автобусы и рейсы', 'icon': Icons.directions_bus_filled, 'route': '/home/transport'},
    {'title': 'Новости', 'subtitle': 'Лента города', 'icon': Icons.article_outlined, 'route': '/news', 'useGo': true},
    {'title': 'Обращения', 'subtitle': 'Статусы заявок', 'icon': Icons.support_agent, 'route': '/home/appeals'},
    {'title': 'Сервисы', 'subtitle': 'Цифровые услуги', 'icon': Icons.apps_rounded, 'route': '/home/services'},
    {'title': 'Профиль', 'subtitle': 'Документы', 'icon': Icons.person_outline, 'route': '/profile', 'useGo': true},
  ];

  List<Post> _filteredPosts = [];
  String _selectedFilter = 'Все';

  final List<Map<String, String>> _busHighlights = const [
    {'line': '№5', 'direction': 'Юг → Центр', 'eta': '3 мин', 'status': 'В пути'},
    {'line': '№9', 'direction': 'Промзона → Вокзал', 'eta': '7 мин', 'status': 'На остановке'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredPosts = mockPosts;
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPosts() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filteredPosts = mockPosts.where((post) {
        final matchesQuery = q.isEmpty || post.title.toLowerCase().contains(q) || post.content.toLowerCase().contains(q);
        final cat = _postCategories[post.id] ?? 'Все';
        final matchesFilter = _selectedFilter == 'Все' || cat == _selectedFilter;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _selectFilter(String value) {
    if (_selectedFilter == value) return;
    setState(() {
      _selectedFilter = value;
      _filterPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final saved = appState.savedPostIds;
    final submissions = appState.submissions;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart City', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary)),
            Text('Жезказган', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          SquareIconButton(
            icon: Icons.notifications_outlined,
            onTap: () => context.go('/alerts'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _CityHeroCard(onMapTap: () => context.go('/map')),
            Gaps.l,
            SearchTextField(
              controller: _searchController,
              hintText: 'Поиск по новостям и сервисам',
              onClear: () {
                _searchController.clear();
                _filterPosts();
              },
            ),
            Gaps.m,
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _newsFilters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _newsFilters[index];
                  return FilterPill(
                    label: filter,
                    isActive: filter == _selectedFilter,
                    onTap: () => _selectFilter(filter),
                  );
                },
              ),
            ),
            Gaps.xl,
            SectionHeader(
              title: 'Быстрый доступ',
              subtitle: 'Важные разделы города',
            ),
            Gaps.m,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _quickActions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final action = _quickActions[index];
                return GestureDetector(
                  onTap: () {
                    final route = action['route'] as String;
                    final useGo = action['useGo'] == true;
                    if (useGo) {
                      context.go(route);
                    } else {
                      context.push(route);
                    }
                  },
                  child: CardContainer(
                    borderRadius: 18,
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
              },
            ),
            Gaps.xl,
            SectionHeader(
              title: 'Транспорт сегодня',
              subtitle: 'Ближайшие рейсы и автобусы',
              trailing: TextButton(onPressed: () => context.push('/home/transport'), child: const Text('Все расписание')),
            ),
            Gaps.s,
            _TransportPreview(busHighlights: _busHighlights),
            Gaps.xl,
            SectionHeader(
              title: 'Обращения горожан',
              subtitle: 'Статусы и история заявок',
              trailing: TextButton(onPressed: () => context.push('/home/appeals'), child: const Text('Все обращения')),
            ),
            Gaps.s,
            if (submissions.isEmpty)
              CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Пока нет активных обращений', style: Theme.of(context).textTheme.titleSmall),
                    Gaps.s,
                    Text('Создайте заявку через раздел "Сервисы", чтобы получить поддержку.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    Gaps.m,
                    SecondaryButton(text: 'Открыть сервисы', onPressed: () => context.push('/home/services')),
                  ],
                ),
              )
            else
              Column(
                children: submissions.take(3).map((s) => _AppealCard(submission: s)).toList(),
              ),
            Gaps.xl,
            SectionHeader(
              title: t.news,
              subtitle: 'Последние события города',
              trailing: TextButton(onPressed: () => context.go('/news'), child: const Text('Лента')), 
            ),
            Gaps.s,
            if (_filteredPosts.isEmpty)
              CardContainer(
                showShadow: false,
                child: Column(
                  children: [
                    const Icon(Icons.inbox_outlined, size: 42, color: AppColors.textHint),
                    Gaps.s,
                    Text('Новости не найдены', style: Theme.of(context).textTheme.titleMedium),
                    Gaps.xs,
                    Text('Попробуйте изменить запрос или фильтры', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredPosts.length,
                separatorBuilder: (_, __) => Gaps.m,
                itemBuilder: (context, index) {
                  final post = _filteredPosts[index];
                  final isSaved = saved.contains(post.id);
                  final category = _postCategories[post.id] ?? 'Город';
                  return CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(post.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover),
                          ),
                        Gaps.m,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.title, style: Theme.of(context).textTheme.titleSmall),
                                  Gaps.xs,
                                  Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: isSaved ? AppColors.primary : AppColors.textHint),
                              onPressed: () => context.read<AppState>().toggleSavedPost(post.id),
                            ),
                          ],
                        ),
                        Gaps.s,
                        Row(
                          children: [
                            AlertBadge(label: category, backgroundColor: AppColors.primaryLight, textColor: AppColors.primary),
                            const Spacer(),
                            Text(_formatDate(post.date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                            TextButton(onPressed: () => context.push('/home/post/${post.id}'), child: Text(t.readMore)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Сегодня';
    } else if (dateOnly == yesterday) {
      return 'Вчера';
    } else {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
    }
  }
}

class _CityHeroCard extends StatelessWidget {
  final VoidCallback onMapTap;
  const _CityHeroCard({required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      gradient: AppGradients.copperDawn,
      backgroundColor: AppColors.primary,
      border: Border.all(color: Colors.transparent),
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Добро пожаловать в Smart City', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                    Text('Жезказган сегодня', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              SquareIconButton(
                icon: Icons.map_outlined,
                onTap: onMapTap,
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
              ),
            ],
          ),
          Gaps.m,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              InfoPill(label: 'Температура', value: '+2° и ясно', icon: Icons.wb_sunny_outlined),
              InfoPill(label: 'AQI', value: '34 — чистый воздух', icon: Icons.air_outlined),
              InfoPill(label: 'События', value: '3 мероприятия сегодня', icon: Icons.calendar_today_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransportPreview extends StatelessWidget {
  final List<Map<String, String>> busHighlights;
  const _TransportPreview({required this.busHighlights});

  List<ScheduleItem> get _upcoming => List<ScheduleItem>.from(mockSchedule)..sort((a, b) => a.time.compareTo(b.time));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcoming = _upcoming.take(3).toList();
    return Column(
      children: [
        ...upcoming.map((item) {
          return Padding(
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
                    child: Icon(_iconForPlace(item.placeId), color: AppColors.accent),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: theme.textTheme.titleSmall),
                        Text(_formatTime(item.time), style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  StatusChip(label: 'В графике', color: AppColors.success, icon: Icons.check_circle),
                ],
              ),
            ),
          );
        }),
        Gaps.s,
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final bus = busHighlights[index];
              return SizedBox(
                width: 180,
                child: CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bus['line']!, style: theme.textTheme.titleMedium),
                      Text(bus['direction']!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      const Spacer(),
                      Text('Следующий: ${bus['eta']}', style: theme.textTheme.bodyMedium),
                      Text(bus['status']!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: busHighlights.length,
          ),
        ),
      ],
    );
  }

  IconData _iconForPlace(String placeId) {
    final place = mockPlaces.firstWhere((p) => p.id == placeId, orElse: () => mockPlaces.first);
    switch (place.type) {
      case 'airport':
        return Icons.flight_takeoff;
      case 'station':
        return Icons.train_outlined;
      default:
        return Icons.directions_bus;
    }
  }

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class _AppealCard extends StatelessWidget {
  final Map<String, dynamic> submission;
  const _AppealCard({required this.submission});

  @override
  Widget build(BuildContext context) {
    final status = submission['status'] as String? ?? '';
    final created = submission['createdAt'] as DateTime;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(submission['title'] as String, style: Theme.of(context).textTheme.titleSmall)),
                StatusChip(label: status, color: _colorForStatus(status)),
              ],
            ),
            Gaps.s,
            Text('от ${_formatDate(created)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Color _colorForStatus(String status) {
    if (status.contains('заверш') || status.contains('Завершено')) return AppColors.success;
    if (status.contains('обработ')) return AppColors.warning;
    return AppColors.info;
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
}
