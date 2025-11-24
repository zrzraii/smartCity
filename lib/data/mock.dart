import '../models/post.dart';
import '../models/place.dart';
import '../models/schedule_item.dart';
import '../models/alert.dart';
import '../models/user_session.dart';
import '../models/user.dart';
import '../models/notification_settings.dart';

final mockCurrentUser = User(
  id: 'u1',
  firstName: 'Райхан',
  lastName: 'Айтжанова',
  email: 'aitraihan@gmail.com',
  phoneNumber: '+7 (701) 234-56-78',
  city: 'Жезказган',
  createdAt: DateTime.now().subtract(const Duration(days: 365)),
);

final mockPosts = <Post>[
  Post(
    id: 'p1',
    title: 'Марафон города Жезказган объявлен',
    content:
        'Присоединяйтесь к ежегодному марафону города на выходных. Дороги в центре города будут частично перекрыты.',
    date: DateTime.now(),
    imageUrl: 'https://picsum.photos/seed/marathon/800/400',
  ),
  Post(
    id: 'p2',
    title: 'Новые развлекательные объекты открыты',
    content:
        'В центре города открылись новые магазины и развлекательные центры с расширенным сервисом.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl: 'https://picsum.photos/seed/entertainment/800/400',
  ),
  Post(
    id: 'p3',
    title: 'Расписание общественного транспорта обновлено',
    content: 'Расписание автобусов и троллейбусов обновлено на зимний сезон.',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Post(
    id: 'p4',
    title: 'Информация о плановых отключениях электроэнергии',
    content:
        'Плановое отключение электроэнергии в районе Центральной улицы с 09:00 до 15:00.',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    imageUrl: 'https://picsum.photos/seed/power/800/400',
  ),
  Post(
    id: 'p5',
    title: 'Ремонт дорог на улице Абая',
    content:
        'Начаты работы по ремонту и улучшению качества дорог. Прожит способ может быть затруднен.',
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

final mockAlerts = <Alert>[
  Alert(
    id: 'a1',
    title: 'Штормовое предупреждение',
    description:
        'Ожидается сильный ветер и грозные дожди. Рекомендуется избегать открытых пространств.',
    category: 'storm',
    severity: AlertSeverity.critical,
    createdAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
    location: 'Жезказган',
  ),
  Alert(
    id: 'a2',
    title: 'Проблема с водоснабжением',
    description:
        'В районе Советского района возможны перебои с подачей горячей воды.',
    category: 'utilities',
    severity: AlertSeverity.high,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    location: 'Советский район',
  ),
  Alert(
    id: 'a3',
    title: 'Изменение маршрутов общественного транспорта',
    description:
        'Маршруты № 5 и № 12 будут временно изменены из-за ремонта дорог.',
    category: 'transport',
    severity: AlertSeverity.medium,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    location: 'Жезказган',
  ),
  Alert(
    id: 'a4',
    title: 'Информация о температуре',
    description: 'Ожидается резкое понижение температуры до -20°C.',
    category: 'weather',
    severity: AlertSeverity.medium,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    location: 'Жезказган',
  ),
  Alert(
    id: 'a5',
    title: 'Перебой в подаче газа',
    description:
        'Плановое отключение газоснабжения в южной части города 27 ноября с 08:00 до 18:00.',
    category: 'utilities',
    severity: AlertSeverity.high,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    location: 'Южная часть',
  ),
  Alert(
    id: 'a6',
    title: 'Экстренное сообщение',
    description: 'Дорожно-транспортное происшествие на ул. Абая близ парка.',
    category: 'emergency',
    severity: AlertSeverity.critical,
    createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    location: 'ул. Абая',
  ),
];

final mockUserSessions = <UserSession>[
  UserSession(
    id: 's1',
    deviceName: 'iPhone 14 Pro',
    deviceType: 'phone',
    platform: 'iOS',
    ipAddress: '192.168.1.100',
    loginTime: DateTime.now().subtract(const Duration(hours: 2)),
    lastActivityTime: DateTime.now().subtract(const Duration(minutes: 5)),
    isCurrentSession: true,
  ),
  UserSession(
    id: 's2',
    deviceName: 'Samsung Galaxy A52',
    deviceType: 'phone',
    platform: 'Android',
    ipAddress: '192.168.1.101',
    loginTime: DateTime.now().subtract(const Duration(days: 1)),
    lastActivityTime: DateTime.now().subtract(const Duration(hours: 12)),
    isCurrentSession: false,
  ),
  UserSession(
    id: 's3',
    deviceName: 'MacBook Pro',
    deviceType: 'web',
    platform: 'Web',
    ipAddress: '192.168.1.102',
    loginTime: DateTime.now().subtract(const Duration(days: 5)),
    lastActivityTime: DateTime.now().subtract(const Duration(days: 4)),
    isCurrentSession: false,
  ),
];

final mockNotificationSettings = NotificationSettings(
  id: 'ns1',
  userId: 'u1',
  stormAlerts: true,
  weatherAlerts: true,
  transportAlerts: true,
  utilitiesAlerts: true,
  emergencyAlerts: true,
  emailNotifications: true,
  pushNotifications: true,
  smsNotifications: false,
  updatedAt: DateTime.now().subtract(const Duration(days: 7)),
);

final mockPlaces = <Place>[
  Place(
    id: 'a1',
    name: 'Международный аэропорт Жезказган',
    lat: 49.3233,
    lng: 67.7602,
    type: 'airport',
    description:
        'Главный аэропорт города с внутренними и международными рейсами.',
  ),
  Place(
    id: 's1',
    name: 'Центральный вокзал',
    lat: 49.2833,
    lng: 67.7167,
    type: 'station',
    description: 'Центр региональных и дальних поездов.',
  ),
];

final mockSchedule = <ScheduleItem>[
  ScheduleItem(
    id: 'sc1',
    placeId: 'a1',
    title: 'Рейс KC101 до Астаны',
    time: DateTime.now().add(const Duration(hours: 2)),
  ),
  ScheduleItem(
    id: 'sc2',
    placeId: 'a1',
    title: 'Рейс SU451 до Москвы',
    time: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
  ),
  ScheduleItem(
    id: 'sc3',
    placeId: 's1',
    title: 'Поезд 321 до Талгара',
    time: DateTime.now().add(const Duration(hours: 1, minutes: 15)),
  ),
  ScheduleItem(
    id: 'sc4',
    placeId: 's1',
    title: 'Поезд 452 до Шымкента',
    time: DateTime.now().add(const Duration(hours: 4, minutes: 45)),
  ),
  ScheduleItem(
    id: 'sc5',
    placeId: 's1',
    title: 'Поезд 789 до Астаны',
    time: DateTime.now().add(const Duration(hours: 6, minutes: 30)),
  ),
];
