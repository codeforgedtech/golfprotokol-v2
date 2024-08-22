import 'package:shared_preferences/shared_preferences.dart';

class PlayerService {
  static const String _playersKey = 'players';

  // Spara en ny spelare i SharedPreferences
  static Future<void> addPlayer(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> players = prefs.getStringList(_playersKey) ?? [];
    if (!players.contains(playerName)) {
      players.add(playerName);
      await prefs.setStringList(_playersKey, players);
    }
  }

  // Ladda alla sparade spelare
  static Future<List<String>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_playersKey) ?? [];
  }

  // Ta bort en spelare från listan
  static Future<void> removePlayer(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> players = prefs.getStringList(_playersKey) ?? [];
    players.remove(playerName);
    await prefs.setStringList(_playersKey, players);
  }

  // Rensa alla spelare (om du behöver detta)
  static Future<void> clearPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playersKey);
  }
}
