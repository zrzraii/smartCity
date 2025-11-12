import '../models/post.dart';
import '../models/place.dart';
import '../models/schedule_item.dart';

final mockPosts = <Post>[
  Post(
    id: 'p1',
    title: 'City marathon announced',
    content:
        'Join the annual city marathon this weekend. Roads downtown will be partially closed.',
    date: DateTime.now(),
    imageUrl: 'https://picsum.photos/seed/marathon/800/400',
  ),
  Post(
    id: 'p2',
    title: 'New terminal opens',
    content:
        'The airport opened a new terminal with expanded services and shops.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl: 'https://picsum.photos/seed/terminal/800/400',
  ),
  Post(
    id: 'p3',
    title: 'Train schedule updated',
    content: 'Suburban train schedule updated for winter season.',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

final mockPlaces = <Place>[
  Place(
    id: 'a1',
    name: 'International Airport',
    lat: 43.354,
    lng: 76.894,
    type: 'airport',
    description:
        'Main airport of the city with domestic and international flights.',
  ),
  Place(
    id: 's1',
    name: 'Central Railway Station',
    lat: 43.261,
    lng: 76.919,
    type: 'station',
    description: 'Hub for regional and long-distance trains.',
  ),
];

final mockSchedule = <ScheduleItem>[
  ScheduleItem(
    id: 'sc1',
    placeId: 'a1',
    title: 'Flight KC101 to Astana',
    time: DateTime.now().add(const Duration(hours: 2)),
  ),
  ScheduleItem(
    id: 'sc2',
    placeId: 'a1',
    title: 'Flight SU451 to Moscow',
    time: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
  ),
  ScheduleItem(
    id: 'sc3',
    placeId: 's1',
    title: 'Train 321 to Talgar',
    time: DateTime.now().add(const Duration(hours: 1, minutes: 15)),
  ),
];
