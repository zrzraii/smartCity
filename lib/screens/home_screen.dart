import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import '../data/mock.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  List<Post> _filteredPosts = [];
  // Mock services for the Services grid
  final List<Map<String, dynamic>> _services = [
    {'id': 'svc_pay', 'title': 'Платежи', 'icon': Icons.account_balance_wallet},
    {'id': 'svc_requests', 'title': 'Заявки', 'icon': Icons.build},
    {'id': 'svc_transport', 'title': 'Транспорт', 'icon': Icons.directions_bus},
    {'id': 'svc_health', 'title': 'Медицина', 'icon': Icons.local_hospital},
    {'id': 'svc_announcements', 'title': 'Объявления', 'icon': Icons.campaign},
    {'id': 'svc_support', 'title': 'Поддержка', 'icon': Icons.support_agent},
  ];

  String _sortBy = 'Популярные';

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
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPosts = mockPosts;
      } else {
        _filteredPosts = mockPosts.where((post) {
          return post.title.toLowerCase().contains(query) ||
              post.content.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filteredPosts = mockPosts;
  }

  void _changeSort(String value) {
    setState(() {
      _sortBy = value;
      // Mock sorting behaviour: just reorder by chosen option
      if (_sortBy == 'По алфавиту') {
        _services.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));
      } else if (_sortBy == 'По удаленности') {
        // keep mock order (no real distance)
      } else {
        // Популярные — default order
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final saved = context.watch<AppState>().savedPostIds;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.tabHome,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        leadingWidth: 64,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: SquareIconButton(icon: Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.l,
            // Search Bar
            SearchTextField(
              controller: _searchController,
              hintText: 'Поиск новостей...',
              onClear: _clearSearch,
            ),
            Gaps.xl,
            // Services section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionTitle('Сервисы'),
                Row(
                  children: [
                    Text(
                      'Сортировка:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: _changeSort,
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Популярные', child: Text('Популярные')),
                        const PopupMenuItem(value: 'По алфавиту', child: Text('По алфавиту')),
                        const PopupMenuItem(value: 'По удаленности', child: Text('По удаленности')),
                      ],
                      child: Row(
                        children: [
                          Text(_sortBy, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gaps.m,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final svc = _services[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to services page (mock)
                    context.push('/home/services');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(svc['icon'] as IconData, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          svc['title'] as String,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Gaps.xl,
            // Section Title
            SectionTitle(t.news),
            Gaps.l,
            // Posts List
            if (_filteredPosts.isEmpty)
              Center(
                child: Column(
                  children: [
                    Gaps.xxl,
                    Icon(
                      Icons.inbox,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    Gaps.l,
                    Text(
                      'Новости не найдены',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
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
                  return CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.imageUrl != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              post.imageUrl!,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Gaps.m,
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                post.title,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: isSaved
                                    ? AppColors.primary
                                    : AppColors.textHint,
                              ),
                              onPressed: () =>
                                  context.read<AppState>().toggleSavedPost(post.id),
                            ),
                          ],
                        ),
                        Gaps.s,
                        Text(
                          post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        Gaps.m,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(post.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textTertiary),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.push('/home/post/${post.id}'),
                              child: Text(t.readMore),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 100),
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
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
