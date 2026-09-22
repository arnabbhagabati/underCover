import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../models/word_pair.dart';
import '../data/word_pairs.dart';

enum GamePhase {
  setup,
  wordReveal,
  discussion,
  voting,
  mrWhiteGuess,
  gameOver,
}

enum WinningTeam {
  civilians,
  infiltrators,
  mrWhiteGuess,
}

class GameController extends ChangeNotifier {
  // Setup Parameters
  int civiliansCount = 3;
  int undercoverCount = 1;
  int mrWhiteCount = 1;

  List<String> playerNames = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
  ];

  Map<String, int> cumulativeScores = {}; // Preserves player scores across rounds

  String selectedCategory = 'All Categories';
  String customCivilianWord = '';
  String customUndercoverWord = '';

  // Active Game State
  GamePhase phase = GamePhase.setup;
  List<Player> players = [];
  WordPair? currentWordPair;
  String activeCivilianWord = '';
  String activeUndercoverWord = '';

  int currentRevealIndex = 0;
  bool isCardRevealed = false;

  Player? currentEliminatedPlayer;
  String mrWhiteLastGuess = '';
  bool? mrWhiteGuessCorrect;

  WinningTeam? winningTeam;
  String victoryMessage = '';

  final Random _random = Random();

  int get totalPlayers => civiliansCount + undercoverCount + mrWhiteCount;

  int get aliveCiviliansCount =>
      players.where((p) => p.isAlive && p.role == Role.civilian).length;

  int get aliveUndercoverCount =>
      players.where((p) => p.isAlive && p.role == Role.undercover).length;

  int get aliveMrWhiteCount =>
      players.where((p) => p.isAlive && p.role == Role.mrWhite).length;

  int get aliveSpiesCount => aliveUndercoverCount + aliveMrWhiteCount;

  bool get isSetupValid {
    if (civiliansCount < 2) return false;
    if (undercoverCount < 1) return false;
    if (mrWhiteCount < 0) return false;
    // Civilians must initially strictly outnumber undercovers + mr white
    if (civiliansCount <= (undercoverCount + mrWhiteCount)) return false;
    if (playerNames.length != totalPlayers) return false;
    if (playerNames.any((name) => name.trim().isEmpty)) return false;

    if (selectedCategory == 'Custom') {
      if (customCivilianWord.trim().isEmpty || customUndercoverWord.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  // --- Setup Actions ---

  void updateRoleCounts({int? civilians, int? undercover, int? mrWhite}) {
    if (civilians != null && civilians >= 2) civiliansCount = civilians;
    if (undercover != null && undercover >= 1) undercoverCount = undercover;
    if (mrWhite != null && mrWhite >= 0) mrWhiteCount = mrWhite;

    _syncPlayerNamesCount();
    notifyListeners();
  }

  void _syncPlayerNamesCount() {
    final target = totalPlayers;
    if (playerNames.length < target) {
      for (int i = playerNames.length + 1; i <= target; i++) {
        playerNames.add('Player $i');
      }
    } else if (playerNames.length > target) {
      playerNames = playerNames.sublist(0, target);
    }
  }

  void updatePlayerName(int index, String newName) {
    if (index >= 0 && index < playerNames.length) {
      playerNames[index] = newName;
      notifyListeners();
    }
  }

  void shufflePlayerNames() {
    playerNames.shuffle(_random);
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setCustomWords(String civilian, String undercover) {
    customCivilianWord = civilian;
    customUndercoverWord = undercover;
    notifyListeners();
  }

  // --- Start Game ---

  void startGame() {
    if (!isSetupValid) return;

    // Pick Word Pair
    if (selectedCategory == 'Custom') {
      currentWordPair = WordPair(
        civilianWord: customCivilianWord.trim(),
        undercoverWord: customUndercoverWord.trim(),
        category: 'Custom',
      );
    } else {
      final availablePairs = WordPairsData.getPairsByCategory(selectedCategory);
      currentWordPair = availablePairs[_random.nextInt(availablePairs.length)];
    }

    // Interchangeably assign civilian and undercover words for 50% random swap
    final bool swapWords = _random.nextBool();
    activeCivilianWord = swapWords
        ? currentWordPair!.undercoverWord
        : currentWordPair!.civilianWord;
    activeUndercoverWord = swapWords
        ? currentWordPair!.civilianWord
        : currentWordPair!.undercoverWord;

    // Build Roles Deck
    List<Role> rolesDeck = [];
    for (int i = 0; i < civiliansCount; i++) {
      rolesDeck.add(Role.civilian);
    }
    for (int i = 0; i < undercoverCount; i++) {
      rolesDeck.add(Role.undercover);
    }
    for (int i = 0; i < mrWhiteCount; i++) {
      rolesDeck.add(Role.mrWhite);
    }
    rolesDeck.shuffle(_random);

    // Build Players with cumulative scores preserved
    players = List.generate(totalPlayers, (index) {
      final name = playerNames[index].trim();
      final role = rolesDeck[index];
      String word;
      if (role == Role.civilian) {
        word = activeCivilianWord;
      } else if (role == Role.undercover) {
        word = activeUndercoverWord;
      } else {
        word = '?';
      }

      final existingScore = cumulativeScores[name] ?? 0;

      return Player(
        id: index + 1,
        name: name,
        role: role,
        word: word,
        score: existingScore,
        roundPointsEarned: 0,
      );
    });

    currentRevealIndex = 0;
    isCardRevealed = false;
    currentEliminatedPlayer = null;
    mrWhiteLastGuess = '';
    mrWhiteGuessCorrect = null;
    winningTeam = null;
    victoryMessage = '';
    phase = GamePhase.wordReveal;

    notifyListeners();
  }

  // --- Word Reveal Actions ---

  void toggleCardReveal() {
    isCardRevealed = !isCardRevealed;
    notifyListeners();
  }

  void advanceToNextPlayerReveal() {
    if (currentRevealIndex < players.length) {
      players[currentRevealIndex].hasSeenWord = true;
    }
    isCardRevealed = false;

    if (currentRevealIndex + 1 < players.length) {
      currentRevealIndex++;
    } else {
      // All players have seen their word! Move to discussion
      phase = GamePhase.discussion;
    }
    notifyListeners();
  }

  void proceedToVoting() {
    phase = GamePhase.voting;
    notifyListeners();
  }

  // --- Voting & Elimination ---

  void eliminatePlayer(Player player) {
    player.isAlive = false;
    currentEliminatedPlayer = player;

    if (player.role == Role.mrWhite) {
      // Mr. White gets a chance to guess the civilian word!
      phase = GamePhase.mrWhiteGuess;
      notifyListeners();
    } else {
      _evaluateGameWinner();
      notifyListeners();
    }
  }

  void submitMrWhiteGuess(String guess) {
    mrWhiteLastGuess = guess.trim();
    final targetWord = activeCivilianWord.trim().toLowerCase();

    if (mrWhiteLastGuess.toLowerCase() == targetWord) {
      // Mr. White guessed correctly and steals the win! (6 points for Mr. White)
      mrWhiteGuessCorrect = true;
      winningTeam = WinningTeam.mrWhiteGuess;
      victoryMessage =
          'Mr. White (${currentEliminatedPlayer?.name}) guessed "$activeCivilianWord" correctly! (+6 pts)';
      _awardPoints(WinningTeam.mrWhiteGuess, winningMrWhite: currentEliminatedPlayer);
      phase = GamePhase.gameOver;
    } else {
      mrWhiteGuessCorrect = false;
      // Mr. White failed. Proceed to evaluate remaining game rules
      _evaluateGameWinner();
    }
    notifyListeners();
  }

  void _evaluateGameWinner() {
    if (aliveSpiesCount == 0) {
      // Civilians win if they eliminate all Undercovers and Mr. Whites! (+2 pts each)
      winningTeam = WinningTeam.civilians;
      victoryMessage =
          'Civilians successfully eliminated all Undercovers and Mr. White! (+2 pts each)';
      _awardPoints(WinningTeam.civilians);
      phase = GamePhase.gameOver;
    } else if (aliveCiviliansCount <= 1 && aliveSpiesCount >= 1) {
      // Infiltrators win if they survive until only 1 Civilian is left!
      winningTeam = WinningTeam.infiltrators;
      victoryMessage =
          'Infiltrators survived until only 1 Civilian remained! (Undercover: +10 pts, Mr. White: +6 pts)';
      _awardPoints(WinningTeam.infiltrators);
      phase = GamePhase.gameOver;
    } else {
      // Game continues!
      phase = GamePhase.voting;
    }
  }

  // --- Points Scoring Logic ---

  void _awardPoints(WinningTeam team, {Player? winningMrWhite}) {
    for (var p in players) {
      int pts = 0;
      if (team == WinningTeam.civilians) {
        if (p.role == Role.civilian) {
          pts = 2; // Civilians get 2 points each
        }
      } else if (team == WinningTeam.infiltrators) {
        if (p.role == Role.undercover && p.isAlive) {
          pts = 10; // Undercover gets 10 points on victory
        } else if (p.role == Role.mrWhite && p.isAlive) {
          pts = 6; // Mr. White gets 6 points on victory
        }
      } else if (team == WinningTeam.mrWhiteGuess) {
        if (p.id == winningMrWhite?.id) {
          pts = 12; // Mr. White gets 12 points on correct guess
        }
      }

      p.roundPointsEarned = pts;
      p.score += pts;
      cumulativeScores[p.name] = p.score;
    }
  }

  // --- Reset & Play Again ---

  void playAgainSameSettings() {
    startGame();
  }

  void resetToSetup() {
    phase = GamePhase.setup;
    players = [];
    currentWordPair = null;
    activeCivilianWord = '';
    activeUndercoverWord = '';
    cumulativeScores.clear();
    notifyListeners();
  }
}
