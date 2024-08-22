import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/statistics.dart';
import '../models/course.dart';
import 'statistics_screen.dart';

class HoleScreen extends StatefulWidget {
  final Course course;
  final List<String> playerNames;

  HoleScreen({required this.course, required this.playerNames});

  @override
  _HoleScreenState createState() => _HoleScreenState();
}

class _HoleScreenState extends State<HoleScreen> {
  List<List<int?>> _selectedScores = [];
  List<Statistics> _statisticsList = [];

  @override
  void initState() {
    super.initState();
    _selectedScores = List.generate(
      widget.playerNames.length,
      (index) => List.generate(
        widget.course.holes.length,
        (holeIndex) => null,
      ),
    );
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String playerName in widget.playerNames) {
      String? statisticsJson =
          prefs.getString('${widget.course.id}_$playerName');
      if (statisticsJson != null) {
        Statistics statistics = Statistics.fromJson(jsonDecode(statisticsJson));
        _statisticsList.add(statistics);
      } else {
        _statisticsList.add(Statistics(
          courseId: widget.course.id,
          playerName: playerName,
          rounds: [],
        ));
      }
    }
  }

  Future<void> _saveStatistics() async {
    bool allFieldsFilled = _selectedScores.every(
      (playerScores) => playerScores.every((score) => score != null),
    );

    if (!allFieldsFilled) {
      _showIncompleteRoundAlert();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int playerIndex = 0;
        playerIndex < widget.playerNames.length;
        playerIndex++) {
      List<int> scores =
          _selectedScores[playerIndex].map((score) => score ?? 0).toList();
      int par = widget.course.par;

      _statisticsList[playerIndex].addRound(scores, par);

      String statisticsJson = jsonEncode(_statisticsList[playerIndex].toJson());
      prefs.setString('${widget.course.id}_${widget.playerNames[playerIndex]}',
          statisticsJson);

      print('Saving stats for ${widget.playerNames[playerIndex]}: $scores');
    }

    _navigateToStatistics();
  }

  void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(statisticsList: _statisticsList),
      ),
    );
  }

  void _showIncompleteRoundAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ofullständig runda'),
          content: Text('Vänligen fyll i alla poäng innan du sparar.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course.name}'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green, // Match the color with the theme
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart), // Icon for statistics
            onPressed: _navigateToStatistics,
            tooltip: 'Visa Statistik',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.course.holes.length,
          itemBuilder: (context, holeIndex) {
            final hole = widget.course.holes[holeIndex];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hål ${hole.number}: ${hole.name}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        widget.playerNames.length,
                        (playerIndex) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: widget.playerNames[playerIndex],
                                border: OutlineInputBorder(),
                              ),
                              isEmpty: _selectedScores[playerIndex]
                                      [holeIndex] ==
                                  null,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedScores[playerIndex]
                                      [holeIndex],
                                  isExpanded: true,
                                  hint: Text(''),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _selectedScores[playerIndex][holeIndex] =
                                          newValue;
                                    });
                                  },
                                  items: List.generate(
                                    7,
                                    (index) => DropdownMenuItem<int>(
                                      value: index + 1,
                                      child:
                                          Center(child: Text('${index + 1}')),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveStatistics,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.save),
        tooltip: 'Spara Statistik',
      ),
    );
  }
}
