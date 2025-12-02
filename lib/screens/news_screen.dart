import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/mock.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Post> _results = [];
  String _selectedCategory = 'Все';

  final Map<String, String> _postCategories = const {
    'p1': 'Город',
    'p2': 'Культура',
    'p3': 'Транспорт',
    'p4': 'Коммунальные',
    'p5': 'Город',
    'p6': 'Культура',
  };

  final List<String> _categories = const ['Все', 'Город', 'Транспорт', 'Коммунальные', 'Культура', 'Спорт'];

  @override
  void initState() {
    super.initState();
    _results = mockPosts;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _results = mockPosts.where((p) {
        final matchesQuery = q.isEmpty || p.title.toLowerCase().contains(q) || p.content.toLowerCase().contains(q);
        final cat = _postCategories[p.id] ?? 'Все';
        final matchesCategory = _selectedCategory == 'Все' || cat == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
      _onSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final featured = _results.isNotEmpty ? _results.first : null;
    final rest = _results.length > 1 ? _results.sublist(1) : <Post>[];
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Новости города', style: Theme.of(context).textTheme.titleLarge),
            Text('Актуальные события Жезказгана', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
          setState(() {
            _results = List.from(mockPosts);
          });
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchTextField(
                      controller: _searchController,
                      hintText: 'Поиск новостей, статей, публикаций',
                      onClear: () => _searchController.clear(),
                    ),
                    Gaps.m,
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          return FilterPill(
                            label: cat,
                            isActive: cat == _selectedCategory,
                            onTap: () => _selectCategory(cat),
                          );
                        },
                      ),
                    ),
                    Gaps.l,
                    if (featured != null)
                      _FeaturedNewsCard(
                        post: featured,
                        category: _postCategories[featured.id] ?? 'Город',
                        isSaved: appState.savedPostIds.contains(featured.id),
                        onBookmark: () => appState.toggleSavedPost(featured.id),
                        onTap: () => context.push('/home/post/${featured.id}'),
                      ),
                    Gaps.l,
                    SectionHeader(
                      title: 'Лента новостей',
                      subtitle: 'Свежие обновления города',
                    ),
                    Gaps.s,
                  ],
                ),
              ),
            ),
            if (_results.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CardContainer(
                      showShadow: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off_outlined, size: 48, color: AppColors.textHint),
                          Gaps.m,
                          Text('Ничего не найдено', style: Theme.of(context).textTheme.titleMedium),
                          Gaps.s,
                          Text(
                            'Попробуйте изменить запрос или сбросить фильтры',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                          ),
                          Gaps.m,
                          SecondaryButton(
                            text: 'Сбросить фильтры',
                            onPressed: () {
                              _searchController.clear();
                              _selectCategory('Все');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 12);
                      }
                      final postIndex = index ~/ 2;
                      final post = rest[postIndex];
                      final category = _postCategories[post.id] ?? 'Город';
                      final isSaved = appState.savedPostIds.contains(post.id);
                      return CardContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StatusChip(label: category, color: AppColors.accent),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                                  onPressed: () => appState.toggleSavedPost(post.id),
                                ),
                              ],
                            ),
                            Text(post.title, style: Theme.of(context).textTheme.titleSmall),
                            Gaps.xs,
                            Text(
                              post.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            ),
                            Gaps.s,
                            Row(
                              children: [
                                Text(
                                  _formatDate(post.date),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => context.push('/home/post/${post.id}'),
                                  child: const Text('Читать полностью'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: rest.isEmpty ? 0 : rest.length * 2 - 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
}

class _FeaturedNewsCard extends StatelessWidget {
  final Post post;
  final String category;
  final bool isSaved;
  final VoidCallback onBookmark;
  final VoidCallback onTap;

  const _FeaturedNewsCard({
    required this.post,
    required this.category,
    required this.isSaved,
    required this.onBookmark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CardContainer(
        gradient: AppGradients.copperDawn,
        border: Border.all(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusChip(label: category, color: Colors.white, icon: Icons.auto_awesome),
            Gaps.s,
            Text(post.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
            Gaps.s,
            Text(post.content, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            Gaps.m,
            Row(
              children: [
                Text('Обновлено ${_formatTime(post.date)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                const Spacer(),
                IconButton(
                  onPressed: onBookmark,
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
