import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_city/l10n/gen/app_localizations.dart';

import '../data/mock.dart';
import '../models/notification_settings.dart';
import '../models/user.dart';
import '../state/app_state.dart';
import '../ui/design.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User _currentUser;
  int _currentPage = 0;
  late NotificationSettings _localNotificationSettings;
  static const List<String> _tabs = [
    'Профиль',
    'Безопасность',
    'Уведомления',
    'Язык',
    'Сессии',
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = mockCurrentUser;
    _localNotificationSettings = mockNotificationSettings;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => FilterPill(
                label: _tabs[index],
                isActive: _currentPage == index,
                onTap: () => setState(() => _currentPage = index),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: KeyedSubtree(
                key: ValueKey(_currentPage),
                child: _buildCurrentTab(context, t),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab(BuildContext context, AppLocalizations t) {
    switch (_currentPage) {
      case 1:
        return _buildSecurityTab(context, t);
      case 2:
        return _buildNotificationsTab(context, t);
      case 3:
        return _buildLanguageTab(context, t);
      case 4:
        return _buildSessionsTab(context, t);
      default:
        return _buildProfileTab(context, t);
    }
  }

  // ============= PROFILE TAB =============
  Widget _buildProfileTab(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.l,
          // User Profile Card
          CardContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                Gaps.l,
                Text(
                  _currentUser.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Gaps.s,
                Text(
                  _currentUser.email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.m,
                Text(
                  _currentUser.phoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Gaps.xl,
          // Profile Information
          SectionTitle('Информация профиля'),
          Gaps.l,
          _buildSettingsItem(
            icon: Icons.person_outline,
            title: 'Имя',
            value: _currentUser.firstName,
            onTap: () => _showEditDialog(
              context,
              'Изменить имя',
              _currentUser.firstName,
              (value) {
                setState(() {
                  _currentUser = User(
                    id: _currentUser.id,
                    firstName: value,
                    lastName: _currentUser.lastName,
                    email: _currentUser.email,
                    phoneNumber: _currentUser.phoneNumber,
                    city: _currentUser.city,
                    createdAt: _currentUser.createdAt,
                  );
                });
              },
            ),
          ),
          Gaps.m,
          _buildSettingsItem(
            icon: Icons.person_outline,
            title: 'Фамилия',
            value: _currentUser.lastName,
            onTap: () => _showEditDialog(
              context,
              'Изменить фамилию',
              _currentUser.lastName,
              (value) {
                setState(() {
                  _currentUser = User(
                    id: _currentUser.id,
                    firstName: _currentUser.firstName,
                    lastName: value,
                    email: _currentUser.email,
                    phoneNumber: _currentUser.phoneNumber,
                    city: _currentUser.city,
                    createdAt: _currentUser.createdAt,
                  );
                });
              },
            ),
          ),
          Gaps.m,
          _buildSettingsItem(
            icon: Icons.email_outlined,
            title: 'Email',
            value: _currentUser.email,
            onTap: () => _showEditDialog(
              context,
              'Изменить email',
              _currentUser.email,
              (value) {
                setState(() {
                  _currentUser = User(
                    id: _currentUser.id,
                    firstName: _currentUser.firstName,
                    lastName: _currentUser.lastName,
                    email: value,
                    phoneNumber: _currentUser.phoneNumber,
                    city: _currentUser.city,
                    createdAt: _currentUser.createdAt,
                  );
                });
              },
            ),
          ),
          Gaps.m,
          _buildSettingsItem(
            icon: Icons.phone_outlined,
            title: 'Номер телефона',
            value: _currentUser.phoneNumber,
            onTap: () => _showEditDialog(
              context,
              'Изменить номер',
              _currentUser.phoneNumber,
              (value) {
                setState(() {
                  _currentUser = User(
                    id: _currentUser.id,
                    firstName: _currentUser.firstName,
                    lastName: _currentUser.lastName,
                    email: _currentUser.email,
                    phoneNumber: value,
                    city: _currentUser.city,
                    createdAt: _currentUser.createdAt,
                  );
                });
              },
            ),
          ),
          Gaps.m,
          _buildSettingsItem(
            icon: Icons.location_city_outlined,
            title: 'Город',
            value: _currentUser.city,
            onTap: () {},
          ),
          Gaps.xxl,
        ],
      ),
    );
  }

  // ============= SECURITY TAB =============
  Widget _buildSecurityTab(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.l,
          SectionTitle('Безопасность приложения'),
          Gaps.l,
          CardContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Пароль приложения',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Gaps.s,
                        Text(
                          'Установить пароль для входа в приложение',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Switch(
                      value: (context.watch<AppState>().appPassword?.isNotEmpty ?? false),
                      onChanged: (value) {
                        if (value) {
                          _showPasswordDialog(context);
                        } else {
                          context.read<AppState>().setAppPassword('');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Пароль удалён')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gaps.l,
          PrimaryButton(
            text: 'Изменить пароль приложения',
            onPressed: () => _showPasswordDialog(context),
          ),
          Gaps.xl,
          SectionTitle('Учётные данные'),
          Gaps.l,
          CardContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Обновить данные входа',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Gaps.m,
                Builder(builder: (context) {
                  final emailController = TextEditingController(text: _currentUser.email);
                  final passwordController = TextEditingController();
                  return Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: _currentUser.email,
                        ),
                      ),
                      Gaps.m,
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                          hintText: '••••••••',
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                        obscureText: true,
                      ),
                      Gaps.xl,
                      PrimaryButton(
                        text: 'Сохранить изменения',
                        onPressed: () {
                          setState(() {
                            _currentUser = User(
                              id: _currentUser.id,
                              firstName: _currentUser.firstName,
                              lastName: _currentUser.lastName,
                              email: emailController.text,
                              phoneNumber: _currentUser.phoneNumber,
                              city: _currentUser.city,
                              createdAt: _currentUser.createdAt,
                            );
                          });
                          if (passwordController.text.isNotEmpty) {
                            context.read<AppState>().setAppPassword(passwordController.text);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Данные обновлены'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Gaps.xxl,
        ],
      ),
    );
  }

  // ============= NOTIFICATIONS TAB =============
  Widget _buildNotificationsTab(BuildContext context, AppLocalizations t) {
    final settings = _localNotificationSettings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.l,
          SectionTitle('Тип уведомлений'),
          Gaps.l,
          _buildToggleSetting(
            title: 'Штормовые предупреждения',
            subtitle: 'Получайте предупреждения о штормовых явлениях',
            value: settings.stormAlerts,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(stormAlerts: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.m,
          _buildToggleSetting(
            title: 'Информация о погоде',
            subtitle: 'Получайте прогнозы и предупреждения о погоде',
            value: settings.weatherAlerts,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(weatherAlerts: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.m,
          _buildToggleSetting(
            title: 'Информация о транспорте',
            subtitle: 'Получайте уведомления об изменениях маршрутов',
            value: settings.transportAlerts,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(transportAlerts: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.m,
          _buildToggleSetting(
            title: 'Коммунальные уведомления',
            subtitle: 'Получайте информацию о перебоях в сервисах',
            value: settings.utilitiesAlerts,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(utilitiesAlerts: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.m,
          _buildToggleSetting(
            title: 'Экстренные сообщения',
            subtitle: 'Получайте критичные оповещения',
            value: settings.emergencyAlerts,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(emergencyAlerts: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.xl,
          SectionTitle('Каналы получения'),
          Gaps.l,
          _buildToggleSetting(
            title: 'Push-уведомления',
            subtitle: 'Получайте уведомления на устройстве',
            value: settings.pushNotifications,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(pushNotifications: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.m,
          _buildToggleSetting(
            title: 'Email-уведомления',
            subtitle: 'Получайте уведомления на email',
            value: settings.emailNotifications,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(emailNotifications: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.m,
          _buildToggleSetting(
            title: 'SMS-уведомления',
            subtitle: 'Получайте важные уведомления по SMS',
            value: settings.smsNotifications,
            onChanged: (value) {
              setState(() => _localNotificationSettings = _localNotificationSettings.copyWith(smsNotifications: value));
              context.read<AppState>().setNotificationSettings(_localNotificationSettings);
            },
          ),
          Gaps.xxl,
        ],
      ),
    );
  }

  // ============= LANGUAGE TAB =============
  Widget _buildLanguageTab(BuildContext context, AppLocalizations t) {
    final appState = context.watch<AppState>();
    final languages = [
      ('ru', 'Русский', '🇷🇺'),
      ('kk', 'Қазақша', '🇰🇿'),
      ('en', 'English', '🇬🇧'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.l,
          SectionTitle('Выберите язык'),
          Gaps.l,
          ...languages.map((lang) {
            final (code, name, flag) = lang;
            final isSelected = appState.locale?.languageCode == code;

            return Column(
              children: [
                CardContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  backgroundColor: isSelected
                      ? AppColors.primaryLight
                      : AppColors.surface,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  child: InkWell(
                    onTap: () {
                      context.read<AppState>().setLocale(Locale(code));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
                Gaps.m,
              ],
            );
          }),
          Gaps.xxl,
        ],
      ),
    );
  }

  // ============= SESSIONS TAB =============
  Widget _buildSessionsTab(BuildContext context, AppLocalizations t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.l,
          SectionTitle('Активные сессии'),
          Gaps.m,
          Text(
            'Устройства с которых осуществлен вход в приложение',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          Gaps.l,
          ...mockUserSessions.map((session) {
            return Column(
              children: [
                CardContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    session.deviceType == 'phone'
                                        ? Icons.smartphone
                                        : session.deviceType == 'tablet'
                                            ? Icons.tablet
                                            : Icons.desktop_mac,
                                    size: 24,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.deviceName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Gaps.xs,
                                      Text(
                                        session.platform,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textTertiary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Gaps.m,
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    session.ipAddress,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (session.isCurrentSession)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: fadedColor(AppColors.success, 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Текущая',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      Gaps.l,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Вход',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textTertiary),
                              ),
                              Gaps.xs,
                              Text(
                                _formatSessionTime(session.loginTime),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          if (session.lastActivityTime != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Последняя активность',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textTertiary),
                                ),
                                Gaps.xs,
                                Text(
                                  _formatSessionTime(
                                    session.lastActivityTime!,
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (!session.isCurrentSession) ...[
                        Gaps.m,
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Сессия завершена',
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                            child: const Text('Завершить сессию'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Gaps.m,
              ],
            );
          }),
          Gaps.xxl,
        ],
      ),
    );
  }

  // ============= HELPER WIDGETS =============
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    const double rowHeight = 56;
    return CardContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: fadedColor(AppColors.primary, 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.bodyMedium),
                      Gaps.xs,
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.edit, size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    const double rowHeight = 72;
    return CardContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: SizedBox(
        height: rowHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  Gaps.s,
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 56,
              child: Align(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Данные обновлены'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Установить пароль приложения'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Подтвердить пароль',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text == confirmController.text) {
                context.read<AppState>().setAppPassword(passwordController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Пароль установлен'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Пароли не совпадают'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Установить'),
          ),
        ],
      ),
    );
  }

  String _formatSessionTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else {
      return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }
  }
}
