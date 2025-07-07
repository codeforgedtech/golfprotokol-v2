import 'package:json_annotation/json_annotation.dart';

part 'round_stats.g.dart';

@JsonSerializable()
class RoundStats {
  final int totalStrokes;
  final int differenceFromPar;
  final String courseId;
  final DateTime date; // <-- Lägg till detta

  RoundStats({
    required this.totalStrokes,
    required this.differenceFromPar,
    required this.courseId,
    required this.date, // <-- och här
  });

  factory RoundStats.fromJson(Map<String, dynamic> json) =>
      _$RoundStatsFromJson(json);

  Map<String, dynamic> toJson() => _$RoundStatsToJson(this);
}



