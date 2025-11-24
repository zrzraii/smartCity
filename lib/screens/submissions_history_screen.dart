import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Simple date formatting without intl
import '../state/app_state.dart';
import '../ui/design.dart';

class SubmissionsHistoryScreen extends StatelessWidget {
  const SubmissionsHistoryScreen({super.key});

  String _fmt(DateTime dt) {
    final d = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SectionTitle('История заявлений')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Builder(builder: (context) {
          final subs = Provider.of<AppState>(context).submissions;
          if (subs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inbox, size: 54, color: AppColors.textHint),
                  Gaps.s,
                  Text('Заявок ещё нет', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                  Gaps.m,
                  Text('Отправленные заявки будут отображаться здесь.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: subs.length,
            separatorBuilder: (_, __) => Gaps.m,
            itemBuilder: (context, index) {
              final s = subs[index];
              final created = s['createdAt'] as DateTime;
              return CardContainer(
                child: ListTile(
                  title: Text(s['title'] as String, style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text('${s['status']} • ${_fmt(created)}', style: Theme.of(context).textTheme.bodySmall),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDetails(context, s),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final data = (s['data'] as Map<String, dynamic>);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s['title'] as String, style: Theme.of(context).textTheme.titleLarge),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
              Gaps.s,
              Text('Статус: ${s['status']}', style: Theme.of(context).textTheme.bodyMedium),
              Gaps.m,
              ...data.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: Text('${e.key}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
                        Expanded(flex: 5, child: Text('${e.value}', style: Theme.of(context).textTheme.bodySmall)),
                      ],
                    ),
                  )),
              Gaps.m,
              Row(
                children: [
                  Expanded(child: SecondaryButton(text: 'Скачать квитанцию', onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Квитанция загружена (заглушка)')));
                  })),
                  const SizedBox(width: 12),
                  Expanded(child: PrimaryButton(text: 'Закрыть', onPressed: () => Navigator.pop(ctx))),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
