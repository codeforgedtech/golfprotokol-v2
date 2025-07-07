import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/player_service.dart';
import 'hole_screen.dart';

class SelectPlayerScreen extends StatefulWidget {
  final Course course;

  SelectPlayerScreen({required this.course});

  @override
  _SelectPlayerScreenState createState() => _SelectPlayerScreenState();
}

class _SelectPlayerScreenState extends State<SelectPlayerScreen> {
  List<String> _players = [];
  String _newPlayerName = '';
  int _selectedRounds = 1; // Standard: 1 varv

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  void _loadPlayers() async {
    final players = await PlayerService.loadPlayers();
    setState(() {
      _players = players;
    });
  }

  void _addPlayer() async {
    if (_newPlayerName.isNotEmpty) {
      await PlayerService.addPlayer(_newPlayerName);
      _loadPlayers();
      setState(() {
        _newPlayerName = '';
      });
    }
  }

  void _removePlayer(String player) async {
    await PlayerService.removePlayer(player);
    _loadPlayers();
  }

  void _goToHoleScreen() {
    if (_players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Välj minst en spelare.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HoleScreen(
          course: widget.course,
          playerNames: _players,
          roundCount: _selectedRounds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course.name}'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lägg till ny spelare:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Ny spelare',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      filled: true,
                      fillColor: Colors.green[50],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _newPlayerName = value;
                      });
                    },
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addPlayer,
                  child: Text('Lägg till'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    textStyle: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Antal varv:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade700, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedRounds,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRounds = value;
                      });
                    }
                  },
                  items: [1, 2, 3].map((round) {
                    return DropdownMenuItem(
                      value: round,
                      child: Text('$round varv', style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.green.shade700),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Spelare:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _players.length,
                itemBuilder: (context, index) {
                  final player = _players[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        player,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removePlayer(player),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _goToHoleScreen,
              child: Text('Spela'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

