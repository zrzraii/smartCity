import 'package:flutter/material.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/mock.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final post = mockPosts.firstWhere((p) => p.id == widget.postId);
    final isSaved = context.watch<AppState>().savedPostIds.contains(post.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => Share.share('${post.title}\n\n${post.content}'),
            tooltip: t.share,
          ),
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => context.read<AppState>().toggleSavedPost(post.id),
            tooltip: isSaved ? t.saved : t.save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.imageUrl != null)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: PhotoView(imageProvider: NetworkImage(post.imageUrl!)),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(post.imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton.tonal(
                    onPressed: () => setState(() => scale = (scale + 0.1).clamp(0.8, 2.0)),
                    child: Text(t.increaseText),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: () => setState(() => scale = (scale - 0.1).clamp(0.8, 2.0)),
                    child: Text(t.decreaseText),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.content,
                textScaler: TextScaler.linear(scale),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
