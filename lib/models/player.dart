import 'role.dart';

class Player {
  final int id;
  final String name;
  final Role role;
  final String word;
  bool isAlive;
  bool hasSeenWord;
  int score;
  int roundPointsEarned;

  Player({
    required this.id,
    required this.name,
    required this.role,
    required this.word,
    this.isAlive = true,
    this.hasSeenWord = false,
    this.score = 0,
    this.roundPointsEarned = 0,
  });

  Player copyWith({
    int? id,
    String? name,
    Role? role,
    String? word,
    bool? isAlive,
    bool? hasSeenWord,
    int? score,
    int? roundPointsEarned,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      word: word ?? this.word,
      isAlive: isAlive ?? this.isAlive,
      hasSeenWord: hasSeenWord ?? this.hasSeenWord,
      score: score ?? this.score,
      roundPointsEarned: roundPointsEarned ?? this.roundPointsEarned,
    );
  }
}
