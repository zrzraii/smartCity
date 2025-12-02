import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/design.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class PaymentFormScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  const PaymentFormScreen({super.key, this.item});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // prefill example data to make the mock experience nicer
    _accountController.text = '12345678';
    _amountController.text = '4560';
    _emailController.text = 'user@example.kz';
    _commentController.text = 'Оплата за октябрь';
  }

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final newSub = {
      'id': 'sub_${DateTime.now().millisecondsSinceEpoch}',
      'serviceId': 'payments',
      'itemId': 'pay_electricity',
      'title': 'Оплата электроэнергии — лиц. счёт ${_accountController.text}',
      'data': {
        'Номер лицевого счёта': _accountController.text,
        'Сумма': '${_amountController.text} ₸',
        'Email для квитанции': _emailController.text,
        'Комментарий': _commentController.text,
      },
      'status': 'В обработке',
      'createdAt': DateTime.now(),
    };

    // add to persistent submissions via AppState
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.addSubmission(newSub);

    await Future.delayed(const Duration(milliseconds: 350));

    setState(() => _saving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заявка отправлена (мок).')));
    // go to appeals history
    context.push('/home/appeals');
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.item != null ? widget.item!['title'] as String : 'Оплата электроэнергии';
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
                  Text('Заполните данные для оплаты', style: Theme.of(context).textTheme.bodyMedium),
                  Gaps.m,
                  TextFormField(
                    controller: _accountController,
                    decoration: const InputDecoration(labelText: 'Номер лицевого счёта'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите номер лицевого счёта' : null,
                  ),
                  Gaps.s,
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Сумма (только число)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Введите сумму';
                      final n = num.tryParse(v.replaceAll(' ', ''));
                      if (n == null) return 'Введите корректную сумму';
                      if (n <= 0) return 'Сумма должна быть больше нуля';
                      return null;
                    },
                  ),
                  Gaps.s,
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email для квитанции (необязательно)'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (!v.contains('@')) return 'Введите корректный email';
                      return null;
                    },
                  ),
                  Gaps.s,
                  TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(labelText: 'Комментарий (необязательно)'),
                    maxLines: 2,
                  ),
                  Gaps.m,
                  PrimaryButton(
                    text: _saving ? 'Отправка...' : 'Оплатить',
                    isLoading: _saving,
                    onPressed: () {
                      if (_saving) return;
                      _submit();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
