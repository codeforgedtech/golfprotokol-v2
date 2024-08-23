import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import '../services/data_service.dart';
import 'select_player_screen.dart';
import 'total_statistics_screen.dart';
import 'tip_course_screen.dart';
import 'about_screen.dart'; // Import the About screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Course> _courses = [];
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();
  List<String> _alphabet = [];

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
      _alphabet = _generateAlphabet(courses);
    });
  }

  List<String> _generateAlphabet(List<Course> courses) {
    Set<String> letters = {};
    for (var course in courses) {
      if (course.name.isNotEmpty) {
        letters.add(course.name[0].toUpperCase());
      }
    }
    List<String> sortedLetters = letters.toList()..sort();
    return sortedLetters;
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

  void _navigateToTipCourseScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TipCourseScreen(),
      ),
    );
  }

  void _navigateToAboutScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutScreen(), // Navigate to the About screen
      ),
    );
  }

  void _scrollToLetter(String letter) {
    for (int i = 0; i < _courses.length; i++) {
      if (_courses[i].name.isNotEmpty &&
          _courses[i].name[0].toUpperCase() == letter) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent +
              i * 80.0, // Adjust multiplier based on item height
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
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
            icon: Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: _navigateToTipCourseScreen,
            tooltip: 'Tipsa om ny bana',
          ),
          IconButton(
            icon: Icon(Icons.stacked_bar_chart, color: Colors.white),
            onPressed: _navigateToTotalStatistics,
            tooltip: 'Total Statistik',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Courses List
          Padding(
            padding: const EdgeInsets.only(
                left: 60.0), // Make room for the alphabet list
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
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
          // Alphabet List
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50.0, // Width of the alphabet list
              color: Colors.grey[200],
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _alphabet.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _alphabet[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _scrollToLetter(_alphabet[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAboutScreen,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'Om Bangolf Protokoll',
        child: Icon(Icons.question_mark_outlined),
      ),
    );
  }
}
