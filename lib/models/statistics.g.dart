// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      courseId: json['courseId'] as String,
      playerName: json['playerName'] as String,
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) => RoundStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'playerName': instance.playerName,
      'rounds': instance.rounds,
    };

RoundStats _$RoundStatsFromJson(Map<String, dynamic> json) => RoundStats(
      totalStrokes: (json['totalStrokes'] as num).toInt(),
      differenceFromPar: (json['differenceFromPar'] as num).toInt(),
    );

Map<String, dynamic> _$RoundStatsToJson(RoundStats instance) =>
    <String, dynamic>{
      'totalStrokes': instance.totalStrokes,
      'differenceFromPar': instance.differenceFromPar,
    };
