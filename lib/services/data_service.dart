import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
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

  // Submit a new course tip and send it to Formspree
  Future<void> submitCourseTip(String courseName, String location) async {
    final url =
        'https://formspree.io/f/mqazgped'; // Replace with your Formspree form ID
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

    // Optionally save locally as well
    final prefs = await SharedPreferences.getInstance();
    final tipKey = 'course_tip_${DateTime.now().millisecondsSinceEpoch}';
    final tipData = {
      'courseName': courseName,
      'location': location,
    };
    String tipJson = json.encode(tipData);
    await prefs.setString(tipKey, tipJson);
  }

  // Retrieve all course tips
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
}
