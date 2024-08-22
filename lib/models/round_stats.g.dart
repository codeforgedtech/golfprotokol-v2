// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoundStats _$RoundStatsFromJson(Map<String, dynamic> json) => RoundStats(
      totalScore: (json['totalScore'] as num).toInt(),
      scoreDifferenceFromPar: (json['scoreDifferenceFromPar'] as num).toInt(),
    );

Map<String, dynamic> _$RoundStatsToJson(RoundStats instance) =>
    <String, dynamic>{
      'totalScore': instance.totalScore,
      'scoreDifferenceFromPar': instance.scoreDifferenceFromPar,
    };
