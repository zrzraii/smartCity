import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import '../data/mock.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final posts = mockPosts;
    final saved = context.watch<AppState>().savedPostIds;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tabHome, style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 1)),
        leadingWidth: 64,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: SquareIconButton(icon: Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.l,
            SectionTitle(t.news),
            Gaps.m,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              separatorBuilder: (_, __) => Gaps.m,
              itemBuilder: (context, index) {
                final post = posts[index];
                final isSaved = saved.contains(post.id);
                return CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(post.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover),
                        ),
                        Gaps.m,
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(post.title, style: Theme.of(context).textTheme.titleSmall),
                          ),
                          IconButton(
                            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                            onPressed: () => context.read<AppState>().toggleSavedPost(post.id),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/home/post/${post.id}'),
                          child: Text(t.readMore),
                        ),
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
}
