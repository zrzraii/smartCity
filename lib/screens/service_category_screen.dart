import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock.dart';
import '../ui/design.dart';

class ServiceCategoryScreen extends StatelessWidget {
  final String categoryId;

  const ServiceCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final matches = mockServices.cast<Map<String, dynamic>>().where((c) => c['id'] == categoryId).toList();
    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const SectionTitle('Сервис')),
        body: const Center(child: Text('Категория не найдена')),
      );
    }

    final category = matches.first;
    final items = (category['items'] as List<dynamic>);

    return Scaffold(
      appBar: AppBar(
        title: SectionTitle(category['title'] as String),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category['description'] as String, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            Gaps.l,
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => Gaps.m,
                itemBuilder: (context, index) {
                  final item = items[index] as Map<String, dynamic>;
                  return CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(item['title'] as String, style: Theme.of(context).textTheme.titleSmall)),
                            IconButton(
                              onPressed: () {
                                // If this is the electricity payment, open full form screen
                                // Navigate to generic service form for any item
                                final catId = category['id'] as String;
                                final itemId = item['id'] as String;
                                context.push('/home/services/$catId/$itemId');
                                return;
                              },
                              icon: const Icon(Icons.arrow_forward_ios, size: 18),
                            ),
                          ],
                        ),
                        Gaps.s,
                        Text(item['description'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
