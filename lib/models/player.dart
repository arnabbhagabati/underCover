import 'role.dart';

class Player {
  final int id;
  final String name;
  final Role role;
  final String word;
  bool isAlive;
  bool hasSeenWord;

  Player({
    required this.id,
    required this.name,
    required this.role,
    required this.word,
    this.isAlive = true,
    this.hasSeenWord = false,
  });

  Player copyWith({
    int? id,
    String? name,
    Role? role,
    String? word,
    bool? isAlive,
    bool? hasSeenWord,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      word: word ?? this.word,
      isAlive: isAlive ?? this.isAlive,
      hasSeenWord: hasSeenWord ?? this.hasSeenWord,
    );
  }
}
