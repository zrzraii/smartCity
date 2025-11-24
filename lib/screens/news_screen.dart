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

  // local mapping of post id to category (mock)
  final Map<String, String> _postCategories = {
    'p1': 'Город',
    'p2': 'Культура',
    'p3': 'Транспорт',
    'p4': 'Коммунальные',
    'p5': 'Город',
  };

  final List<String> _categories = [
    'Все',
    'Город',
    'Транспорт',
    'Коммунальные',
    'Культура',
    'Спорт',
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const SectionTitle('Новости Жезказгана'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.l,
            SearchTextField(
              controller: _searchController,
              hintText: 'Поиск новостей, статей, публикаций',
            ),
            Gaps.m,
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isActive = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => _selectCategory(cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        cat,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isActive ? Colors.white : AppColors.textPrimary,
                              fontSize: 13,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Gaps.l,
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 56, color: AppColors.textTertiary),
                          Gaps.m,
                          Text('Ничего не найдено', style: Theme.of(context).textTheme.titleSmall),
                          Gaps.s,
                          Text('Попробуйте изменить запрос или сбросить фильтры', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                          Gaps.m,
                          SecondaryButton(text: 'Сбросить фильтры', onPressed: () {
                            _searchController.clear();
                            _selectCategory('Все');
                          }),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        // simulate refresh
                        await Future.delayed(const Duration(milliseconds: 400));
                        setState(() {
                          _results = List.from(mockPosts);
                        });
                      },
                      child: ListView.builder(
                        itemCount: 1 + (_results.length - 1),
                        itemBuilder: (context, index) {
                          final appState = Provider.of<AppState>(context);
                          if (index == 0) {
                            // featured
                            final post = _results[0];
                            final cat = _postCategories[post.id] ?? '—';
                            return GestureDetector(
                              onTap: () => context.push('/home/post/${post.id}'),
                              child: CardContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (post.imageUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(post.imageUrl!, width: double.infinity, height: 160, fit: BoxFit.cover),
                                      ),
                                    Gaps.s,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(post.title, style: Theme.of(context).textTheme.titleLarge)),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(post.author ?? '', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                                            Text(post.readTimeMinutes != null ? '${post.readTimeMinutes} мин' : _formatDate(post.date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Gaps.s,
                                    Text(post.content, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                                    Gaps.m,
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => appState.toggleSavedPost(post.id),
                                          icon: Icon(appState.savedPostIds.contains(post.id) ? Icons.bookmark : Icons.bookmark_outline, color: AppColors.primary),
                                        ),
                                        IconButton(
                                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Поделиться (заглушка)'))),
                                          icon: const Icon(Icons.share_outlined),
                                        ),
                                        const Spacer(),
                                        AlertBadge(label: cat, backgroundColor: AppColors.primaryLight, textColor: AppColors.primary),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final post = _results[index];
                          final cat = _postCategories[post.id] ?? '—';
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context.push('/home/post/${post.id}'),
                              child: CardContainer(
                                child: Row(
                                  children: [
                                    if (post.imageUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(post.imageUrl!, width: 96, height: 64, fit: BoxFit.cover),
                                      ),
                                    if (post.imageUrl != null) const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: Text(post.title, style: Theme.of(context).textTheme.titleSmall)),
                                              Text(_formatDate(post.date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                                            ],
                                          ),
                                          Gaps.s,
                                          Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                                          Gaps.s,
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () => Provider.of<AppState>(context, listen: false).toggleSavedPost(post.id),
                                                icon: Icon(Provider.of<AppState>(context).savedPostIds.contains(post.id) ? Icons.bookmark : Icons.bookmark_outline, color: AppColors.primary),
                                              ),
                                              const SizedBox(width: 8),
                                              AlertBadge(label: cat, backgroundColor: AppColors.primaryLight, textColor: AppColors.primary),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Сегодня';
    if (diff.inDays == 1) return 'Вчера';
    return '${date.day}.${date.month}.${date.year}';
  }
}
