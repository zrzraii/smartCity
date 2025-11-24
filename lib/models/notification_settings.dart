class NotificationSettings {
  final String id;
  final String userId;
  final bool stormAlerts;
  final bool weatherAlerts;
  final bool transportAlerts;
  final bool utilitiesAlerts;
  final bool emergencyAlerts;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final DateTime updatedAt;

  NotificationSettings({
    required this.id,
    required this.userId,
    required this.stormAlerts,
    required this.weatherAlerts,
    required this.transportAlerts,
    required this.utilitiesAlerts,
    required this.emergencyAlerts,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.updatedAt,
  });

  NotificationSettings copyWith({
    String? id,
    String? userId,
    bool? stormAlerts,
    bool? weatherAlerts,
    bool? transportAlerts,
    bool? utilitiesAlerts,
    bool? emergencyAlerts,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stormAlerts: stormAlerts ?? this.stormAlerts,
      weatherAlerts: weatherAlerts ?? this.weatherAlerts,
      transportAlerts: transportAlerts ?? this.transportAlerts,
      utilitiesAlerts: utilitiesAlerts ?? this.utilitiesAlerts,
      emergencyAlerts: emergencyAlerts ?? this.emergencyAlerts,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
