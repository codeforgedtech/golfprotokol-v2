import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Om Bangolf Protokoll'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        // Allows scrolling in case content exceeds screen height
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bangolf Protokoll',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20.0),
              Divider(color: Colors.green, thickness: 2.0),
              SizedBox(height: 20.0),
              _buildInfoRow('Version:', '1.0.0'),
              _buildInfoRow('Utvecklare:', 'Christer Holm'),
              _buildInfoRow('Företag:', 'CodeForged Tech'),
              _buildInfoRow('Hemsida:', 'www.codeforged.se', isLink: true),
              _buildInfoRow('Kontakt:', 'info@codeforged.se'),
              SizedBox(height: 20.0),
              Divider(color: Colors.green, thickness: 2.0),
              SizedBox(height: 20.0),
              Text(
                'Om Appen:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Bangolf Protokoll är en app som låter dig hålla koll på dina minigolfresultat, se statistik och tipsa om nya banor. '
                'Appen är designad för att vara enkel att använda, samtidigt som den erbjuder kraftfulla funktioner för både nybörjare och erfarna spelare.',
                style: TextStyle(
                  fontSize: 14.0,
                  height:
                      1.5, // Improves readability with increased line spacing
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build rows for version, creator, etc.
  Widget _buildInfoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isLink
                  ? () {
                      // Handle link click if necessary, otherwise just a placeholder
                    }
                  : null,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13.0,
                  color: isLink ? Colors.blue : Colors.black,
                  decoration:
                      isLink ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
