import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Function onTap;

  CourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(course.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plats: ${course.location}'),
            Text('Par: ${course.par}'),
            Text(
                'Antal hål: ${course.holes.length}'), // Show the number of holes
          ],
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
