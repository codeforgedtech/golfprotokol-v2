// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      holesCount: (json['holesCount'] as num).toInt(),
      playerName: json['playerName'] as String,
      date: DateTime.parse(json['date'] as String),
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) => RoundStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'holesCount': instance.holesCount,
      'playerName': instance.playerName,
      'date': instance.date.toIso8601String(),
      'rounds': instance.rounds,
    };
