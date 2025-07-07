import 'package:flutter/material.dart';
import '../models/course.dart';
import 'hole_screen.dart';

class StartNewRoundScreen extends StatefulWidget {
  final Course course;
  final String playerName;

  StartNewRoundScreen({required this.course, required this.playerName});

  @override
  _StartNewRoundScreenState createState() => _StartNewRoundScreenState();
}

class _StartNewRoundScreenState extends State<StartNewRoundScreen> {
  int _roundCount = 1;
  List<String> _playerNames = [];
  final TextEditingController _playerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _playerNames.add(widget.playerName);
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  void _addPlayer() {
    String newPlayer = _playerController.text.trim();
    if (newPlayer.isNotEmpty && !_playerNames.contains(newPlayer)) {
      setState(() {
        _playerNames.add(newPlayer);
        _playerController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ange ett unikt och giltigt namn')),
      );
    }
  }

  void _removePlayer(String player) {
    if (_playerNames.length > 1) {
      setState(() {
        _playerNames.remove(player);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Minst en spelare krävs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Starta ny omgång'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Snygg dropdown med formfält-stil
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Välj antal varv (max 3):', style: TextStyle(fontSize: 18)),
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
                  value: _roundCount,
                  onChanged: (value) {
                    setState(() {
                      _roundCount = value!;
                    });
                  },
                  items: List.generate(3, (index) => index + 1)
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            '$e',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                      .toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.green.shade700),
                ),
              ),
            ),

            SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Spelare:', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: _playerNames.length,
                itemBuilder: (context, index) {
                  final player = _playerNames[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        player,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.red.shade700, size: 28),
                        onPressed: () => _removePlayer(player),
                        tooltip: 'Ta bort spelare',
                      ),
                    ),
                  );
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerController,
                    decoration: InputDecoration(
                      labelText: 'Lägg till spelare',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addPlayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Icon(Icons.add, size: 28),
                ),
              ],
            ),

            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _playerNames.isEmpty
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HoleScreen(
                              course: widget.course,
                              playerNames: _playerNames,
                              roundCount: _roundCount,
                            ),
                          ),
                        );
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Starta spel',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.green.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



