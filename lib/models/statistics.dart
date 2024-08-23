import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable()
class Statistics {
  final String courseId;
  final String playerName;
  List<RoundStats> rounds; // List should not be final if it's modified

  Statistics({
    required this.courseId,
    required this.playerName,
    required this.rounds,
  });

  // Factory constructor for creating an instance of Statistics from JSON
  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        courseId: json['courseId'] as String? ??
            '', // Hanterar null-värden och sätter ett tomt värde om null
        playerName: json['playerName'] as String? ??
            '', // Hanterar null-värden och sätter ett tomt värde om null
        rounds: (json['rounds'] as List<dynamic>? ?? [])
            .map((e) => RoundStats.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  // Convert Statistics instance to JSON
  Map<String, dynamic> toJson() => _$StatisticsToJson(this);

  // Modifierad addRound-metod
  void addRound(List<int> scores, int par) {
    int totalStrokes = scores.reduce((a, b) => a + b);
    int differenceFromPar = totalStrokes - par;
    rounds.add(RoundStats(
      totalStrokes: totalStrokes,
      differenceFromPar: differenceFromPar,
    ));
  }
}

@JsonSerializable()
class RoundStats {
  final int totalStrokes;
  final int differenceFromPar;

  RoundStats({
    required this.totalStrokes,
    required this.differenceFromPar,
  });

  // Factory constructor for creating an instance of RoundStats from JSON
  factory RoundStats.fromJson(Map<String, dynamic> json) => RoundStats(
        totalStrokes: json['totalStrokes'] as int? ??
            0, // Hanterar null-värden och sätter ett standardvärde om null
        differenceFromPar: json['differenceFromPar'] as int? ??
            0, // Hanterar null-värden och sätter ett standardvärde om null
      );

  // Convert RoundStats instance to JSON
  Map<String, dynamic> toJson() => _$RoundStatsToJson(this);
}
