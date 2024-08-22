import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  final String id;
  final String name;
  final String location;
  final int par;
  final List<Hole> holes; // Update to List<Hole>

  Course({
    required this.id,
    required this.name,
    required this.location,
    required this.par,
    required this.holes,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable()
class Hole {
  final int number;
  final String name;

  Hole({
    required this.number,
    required this.name,
  });

  factory Hole.fromJson(Map<String, dynamic> json) => _$HoleFromJson(json);
  Map<String, dynamic> toJson() => _$HoleToJson(this);
}
