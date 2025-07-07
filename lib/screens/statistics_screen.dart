import 'package:flutter/material.dart';
import '../models/statistics.dart';
import '../models/round_stats.dart';
import '../models/course.dart';
import '../services/data_service.dart';
import 'NewRoundSetupScreen.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Statistics> statisticsList;

  const StatisticsScreen({required this.statisticsList, Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DataService _dataService = DataService();

  Future<void> _startNewRound(String player, String courseId) async {
    final course = await _dataService.getCourseById(courseId);
    if (course == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Banan kunde inte hittas.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StartNewRoundScreen(course: course, playerName: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.statisticsList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistik'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            tabs: widget.statisticsList
                .map((s) => Tab(text: s.playerName))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: widget.statisticsList.map((stats) {
            // gruppera ronder per omgång (courseId + datum)
            final grouped = <String, List<RoundStats>>{};
            for (var r in stats.rounds) {
              final key =
                  '${r.courseId}_${r.date.toIso8601String().split('T').first}';
              grouped.putIfAbsent(key, () => []).add(r);
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bana + knapp för ny omgång
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${stats.courseName} (${stats.holesCount} hål)',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                        ),
                        onPressed: () => _startNewRound(
                            stats.playerName, stats.courseId),
                        child: Text('Ny omgång'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Omgångar',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800])),
                                const SizedBox(height: 12),
                                ...grouped.entries.map((e) {
                                  final rounds = e.value;
                                  final date = rounds.first.date
                                      .toLocal()
                                      .toIso8601String()
                                      .split('T')
                                      .first;
                                  final totStrokes = rounds
                                      .fold(0, (s, r) => s + r.totalStrokes);
                                  final totDiff = rounds
                                      .fold(0, (s, r) => s + r.differenceFromPar);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$date • ${rounds.length} varv',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Totalpoäng: $totStrokes'),
                                        Text(
                                          'Diff mot par: ${totDiff >= 0 ? '+' : ''}$totDiff',
                                          style: TextStyle(
                                              color: totDiff >= 0
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                        const SizedBox(height: 4),
                                        ...rounds.asMap().entries.map((idx) {
                                          final r = idx.value;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, top: 2, bottom: 2),
                                            child: Text(
                                              '• Varv ${idx.key + 1}: ${r.totalStrokes} slag '
                                              '(${r.differenceFromPar >= 0 ? '+' : ''}${r.differenceFromPar})',
                                              style: TextStyle(
                                                  color: r.differenceFromPar >= 0
                                                      ? Colors.red
                                                      : Colors.green),
                                            ),
                                          );
                                        }).toList(),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}





