import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/design.dart';
import '../data/mock.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const Map<String, IconData> _icons = {
    'payments': Icons.account_balance_wallet,
    'identification': Icons.badge,
    'transport': Icons.directions_bus,
    'family': Icons.family_restroom,
    'medicine': Icons.local_hospital,
    'social': Icons.support,
    'education': Icons.school,
    'property': Icons.home_work,
    'employment': Icons.work,
    'powers': Icons.assignment,
  };

  @override
  Widget build(BuildContext context) {
    final services = mockServices.cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(
        title: const SectionTitle('Сервисы'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final s = services[index];
            final id = s['id'] as String;
            final title = s['title'] as String;
            final desc = s['description'] as String;
            final icon = _icons[id] ?? Icons.miscellaneous_services;

            return CardContainer(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push('/home/services/$id'),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 48,
                        decoration: BoxDecoration(
                          color: fadedColor(AppColors.primary, 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: AppColors.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(title, style: Theme.of(context).textTheme.titleSmall),
                      Gaps.s,
                      Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
