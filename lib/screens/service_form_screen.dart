import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../data/mock.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class ServiceFormScreen extends StatefulWidget {
  final String serviceId;
  final String itemId;
  const ServiceFormScreen({super.key, required this.serviceId, required this.itemId});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _submitting = false;
  Map<String, dynamic>? _item;

  @override
  void initState() {
    super.initState();
    // find item from mockServices
    final cat = mockServices.cast<Map<String, dynamic>>().firstWhere((c) => c['id'] == widget.serviceId, orElse: () => {});
    if (cat.isNotEmpty) {
      final items = (cat['items'] as List<dynamic>);
      final found = items.cast<Map<String, dynamic>>().firstWhere((i) => i['id'] == widget.itemId, orElse: () => {});
      if (found.isNotEmpty) {
        _item = found;
        final fields = (found['fields'] as List<dynamic>).cast<String>();
        for (var f in fields) {
          final ctrl = TextEditingController();
          // basic prefills for common fields
          if (f.toLowerCase().contains('лицев') || f.toLowerCase().contains('номер')) ctrl.text = '12345678';
          if (f.toLowerCase().contains('сумма')) ctrl.text = '4560';
          if (f.toLowerCase().contains('email')) ctrl.text = 'user@example.kz';
          _controllers[f] = ctrl;
        }
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final data = <String, dynamic>{};
    for (var entry in _controllers.entries) {
      data[entry.key] = entry.value.text;
    }

    final newSub = {
      'id': 'sub_${DateTime.now().millisecondsSinceEpoch}',
      'serviceId': widget.serviceId,
      'itemId': widget.itemId,
      'title': '${_item?['title'] ?? 'Сервис'} — ${data.values.first}',
      'data': data,
      'status': 'В обработке',
      'createdAt': DateTime.now(),
    };

    await Provider.of<AppState>(context, listen: false).addSubmission(newSub);

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заявка отправлена (мок).')));
    context.push('/home/appeals');
  }

  @override
  Widget build(BuildContext context) {
    final title = _item != null ? _item!['title'] as String : 'Оформление услуги';
    final fields = _item != null ? (_item!['fields'] as List<dynamic>).cast<String>() : <String>[];
    return Scaffold(
      appBar: AppBar(title: SectionTitle(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: CardContainer(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Поля для оформления', style: Theme.of(context).textTheme.bodyMedium),
                  Gaps.m,
                  ...fields.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _controllers[f],
                          decoration: InputDecoration(labelText: f),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Заполните поле' : null,
                        ),
                      )),
                  Gaps.m,
                  PrimaryButton(text: _submitting ? 'Отправка...' : 'Отправить', isLoading: _submitting, onPressed: _submitting ? () {} : _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
