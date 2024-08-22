// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      par: (json['par'] as num).toInt(),
      holes: (json['holes'] as List<dynamic>)
          .map((e) => Hole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'par': instance.par,
      'holes': instance.holes,
    };

Hole _$HoleFromJson(Map<String, dynamic> json) => Hole(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$HoleToJson(Hole instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
    };
