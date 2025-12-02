import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../ui/design.dart';

class AppealsScreen extends StatelessWidget {
  const AppealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final submissions = context.watch<AppState>().submissions;
    final inProgress = submissions.where((s) => (s['status'] as String).contains('В обработке')).length;
    final resolved = submissions.where((s) => (s['status'] as String).contains('Завершено')).length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const SectionTitle('Обращения горожан'),
        actions: [
          SquareIconButton(
            icon: Icons.info_outline,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Гид по обращению (мок)'))),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CardContainer(
            gradient: AppGradients.steppeSky,
            border: Border.all(color: Colors.transparent),
            showShadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('В едином окне услуг', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                Text('Управление обращениями', style: Theme.of(context).textTheme.titleLarge),
                Gaps.m,
                Row(
                  children: [
                    Expanded(child: _MetricItem(label: 'Всего', value: submissions.length.toString())),
                    Expanded(child: _MetricItem(label: 'В работе', value: inProgress.toString())),
                    Expanded(child: _MetricItem(label: 'Закрыто', value: resolved.toString())),
                  ],
                ),
                Gaps.m,
                PrimaryButton(
                  text: 'Новое обращение',
                  icon: Icons.add,
                  onPressed: () => context.push('/home/services'),
                ),
              ],
            ),
          ),
          Gaps.xl,
          SectionHeader(
            title: 'Статусы заявок',
            subtitle: 'Следите за этапами рассмотрения',
          ),
          Gaps.s,
          if (submissions.isEmpty)
            CardContainer(
              showShadow: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Пока нет обращений', style: Theme.of(context).textTheme.titleSmall),
                  Gaps.s,
                  Text('Создайте первое обращение и отслеживайте его статус здесь.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  Gaps.m,
                  SecondaryButton(text: 'Открыть сервисы', onPressed: () => context.push('/home/services')),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: submissions.length,
              separatorBuilder: (_, __) => Gaps.m,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                final date = submission['createdAt'] as DateTime;
                final status = submission['status'] as String? ?? '';
                return GestureDetector(
                  onTap: () => _showDetails(context, submission),
                  child: CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StatusChip(label: status, color: _statusColor(status), icon: Icons.circle),
                            const Spacer(),
                            Icon(Icons.chevron_right, color: AppColors.textHint),
                          ],
                        ),
                        Gaps.s,
                        Text(submission['title'] as String, style: Theme.of(context).textTheme.titleSmall),
                        Gaps.xs,
                        Text(_fmt(date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status.toLowerCase().contains('заверш')) return AppColors.success;
    if (status.toLowerCase().contains('в обработ')) return AppColors.warning;
    return AppColors.info;
  }

  String _fmt(DateTime dt) {
    final d = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} · ${two(d.hour)}:${two(d.minute)}';
  }

  void _showDetails(BuildContext context, Map<String, dynamic> submission) {
    final data = submission['data'] as Map<String, dynamic>? ?? {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(submission['title'] as String, style: Theme.of(context).textTheme.titleLarge)),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
              Gaps.s,
              Text('Статус: ${submission['status']}', style: Theme.of(context).textTheme.bodyMedium),
              Gaps.m,
              ...data.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(e.key, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text('${e.value}', style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.l,
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Скачать квитанцию',
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Квитанция загружена (мок)')));
                      },
                    ),
                  ),
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

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
