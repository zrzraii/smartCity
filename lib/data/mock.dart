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
    author: 'Городские новости',
    readTimeMinutes: 3,
    content:
        'Присоединяйтесь к ежегодному марафону города на выходных. Дороги в центре города будут частично перекрыты. Маршрут проходит через центр и набережную. Участие бесплатное при предварительной регистрации.',
    date: DateTime.now(),
    imageUrl: 'https://picsum.photos/seed/marathon/800/400',
  ),
  Post(
    id: 'p2',
    title: 'Новые развлекательные объекты открыты',
    author: 'Культура Жезказгана',
    readTimeMinutes: 2,
    content:
        'В центре города открылись новые магазины и развлекательные центры с расширенным сервисом. В ближайшие выходные пройдут бесплатные концерты и мастер-классы для детей.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl: 'https://picsum.photos/seed/entertainment/800/400',
  ),
  Post(
    id: 'p3',
    title: 'Расписание общественного транспорта обновлено',
    author: 'Транспортный отдел',
    readTimeMinutes: 1,
    content: 'Расписание автобусов и троллейбусов обновлено на зимний сезон. Обратите внимание на изменения в утренние и вечерние интервалы.',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Post(
    id: 'p4',
    title: 'Информация о плановых отключениях электроэнергии',
    author: 'Коммунальные службы',
    readTimeMinutes: 1,
    content:
        'Плановое отключение электроэнергии в районе Центральной улицы с 09:00 до 15:00. Просим заранее позаботиться о зарядке устройств и запасе воды.',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    imageUrl: 'https://picsum.photos/seed/power/800/400',
  ),
  Post(
    id: 'p5',
    title: 'Ремонт дорог на улице Абая',
    author: 'Городские службы',
    readTimeMinutes: 2,
    content:
        'Начаты работы по ремонту и улучшению качества дорог. Возможны временные затруднения движения в центральной части. План работ опубликован на сайте города.',
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Post(
    id: 'p6',
    title: 'Мастер-классы по ремеслам в парке',
    author: 'Культура Жезказгана',
    readTimeMinutes: 2,
    content: 'В парке культуры пройдут мастер-классы по гончарному делу и резьбе по дереву. Вход свободный.',
    date: DateTime.now().subtract(const Duration(days: 8)),
    imageUrl: 'https://picsum.photos/seed/crafts/800/400',
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

final mockServices = [
  {
    'id': 'payments',
    'title': 'Платежи',
    'description': 'Оплата коммунальных услуг, штрафов и налогов',
    'items': [
      {
        'id': 'pay_electricity',
        'title': 'Оплата электроэнергии',
        'description': 'Оплата по лицевому счёту поставщика электроэнергии',
        'fields': ['Номер лицевого счёта', 'Сумма', 'Email для квитанции']
      },
      {
        'id': 'pay_water',
        'title': 'Оплата воды',
        'description': 'Оплата водоснабжения и канализации',
        'fields': ['Номер счета', 'Сумма']
      },
    ],
  },
  {
    'id': 'identification',
    'title': 'Идентификация и адреса',
    'description': 'Паспорт, удостоверения, регистрация адреса',
    'items': [
      {
        'id': 'id_passport',
        'title': 'Паспорт / Удостоверение',
        'description': 'Загрузите копии паспорта и удостоверений',
        'fields': ['Тип документа', 'Серия/номер', 'Дата выдачи']
      },
      {
        'id': 'id_address',
        'title': 'Регистрация по адресу',
        'description': 'Управление адресами проживания',
        'fields': ['Город', 'Улица', 'Дом, квартира']
      },
    ],
  },
  {
    'id': 'transport',
    'title': 'Транспорт',
    'description': 'Водительское удостоверение, регистрация ТС',
    'items': [
      {
        'id': 'driver_license',
        'title': 'Водительское удостоверение',
        'description': 'Заявления, замена и проверка статуса',
        'fields': ['Номер удостоверения', 'Категории', 'Дата выдачи']
      },
      {
        'id': 'vehicle_registration',
        'title': 'Регистрация транспорта',
        'description': 'Регистрация и сведения о ТС',
        'fields': ['VIN', 'Госномер', 'Марка/модель']
      },
    ],
  },
  {
    'id': 'family',
    'title': 'Семья',
    'description': 'Свидетельства о рождении, о браке',
    'items': [
      {
        'id': 'birth_cert',
        'title': 'Свидетельство о рождении',
        'description': 'Получение и восстановление свидетельства',
        'fields': ['ФИО ребёнка', 'Дата рождения', 'Место рождения']
      },
      {
        'id': 'marriage_cert',
        'title': 'Свидетельство о браке',
        'description': 'Регистрация брака и запрос копий',
        'fields': ['ФИО супругов', 'Дата регистрации']
      },
    ],
  },
  {
    'id': 'medicine',
    'title': 'Медицина',
    'description': 'Учет в поликлинике, записи и карты',
    'items': [
      {
        'id': 'medical_record',
        'title': 'Медкарта',
        'description': 'Доступ к электронной медицинской карте',
        'fields': ['Номер полиса', 'ФИО', 'Дата рождения']
      },
      {
        'id': 'appointments',
        'title': 'Запись к врачу',
        'description': 'Онлайн-запись на приём',
        'fields': ['Специализация', 'Дата/время']
      },
    ],
  },
  {
    'id': 'social',
    'title': 'Соцобеспечение',
    'description': 'Пособия, пенсии, инвалидность',
    'items': [
      {
        'id': 'pensions',
        'title': 'Пенсии и пособия',
        'description': 'Информация о выплатах и оформлениях',
        'fields': ['Тип помощи', 'Номер удостоверения']
      },
    ],
  },
  {
    'id': 'education',
    'title': 'Образование',
    'description': 'Дипломы, сертификаты, формы обучения',
    'items': [
      {
        'id': 'diplomas',
        'title': 'Дипломы и сертификаты',
        'description': 'Регистрация и проверка подлинности',
        'fields': ['Учебное заведение', 'Год выпуска']
      },
    ],
  },
  {
    'id': 'property',
    'title': 'Имущество',
    'description': 'Недвижимость, транспортные средства',
    'items': [
      {
        'id': 'real_estate',
        'title': 'Недвижимость',
        'description': 'Информация о собственности и сделках',
        'fields': ['Адрес', 'Кадастровый номер']
      },
    ],
  },
  {
    'id': 'employment',
    'title': 'Трудоустройство',
    'description': 'Трудовая книжка, отзывы, вакансии',
    'items': [
      {
        'id': 'work_record',
        'title': 'Трудовая книжка',
        'description': 'Просмотр записей и истории',
        'fields': ['Работодатель', 'Период']
      },
    ],
  },
  {
    'id': 'powers',
    'title': 'Доверенности',
    'description': 'Доверенности на транспорт и недвижимость',
    'items': [
      {
        'id': 'power_vehicle',
        'title': 'Доверенность на транспорт',
        'description': 'Оформление и проверка доверенностей',
        'fields': ['Номер Доверенности', 'Срок действия']
      },
    ],
  },
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

// Mock submissions / history (mutable for demo flows)
final mockSubmissions = <Map<String, dynamic>>[
  {
    'id': 'sub1',
    'serviceId': 'payments',
    'itemId': 'pay_electricity',
    'title': 'Оплата электроэнергии — лиц. счёт 12345678',
    'data': {
      'Номер лицевого счёта': '12345678',
      'Сумма': '4 560 ₸',
      'Email для квитанции': 'example@domain.kz',
      'Комментарий': 'Оплата по квитанции за октябрь',
    },
    'status': 'Завершено',
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
  },
  {
    'id': 'sub2',
    'serviceId': 'payments',
    'itemId': 'pay_water',
    'title': 'Оплата воды — счёт 87654321',
    'data': {
      'Номер счета': '87654321',
      'Сумма': '2 240 ₸',
      'Комментарий': 'Оплата воды за сентябрь',
    },
    'status': 'В обработке',
    'createdAt': DateTime.now().subtract(const Duration(hours: 4)),
  },
  {
    'id': 'sub3',
    'serviceId': 'identification',
    'itemId': 'id_passport',
    'title': 'Замена паспорта — Иванов И.И.',
    'data': {
      'Тип документа': 'Паспорт',
      'Серия/номер': 'AB1234567',
      'Дата выдачи': '01.01.2015',
    },
    'status': 'Отменено',
    'createdAt': DateTime.now().subtract(const Duration(days: 7)),
  },
];
