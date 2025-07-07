import 'package:json_annotation/json_annotation.dart';
import 'round_stats.dart';

part 'statistics.g.dart';

@JsonSerializable()
class Statistics {
  final String courseId;
  final String courseName; // NYTT
  final int holesCount;   // NYTT
  final String playerName;
  final DateTime date;
  List<RoundStats> rounds;

  Statistics({
    required this.courseId,
    required this.courseName,
    required this.holesCount,
    required this.playerName,
    required this.date,
    required this.rounds,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsToJson(this);

  void addRound(List<int> scores, int par) {
    int totalStrokes = scores.reduce((a, b) => a + b);
    int differenceFromPar = totalStrokes - par;
    rounds.add(
      RoundStats(
        totalStrokes: totalStrokes,
        differenceFromPar: differenceFromPar,
        courseId: courseId,
        date: date,
      ),
    );
  }
}




