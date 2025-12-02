import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/mock.dart';
import '../models/notification_settings.dart';

class AppState extends ChangeNotifier {
  static const _keyLocale = 'locale';
  static const _keySavedPosts = 'saved_posts';
  static const _keySavedPlaces = 'saved_places';
  static const _keySavedSchedules = 'saved_schedules';
  static const _keyAppPassword = 'app_password';
  static const _keySubmissions = 'submissions_json';

  Locale? _locale;
  Set<String> _savedPostIds = {};
  Set<String> _savedPlaceIds = {};
  Set<String> _savedScheduleIds = {};
  String? _appPassword;
  late NotificationSettings _notificationSettings;

  Locale? get locale => _locale;
  Set<String> get savedPostIds => _savedPostIds;
  Set<String> get savedPlaceIds => _savedPlaceIds;
  Set<String> get savedScheduleIds => _savedScheduleIds;
  String? get appPassword => _appPassword;
  NotificationSettings get notificationSettings => _notificationSettings;
  List<Map<String, dynamic>> _submissions = [];
  List<Map<String, dynamic>> get submissions => List.unmodifiable(_submissions);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    _savedPostIds = prefs.getStringList(_keySavedPosts)?.toSet() ?? {};
    _savedPlaceIds = prefs.getStringList(_keySavedPlaces)?.toSet() ?? {};
    _savedScheduleIds = prefs.getStringList(_keySavedSchedules)?.toSet() ?? {};
    _appPassword = prefs.getString(_keyAppPassword);
    // load submissions
    final subsJson = prefs.getString(_keySubmissions);
    if (subsJson != null && subsJson.isNotEmpty) {
      try {
        final list = jsonDecode(subsJson) as List<dynamic>;
        _submissions = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {
        _submissions = List.from(mockSubmissions);
      }
    } else {
      _submissions = List.from(mockSubmissions);
    }
    notifyListeners();
  }

  Future<void> _saveSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySubmissions, jsonEncode(_submissions));
  }

  Future<void> addSubmission(Map<String, dynamic> s) async {
    _submissions.insert(0, s);
    await _saveSubmissions();
    notifyListeners();
  }

  Future<void> updateSubmission(String id, Map<String, dynamic> data) async {
    final idx = _submissions.indexWhere((e) => e['id'] == id);
    if (idx != -1) {
      _submissions[idx] = {..._submissions[idx], ...data};
      await _saveSubmissions();
      notifyListeners();
    }
  }

  Future<void> removeSubmission(String id) async {
    _submissions.removeWhere((e) => e['id'] == id);
    await _saveSubmissions();
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_keyLocale);
    } else {
      await prefs.setString(_keyLocale, locale.languageCode);
    }
    notifyListeners();
  }

  Future<void> toggleSavedPost(String id) async {
    if (_savedPostIds.contains(id)) {
      _savedPostIds.remove(id);
    } else {
      _savedPostIds.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySavedPosts, _savedPostIds.toList());
    notifyListeners();
  }

  Future<void> toggleSavedPlace(String id) async {
    if (_savedPlaceIds.contains(id)) {
      _savedPlaceIds.remove(id);
    } else {
      _savedPlaceIds.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySavedPlaces, _savedPlaceIds.toList());
    notifyListeners();
  }

  Future<void> toggleSavedSchedule(String id) async {
    if (_savedScheduleIds.contains(id)) {
      _savedScheduleIds.remove(id);
    } else {
      _savedScheduleIds.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySavedSchedules, _savedScheduleIds.toList());
    notifyListeners();
  }

  Future<void> setAppPassword(String password) async {
    _appPassword = password;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppPassword, password);
    notifyListeners();
  }

  Future<void> setNotificationSettings(NotificationSettings settings) async {
    _notificationSettings = settings;
    notifyListeners();
  }

  Future<bool> verifyAppPassword(String password) async {
    if (_appPassword == null) return true;
    return _appPassword == password;
  }
}
