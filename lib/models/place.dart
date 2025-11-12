class Place {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String type; // 'airport' or 'station'
  final String description;

  Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.type,
    required this.description,
  });
}
