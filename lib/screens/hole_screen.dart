import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/statistics.dart';
import '../models/course.dart';
import 'statistics_screen.dart';

class HoleScreen extends StatefulWidget {
  final Course course;
  final List<String> playerNames;
  final int roundCount;

  HoleScreen({
    required this.course,
    required this.playerNames,
    required this.roundCount,
  });

  @override
  _HoleScreenState createState() => _HoleScreenState();
}

class _HoleScreenState extends State<HoleScreen> {
  int _currentRound = 1;
  late List<String> _playerOrder;
  Map<String, List<List<int?>>> _selectedScores = {};
  List<Statistics> _statisticsList = [];
  late DateTime _roundStartTime;

  @override
  void initState() {
    super.initState();
    _playerOrder = List.from(widget.playerNames);
    _roundStartTime = DateTime.now();

    for (var player in _playerOrder) {
      _selectedScores[player] = List.generate(
        widget.roundCount,
        (_) => List.generate(widget.course.holes.length, (_) => null),
      );
    }

    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    await SharedPreferences.getInstance();
    for (String playerName in widget.playerNames) {
      // Här laddar vi inte längre en specifik omgång, utan en tom lista för att lägga till i _statisticsList
      _statisticsList.add(Statistics(
        courseId: widget.course.id,
        courseName: widget.course.name,
        holesCount: widget.course.holes.length,
        playerName: playerName,
        rounds: [],
        date: _roundStartTime,
      ));
    }
  }

  Future<void> _saveRound() async {
    bool allFilled = _playerOrder.every((player) =>
        _selectedScores[player]![_currentRound - 1].every((score) => score != null));

    if (!allFilled) {
      _showIncompleteRoundAlert();
      return;
    }

    if (_currentRound == widget.roundCount) {
      await _saveStatistics();
    } else {
      setState(() {
        _currentRound++;
        if (widget.roundCount == 3 && _currentRound == 3) {
          _sortPlayersByScoreAfterTwoRounds();
          _showSnackbar('Varv 3 spelas i Ludvika. Turordning ändrad.');
        }
      });
    }
  }

  Future<void> _saveStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < _playerOrder.length; i++) {
      final player = _playerOrder[i];
      final allRounds = _selectedScores[player]!
          .map((round) => round.map((s) => s ?? 0).toList())
          .toList();

      for (var roundScores in allRounds) {
        _statisticsList[i].addRound(roundScores, widget.course.par);
      }

      String statisticsJson = jsonEncode(_statisticsList[i].toJson());

      // Nyckel inkluderar starttid för att spara unikt per omgång
      String key = '${widget.course.id}_${player}_${_roundStartTime.toIso8601String()}';

      await prefs.setString(key, statisticsJson);
    }

    _navigateToStatistics();
  }

  void _navigateToStatistics() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(statisticsList: _statisticsList),
      ),
    );
  }

  void _sortPlayersByScoreAfterTwoRounds() {
    Map<String, int> totalScores = {};
    for (var player in _playerOrder) {
      final round1 = _selectedScores[player]![0].map((s) => s ?? 0);
      final round2 = _selectedScores[player]![1].map((s) => s ?? 0);
      totalScores[player] = round1.reduce((a, b) => a + b) + round2.reduce((a, b) => a + b);
    }
    _playerOrder.sort((a, b) => totalScores[a]!.compareTo(totalScores[b]!));
  }

  void _showIncompleteRoundAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ofullständig runda'),
        content: Text('Fyll i alla poäng innan du fortsätter.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentRound == 3 && widget.roundCount == 3
            ? 'Varv $_currentRound: Ludvika'
            : 'Varv $_currentRound: ${widget.course.name}'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
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
                          color: Colors.green),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: _playerOrder.map((player) {
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: player,
                                border: OutlineInputBorder(),
                              ),
                              isEmpty:
                                  _selectedScores[player]![_currentRound - 1]
                                          [holeIndex] ==
                                      null,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedScores[player]![_currentRound - 1]
                                      [holeIndex],
                                  isExpanded: true,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _selectedScores[player]![_currentRound - 1]
                                          [holeIndex] = newValue;
                                    });
                                  },
                                  items: List.generate(
                                      7,
                                      (i) => DropdownMenuItem(
                                          value: i + 1,
                                          child: Center(
                                              child:
                                                  Text('${i + 1}')))),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveRound,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.navigate_next),
        tooltip: _currentRound == widget.roundCount
            ? 'Spara Statistik'
            : 'Nästa Varv',
      ),
    );
  }
}


