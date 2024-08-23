import 'package:flutter/material.dart';
import '../models/statistics.dart';
import '../services/data_service.dart';

class TotalStatisticsScreen extends StatefulWidget {
  @override
  _TotalStatisticsScreenState createState() => _TotalStatisticsScreenState();
}

class _TotalStatisticsScreenState extends State<TotalStatisticsScreen> {
  Map<String, List<Statistics>> _playerStatsMap = {};
  Map<String, String> _courseNames = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    DataService dataService = DataService();
    List<Statistics> allStats = await dataService.getAllStatistics();
    Map<String, String> courseNames = await dataService.loadCoursesMap();

    // Grouping statistics by player
    Map<String, List<Statistics>> playerStatsMap = {};
    for (var stats in allStats) {
      if (playerStatsMap.containsKey(stats.playerName)) {
        playerStatsMap[stats.playerName]!.add(stats);
      } else {
        playerStatsMap[stats.playerName] = [stats];
      }
    }

    setState(() {
      _playerStatsMap = playerStatsMap;
      _courseNames = courseNames;
      _isLoading = false;
    });
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
            length: _playerStatsMap.keys.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Total Statistik'),
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: _playerStatsMap.keys.map((playerName) {
                    return Tab(text: playerName);
                  }).toList(), // Convert iterable to list
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3.0,
                ),
              ),
              body: TabBarView(
                children: _playerStatsMap.keys.map((playerName) {
                  final playerStats = _playerStatsMap[playerName]!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: playerStats.length,
                    itemBuilder: (context, index) {
                      final statistics = playerStats[index];
                      final courseName =
                          _courseNames[statistics.courseId] ?? 'Unknown Course';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(statistics.rounds.length,
                            (roundIndex) {
                          final round = statistics.rounds[roundIndex];
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                '$courseName - Runda ${roundIndex + 1}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Antal slag: ${round.totalStrokes}\nDiff från par: ${round.differenceFromPar >= 0 ? '+' : ''}${round.differenceFromPar}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: round.differenceFromPar >= 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  );
                }).toList(), // Convert iterable to list
              ),
            ),
          );
  }
}
