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
  List<Course> _allCourses = []; // Stores the full list of courses
  List<Course> _filteredCourses = []; // Stores the filtered list of courses
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();
  List<String> _alphabet = [];
  String? _selectedLetter; // State variable to store the selected letter

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() async {
    DataService dataService = DataService();
    List<Course> courses = await dataService.loadCourses();
    setState(() {
      _allCourses = courses;
      _filteredCourses = courses;
      _isLoading = false;
      _alphabet = _generateAlphabet(courses);
      _alphabet.sort(); // Ensure alphabetical order
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

  void _filterCourses(String? letter) {
    setState(() {
      if (letter == null || letter == 'All') {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses
            .where((course) =>
                course.name.isNotEmpty &&
                course.name[0].toUpperCase() == letter)
            .toList();
      }
    });

    // Scroll to the top of the filtered list
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onLetterSelected(String letter) {
    _selectedLetter = letter;
    _filterCourses(letter);
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
                left: 70.0,
                top: 60.0), // Adjusted padding to move the list down
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: CourseCard(
                          course: _filteredCourses[index],
                          onTap: () => _onCourseTap(_filteredCourses[index]),
                        ),
                      );
                    },
                  ),
          ),
          // Horizontal "All" Button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40.0, // Height of the horizontal list
              color: Colors.grey[200],
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  _buildAlphabetButton('All'),
                ],
              ),
            ),
          ),
          // Vertical Alphabet List
          Positioned(
            left: 0,
            top: 40.0, // Start below the horizontal "All" button
            bottom: 0,
            child: Container(
              width: 50.0, // Width of the vertical list
              color: Colors.grey[200],
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _alphabet.length,
                itemBuilder: (context, index) {
                  return _buildAlphabetButton(_alphabet[index]);
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

  Widget _buildAlphabetButton(String letter) {
    return GestureDetector(
      onTap: () => _onLetterSelected(letter),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: _selectedLetter == letter
              ? Colors.transparent
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontSize:
                letter == 'All' ? 12.0 : 14.0, // Larger font size for "All"
            fontWeight: FontWeight.bold,
            color: _selectedLetter == letter ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }
}
