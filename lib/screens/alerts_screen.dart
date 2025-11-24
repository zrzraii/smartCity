import 'package:flutter/material.dart';

import '../data/mock.dart';
import '../models/alert.dart';
import '../ui/design.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late TextEditingController _searchController;
  String? _selectedCategory;
  AlertSeverity? _selectedSeverity;
  List<Alert> _filteredAlerts = [];

  final categories = const [
    ('all', 'Все'),
    ('storm', 'Штормовые'),
    ('weather', 'Погода'),
    ('transport', 'Транспорт'),
    ('utilities', 'Коммунальные'),
    ('emergency', 'Экстренные'),
  ];

  final severities = const [
    (AlertSeverity.critical, 'Критичные'),
    (AlertSeverity.high, 'Высокие'),
    (AlertSeverity.medium, 'Средние'),
    (AlertSeverity.low, 'Низкие'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredAlerts = mockAlerts;
    _searchController.addListener(_filterAlerts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAlerts() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredAlerts = mockAlerts.where((alert) {
        // Фильтр по поисковой строке
        final matchesSearch = query.isEmpty ||
            alert.title.toLowerCase().contains(query) ||
            alert.description.toLowerCase().contains(query);

        // Фильтр по категории
        final matchesCategory = _selectedCategory == null ||
            _selectedCategory == 'all' ||
            alert.category == _selectedCategory;

        // Фильтр по серьезности
        final matchesSeverity =
            _selectedSeverity == null || alert.severity == _selectedSeverity;

        return matchesSearch && matchesCategory && matchesSeverity;
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return AppColors.criticalRed;
      case AlertSeverity.high:
        return AppColors.highOrange;
      case AlertSeverity.medium:
        return AppColors.mediumYellow;
      case AlertSeverity.low:
        return AppColors.lowGreen;
    }
  }

  String _getSeverityLabel(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return 'Критично';
      case AlertSeverity.high:
        return 'Высокий';
      case AlertSeverity.medium:
        return 'Средний';
      case AlertSeverity.low:
        return 'Низкий';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'storm':
        return Icons.thunderstorm;
      case 'weather':
        return Icons.cloud;
      case 'transport':
        return Icons.directions_bus;
      case 'utilities':
        return Icons.home_repair_service;
      case 'emergency':
        return Icons.emergency;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Оповещения',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                SearchTextField(
                  controller: _searchController,
                  hintText: 'Поиск оповещений...',
                  onClear: _clearSearch,
                ),
                Gaps.l,
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final (value, label) = categories[index];
                      final isSelected = _selectedCategory == value;
                      return FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory =
                                isSelected ? null : (value == 'all' ? null : value);
                          });
                          _applyFilters();
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primaryLight,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      );
                    },
                  ),
                ),
                Gaps.l,
                // Severity Filter
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: severities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final (severity, label) = severities[index];
                      final isSelected = _selectedSeverity == severity;
                      return FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedSeverity =
                                isSelected ? null : severity;
                          });
                          _applyFilters();
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primaryLight,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Alerts List
          Expanded(
            child: _filteredAlerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        Gaps.l,
                        Text(
                          'Нет оповещений',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAlerts.length,
                    separatorBuilder: (_, __) => Gaps.m,
                    itemBuilder: (context, index) {
                      final alert = _filteredAlerts[index];
                      final severityColor = _getSeverityColor(alert.severity);

                      return CardContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with severity and category
                            Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(alert.category),
                                  color: severityColor,
                                  size: 24,
                                ),
                                Gaps.m,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alert.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Gaps.xs,
                                      AlertBadge(
                                        label: _getSeverityLabel(alert.severity),
                                        backgroundColor: severityColor
                                            .withOpacity(0.1),
                                        textColor: severityColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gaps.m,
                            // Description
                            Text(
                              alert.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Gaps.m,
                            // Footer with location and time
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                if (alert.location != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: AppColors.textTertiary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        alert.location!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textTertiary,
                                            ),
                                      ),
                                    ],
                                  ),
                                Text(
                                  _formatTime(alert.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else {
      return '${difference.inDays} дн назад';
    }
  }
}
