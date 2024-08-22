import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(GolfApp());
}

class GolfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bangolf protokoll ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
