import 'package:flutter/material.dart';
import '../services/data_service.dart'; // Importera DataService för att hantera inlämning

class TipCourseScreen extends StatefulWidget {
  @override
  _TipCourseScreenState createState() => _TipCourseScreenState();
}

class _TipCourseScreenState extends State<TipCourseScreen> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final DataService _dataService = DataService();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipsa om ny bana'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fyll i informationen nedan för att tipsa om en ny bana.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(
                labelText: 'Bananamn',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Plats',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 16.0),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitTip,
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Skicka tips'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitTip() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    // Collect form data
    final courseName = _courseNameController.text.trim();
    final location = _locationController.text.trim();

    if (courseName.isEmpty || location.isEmpty) {
      setState(() {
        _errorMessage = 'Fyll i alla fält.';
        _isSubmitting = false;
      });
      return;
    }

    try {
      // Send tip to Formspree
      await _dataService.submitCourseTip(courseName, location);

      // Show success message and navigate back
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tips skickat!')));
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      setState(() {
        _errorMessage = 'Kunde inte skicka tipset. Försök igen senare.';
        _isSubmitting = false;
      });
    }
  }
}
