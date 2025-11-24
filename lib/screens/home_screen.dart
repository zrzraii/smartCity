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
