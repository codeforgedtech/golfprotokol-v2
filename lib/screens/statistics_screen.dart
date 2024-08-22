import 'package:flutter/material.dart';
import '../models/statistics.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Statistics> statisticsList;

  StatisticsScreen({required this.statisticsList});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: statisticsList.length,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Statistik'),
          bottom: TabBar(
            isScrollable: true,
            tabs: statisticsList.map((statistics) {
              return Tab(text: statistics.playerName);
            }).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: statisticsList.map((statistics) {
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
                        '${statistics.playerName} - Runda ${index + 1}',
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
