import 'package:flutter/material.dart';
import 'package:golf_app/models/round_stats.dart';
import 'package:golf_app/screens/NewRoundSetupScreen.dart';
import '../models/statistics.dart';
import '../services/data_service.dart';

class TotalStatisticsScreen extends StatefulWidget {
  @override
  _TotalStatisticsScreenState createState() => _TotalStatisticsScreenState();
}

class _TotalStatisticsScreenState extends State<TotalStatisticsScreen> {
  Map<String, Map<String, List<Statistics>>> _playerCourseStatsMap = {};
  Map<String, String> _courseNames = {};
  bool _isLoading = true;
  Map<String, String?> _selectedCoursePerPlayer = {};
  DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    List<Statistics> allStats = await _dataService.getAllStatistics();
    Map<String, String> courseNames = await _dataService.loadCoursesMap();

    Map<String, Map<String, List<Statistics>>> playerCourseStatsMap = {};

    for (var stats in allStats) {
      final player = stats.playerName;
      final course = stats.courseId;

      playerCourseStatsMap.putIfAbsent(player, () => {});
      playerCourseStatsMap[player]!.putIfAbsent(course, () => []);
      playerCourseStatsMap[player]![course]!.add(stats);
    }

    setState(() {
      _playerCourseStatsMap = playerCourseStatsMap;
      _courseNames = courseNames;
      _isLoading = false;

      for (var player in _playerCourseStatsMap.keys) {
        _selectedCoursePerPlayer[player] = _playerCourseStatsMap[player]!.keys.first;
      }
    });
  }

  Future<void> _startNewRound(String playerName, String courseId) async {
    setState(() {
      _isLoading = true;
    });

    final course = await _dataService.getCourseById(courseId);

    setState(() {
      _isLoading = false;
    });

    if (course == null) {
      // Hantera fel vid kurshämtning om så önskas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kunde inte hitta banan för ny omgång.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartNewRoundScreen(
          course: course,
          playerName: playerName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text('Total Statistik'),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            body: Center(child: CircularProgressIndicator()),
          )
        : DefaultTabController(
            length: _playerCourseStatsMap.keys.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Total Statistik'),
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: _playerCourseStatsMap.keys.map((playerName) {
                    return Tab(text: playerName);
                  }).toList(),
                ),
              ),
              body: TabBarView(
                children: _playerCourseStatsMap.keys.map((playerName) {
                  final courses = _playerCourseStatsMap[playerName]!;
                  String? selectedCourse = _selectedCoursePerPlayer[playerName];

                  return Column(
                    children: [
                      // Dropdown och knapp för ny omgång
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedCourse,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
                                    items: courses.keys.map((courseId) {
                                      final courseName = _courseNames[courseId] ?? 'Unknown Course';
                                      return DropdownMenuItem<String>(
                                        value: courseId,
                                        child: Text(courseName, style: TextStyle(fontSize: 16)),
                                      );
                                    }).toList(),
                                    onChanged: (newCourseId) {
                                      setState(() {
                                        _selectedCoursePerPlayer[playerName] = newCourseId;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              onPressed: selectedCourse == null
                                  ? null
                                  : () => _startNewRound(playerName, selectedCourse),
                              child: Text(
                                'Starta ny omgång',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Visa kort för varje omgång i vald bana
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: selectedCourse == null ? 0 : courses[selectedCourse]!.length,
                          itemBuilder: (context, index) {
                            final stats = courses[selectedCourse]![index];
                            final courseName = stats.courseName; // Använder kursnamn från stats

                            int totalStrokes =
                                stats.rounds.fold(0, (sum, r) => sum + r.totalStrokes);
                            int totalDiff = stats.rounds.fold(0, (sum, r) => sum + r.differenceFromPar);

                            String formattedDate = stats.date.toLocal().toString().split(' ')[0];

                            return Card(
                              elevation: 4.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16.0),
                                title: Text(
                                  '$courseName (${stats.holesCount} hål) - $formattedDate',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Antal varv: ${stats.rounds.length}'),
                                    Text('Totalt antal slag: $totalStrokes'),
                                    Text(
                                      'Total diff från par: ${totalDiff >= 0 ? '+' : ''}$totalDiff',
                                      style: TextStyle(
                                        color: totalDiff >= 0 ? Colors.red : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...stats.rounds.asMap().entries.map((entry) {
                                      int roundIndex = entry.key;
                                      var round = entry.value;
                                      return Text(
                                        'Varv ${roundIndex + 1} av ${stats.rounds.length} - Slag: ${round.totalStrokes}, Diff: ${round.differenceFromPar >= 0 ? '+' : ''}${round.differenceFromPar}',
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
  }
}










