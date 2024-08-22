import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import '../services/data_service.dart';
import 'select_player_screen.dart';
import 'total_statistics_screen.dart'; // Import the new screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() async {
    DataService dataService = DataService();
    List<Course> courses = await dataService.loadCourses();
    setState(() {
      _courses = courses;
      _isLoading = false;
    });
  }

  void _onCourseTap(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectPlayerScreen(course: course),
      ),
    );
  }

  void _navigateToTotalStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TotalStatisticsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bangolf Protokoll'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green, // Match the color with the theme
        actions: [
          IconButton(
            icon: Icon(Icons.stacked_bar_chart, color: Colors.white),
            onPressed: _navigateToTotalStatistics,
            tooltip: 'Total Statistik',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: CourseCard(
                      course: _courses[index],
                      onTap: () => _onCourseTap(_courses[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}