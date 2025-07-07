// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoundStats _$RoundStatsFromJson(Map<String, dynamic> json) => RoundStats(
      totalStrokes: (json['totalStrokes'] as num).toInt(),
      differenceFromPar: (json['differenceFromPar'] as num).toInt(),
      courseId: json['courseId'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$RoundStatsToJson(RoundStats instance) =>
    <String, dynamic>{
      'totalStrokes': instance.totalStrokes,
      'differenceFromPar': instance.differenceFromPar,
      'courseId': instance.courseId,
      'date': instance.date.toIso8601String(),
    };
