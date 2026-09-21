import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'screens/game_over_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/voting_screen.dart';
import 'screens/word_reveal_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const UndercoverApp());
}

class UndercoverApp extends StatelessWidget {
  const UndercoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(),
      child: MaterialApp(
        title: 'Undercover Game',
        debugShowCheckedModeBanner: false,
        theme: UndercoverTheme.darkTheme,
        home: const MainRouter(),
      ),
    );
  }
}

class MainRouter extends StatelessWidget {
  const MainRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _getScreenForPhase(controller.phase),
    );
  }

  Widget _getScreenForPhase(GamePhase phase) {
    switch (phase) {
      case GamePhase.setup:
        return const SetupScreen(key: ValueKey('SetupScreen'));
      case GamePhase.wordReveal:
      case GamePhase.discussion:
        return const WordRevealScreen(key: ValueKey('WordRevealScreen'));
      case GamePhase.voting:
      case GamePhase.mrWhiteGuess:
        return const VotingScreen(key: ValueKey('VotingScreen'));
      case GamePhase.gameOver:
        return const GameOverScreen(key: ValueKey('GameOverScreen'));
    }
  }
}
