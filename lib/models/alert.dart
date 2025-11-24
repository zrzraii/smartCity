class Alert {
  final String id;
  final String title;
  final String description;
  final String category; // 'storm', 'weather', 'transport', 'utilities', 'emergency'
  final AlertSeverity severity; // critical, high, medium, low
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? location;
  final bool read;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.createdAt,
    this.expiresAt,
    this.location,
    this.read = false,
  });

  Alert copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    AlertSeverity? severity,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? location,
    bool? read,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      location: location ?? this.location,
      read: read ?? this.read,
    );
  }
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low,
}
