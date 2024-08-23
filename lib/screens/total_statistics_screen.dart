import 'package:flutter/material.dart';
import '../models/statistics.dart';
import '../services/data_service.dart';

class TotalStatisticsScreen extends StatefulWidget {
  @override
  _TotalStatisticsScreenState createState() => _TotalStatisticsScreenState();
}

class _TotalStatisticsScreenState extends State<TotalStatisticsScreen> {
  List<Statistics> _statisticsList = [];
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

    setState(() {
      _statisticsList = allStats;
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
            length: _statisticsList.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Total Statistik'),
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: _statisticsList.map((statistics) {
                    return Tab(text: statistics.playerName);
                  }).toList(),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3.0,
                ),
              ),
              body: TabBarView(
                children: _statisticsList.map((statistics) {
                  final courseName =
                      _courseNames[statistics.courseId] ?? 'Unknown Course';
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: statistics.rounds.length,
                      itemBuilder: (context, index) {
                        final round = statistics.rounds[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(
                              '$courseName - Runda ${index + 1}',
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
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          );
  }
}
