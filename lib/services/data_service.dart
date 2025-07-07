import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../models/statistics.dart';

class DataService {
  Future<List<Course>> loadCourses() async {
    final String response = await rootBundle.loadString('assets/golfcourses.json');
    final data = json.decode(response);
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

  Future<Map<String, String>> loadCoursesMap() async {
    List<Course> courses = await loadCourses();
    return {for (var course in courses) course.id: course.name};
  }

  Future<void> submitCourseTip(String courseName, String location) async {
    final url = 'https://formspree.io/f/mqazgped';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {
        'courseName': courseName,
        'location': location,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit course tip');
    }

    final prefs = await SharedPreferences.getInstance();
    final tipKey = 'course_tip_${DateTime.now().millisecondsSinceEpoch}';
    final tipData = {
      'courseName': courseName,
      'location': location,
    };
    String tipJson = json.encode(tipData);
    await prefs.setString(tipKey, tipJson);
  }

  Future<List<Map<String, dynamic>>> getAllCourseTips() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<Map<String, dynamic>> courseTips = [];

    for (String key in keys) {
      if (key.startsWith('course_tip_')) {
        String? tipJson = prefs.getString(key);
        if (tipJson != null) {
          Map<String, dynamic> tipMap = json.decode(tipJson);
          courseTips.add(tipMap);
        }
      }
    }
    return courseTips;
  }

  /// ✅ IMPLEMENTERAD: Hämta kurs med ID
  Future<Course?> getCourseById(String courseId) async {
    List<Course> courses = await loadCourses();
    try {
      return courses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  /// ✅ IMPLEMENTERAD: Hämta kurs med namn
  Future<Course?> getCourseByName(String courseName) async {
    List<Course> courses = await loadCourses();
    try {
      return courses.firstWhere((course) => course.name == courseName);
    } catch (e) {
      return null;
    }
  }
}

