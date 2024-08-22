import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable()
class Statistics {
  final String courseId;
  final String playerName;
  final List<RoundStats> rounds;

  Statistics({
    required this.courseId,
    required this.playerName,
    required this.rounds,
  });

  void addRound(List<int> scores, int par) {
    int totalStrokes = scores.reduce((a, b) => a + b);
    int differenceFromPar = totalStrokes - par;
    rounds.add(RoundStats(
      totalStrokes: totalStrokes,
      differenceFromPar: differenceFromPar,
    ));
  }

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$StatisticsToJson(this);
}

@JsonSerializable()
class RoundStats {
  final int totalStrokes;
  final int differenceFromPar;

  RoundStats({
    required this.totalStrokes,
    required this.differenceFromPar,
  });

  factory RoundStats.fromJson(Map<String, dynamic> json) =>
      _$RoundStatsFromJson(json);
  Map<String, dynamic> toJson() => _$RoundStatsToJson(this);
}
