import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const _keyLocale = 'locale';
  static const _keySavedPosts = 'saved_posts';
  static const _keySavedPlaces = 'saved_places';
  static const _keySavedSchedules = 'saved_schedules';

  Locale? _locale;
  Set<String> _savedPostIds = {};
  Set<String> _savedPlaceIds = {};
  Set<String> _savedScheduleIds = {};

  Locale? get locale => _locale;
  Set<String> get savedPostIds => _savedPostIds;
  Set<String> get savedPlaceIds => _savedPlaceIds;
  Set<String> get savedScheduleIds => _savedScheduleIds;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    _savedPostIds = prefs.getStringList(_keySavedPosts)?.toSet() ?? {};
    _savedPlaceIds = prefs.getStringList(_keySavedPlaces)?.toSet() ?? {};
    _savedScheduleIds = prefs.getStringList(_keySavedSchedules)?.toSet() ?? {};
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
}
