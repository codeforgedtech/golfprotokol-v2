import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/statistics.dart';

class DataService {
  Future<List<Course>> loadCourses() async {
    // Load the JSON file from the assets
    final String response =
        await rootBundle.loadString('assets/golfcourses.json');
    // Decode the JSON data
    final data = json.decode(response);
    // Convert the JSON list to a list of Course objects
    return (data as List).map((json) => Course.fromJson(json)).toList();
  }

  Future<void> saveStatistics(Statistics statistics) async {
    final prefs = await SharedPreferences.getInstance();
    String statisticsKey = '${statistics.courseId}_${statistics.playerName}';
    String statisticsJson = json.encode(statistics.toJson());
    await prefs.setString(statisticsKey, statisticsJson);
  }

  Future<List<Statistics>> getAllStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<Statistics> statisticsList = [];

    for (String key in keys) {
      if (key.contains('_')) {
        // assuming your keys are in the format 'courseId_playerName'
        String? statisticsJson = prefs.getString(key);
        if (statisticsJson != null) {
          Map<String, dynamic> jsonMap = json.decode(statisticsJson);
          Statistics statistics = Statistics.fromJson(jsonMap);
          statisticsList.add(statistics);
        }
      }
    }
    return statisticsList;
  }

  // Load courses and cache them
  Future<Map<String, String>> loadCoursesMap() async {
    List<Course> courses = await loadCourses();
    return {for (var course in courses) course.id: course.name};
  }
}
