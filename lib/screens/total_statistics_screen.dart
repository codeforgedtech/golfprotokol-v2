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
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Statistik'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _statisticsList.length,
              separatorBuilder: (context, index) => Divider(thickness: 1),
              itemBuilder: (context, index) {
                final statistics = _statisticsList[index];
                final courseName =
                    _courseNames[statistics.courseId] ?? 'Unknown Course';
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseName, // Use course name
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ...statistics.rounds.map((round) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              '${statistics.playerName}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Antal slag: ${round.totalStrokes}\nDiff från par: ${round.differenceFromPar >= 0 ? '+' : ''}${round.differenceFromPar}',
                              style: TextStyle(
                                color: round.differenceFromPar >= 0
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
