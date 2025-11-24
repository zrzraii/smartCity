class UserSession {
  final String id;
  final String deviceName;
  final String deviceType; // 'phone', 'tablet', 'web'
  final String platform; // 'iOS', 'Android', 'Web'
  final String ipAddress;
  final DateTime loginTime;
  final DateTime? lastActivityTime;
  final bool isCurrentSession;

  UserSession({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.platform,
    required this.ipAddress,
    required this.loginTime,
    this.lastActivityTime,
    required this.isCurrentSession,
  });
}
