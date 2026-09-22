import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/role.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/flip_card.dart';
import '../widgets/role_badge.dart';

class WordRevealScreen extends StatelessWidget {
  const WordRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    if (controller.phase == GamePhase.discussion) {
      return _buildDiscussionPhaseView(context, controller);
    }

    final currentPlayer = controller.players[controller.currentRevealIndex];
    final total = controller.players.length;
    final currentNum = controller.currentRevealIndex + 1;

    return Scaffold(
      body: Container(
        decoration: UndercoverTheme.mainBackgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressHeader(currentNum, total),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pass the device to',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentPlayer.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => controller.toggleCardReveal(),
                        child: FlipCard(
                          isFlipped: controller.isCardRevealed,
                          front: _buildCardFront(currentPlayer),
                          back: _buildCardBack(currentPlayer),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (controller.isCardRevealed)
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: CustomButton(
                            text: 'I\'ve Memorized It! Next Player',
                            icon: Icons.check_circle_outline_rounded,
                            onPressed: () => controller.advanceToNextPlayerReveal(),
                          ),
                        )
                      else
                        Text(
                          'Tap card above to reveal your secret word in private',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(int current, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: UndercoverTheme.vibrantBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: UndercoverTheme.skyBlue.withOpacity(0.3)),
            ),
            child: Text(
              'Player $current of $total',
              style: const TextStyle(
                color: UndercoverTheme.skyBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: current / total,
                backgroundColor: const Color(0xFF334155),
                valueColor: const AlwaysStoppedAnimation<Color>(UndercoverTheme.vibrantBlue),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(currentPlayer) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UndercoverTheme.vibrantBlue.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: UndercoverTheme.vibrantBlue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: UndercoverTheme.vibrantBlue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 48,
              color: UndercoverTheme.skyBlue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Secret Word Card',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap card to reveal',
            style: TextStyle(
              fontSize: 14,
              color: UndercoverTheme.skyBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Make sure nobody else is looking at the screen!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(currentPlayer) {
    final role = currentPlayer.role as Role;
    final isMrWhite = role == Role.mrWhite;

    final themeColor = isMrWhite ? Role.mrWhite.color : UndercoverTheme.vibrantBlue;
    final accentColor = isMrWhite ? Role.mrWhite.color : UndercoverTheme.skyBlue;

    return Container(
      width: double.infinity,
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: themeColor.withOpacity(0.8), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isMrWhite)
            const RoleBadge(role: Role.mrWhite)
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: UndercoverTheme.vibrantBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: UndercoverTheme.skyBlue.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.lock_rounded, size: 16, color: UndercoverTheme.skyBlue),
                  SizedBox(width: 6),
                  Text(
                    'SECRET WORD',
                    style: TextStyle(
                      color: UndercoverTheme.skyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Text(
            isMrWhite ? 'YOUR STATUS' : 'YOUR SECRET WORD IS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              currentPlayer.word,
              style: TextStyle(
                fontSize: isMrWhite ? 48 : 32,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isMrWhite
                ? 'You have NO word! Listen carefully during descriptions and bluff your way through.'
                : 'Keep your word secret! Give a 1-sentence hint during discussion to figure out if you share the majority word or not.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionPhaseView(BuildContext context, GameController controller) {
    return Scaffold(
      body: Container(
        decoration: UndercoverTheme.mainBackgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: UndercoverTheme.headerCardGradient,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.record_voice_over_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'All Words Received!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Description Phase',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: UndercoverTheme.skyBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Going one by one around the circle, each player gives a short description or brief truthful sentence of their word.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Important: Do NOT reveal your exact word or make it too obvious!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: CustomButton(
                    text: 'Start Voting',
                    icon: Icons.how_to_vote_rounded,
                    onPressed: () => controller.proceedToVoting(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
