import 'package:shared_preferences/shared_preferences.dart';
import '../models/statistics.dart';
import 'dart:convert';

class LocalStorage {
  static Future<void> saveStatistics(Statistics stats) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonStats = json.encode(stats.toJson());
    prefs.setString(stats.courseId, jsonStats);
  }

  static Future<Statistics?> getStatistics(String courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonStats = prefs.getString(courseId);
    if (jsonStats != null) {
      return Statistics.fromJson(json.decode(jsonStats));
    }
    return null;
  }

  static Future<void> clearStatistics(String courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(courseId);
  }
}
