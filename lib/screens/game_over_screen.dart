import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/role.dart';
import '../theme/app_theme.dart';
import '../widgets/confetti_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/role_badge.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final winningTeam = controller.winningTeam;

    Color teamColor = UndercoverTheme.vibrantBlue;
    String titleText = 'GAME OVER';
    IconData victoryIcon = Icons.emoji_events_rounded;

    if (winningTeam == WinningTeam.civilians) {
      teamColor = Role.civilian.color;
      titleText = 'CIVILIANS WIN!';
      victoryIcon = Icons.groups_rounded;
    } else if (winningTeam == WinningTeam.infiltrators) {
      teamColor = Role.undercover.color;
      titleText = 'INFILTRATORS WIN!';
      victoryIcon = Icons.security_rounded;
    } else if (winningTeam == WinningTeam.mrWhiteGuess) {
      teamColor = Role.mrWhite.color;
      titleText = 'MR. WHITE WINS!';
      victoryIcon = Icons.help_outline_rounded;
    }

    // Sort players for leaderboard by cumulative total score
    final leaderboard = List.of(controller.players)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      body: ConfettiWidget(
        child: Container(
          decoration: UndercoverTheme.mainBackgroundGradient,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: teamColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: teamColor, width: 3),
                          ),
                          child: Icon(
                            victoryIcon,
                            size: 60,
                            color: teamColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          titleText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: teamColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            controller.victoryMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildWordPairCard(controller),
                        const SizedBox(height: 20),
                        _buildLeaderboardCard(leaderboard),
                        const SizedBox(height: 20),
                        _buildPlayerSummaryList(controller),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                _buildActionButtons(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordPairCard(GameController controller) {
    final pair = controller.currentWordPair;
    if (pair == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text(
            'SECRET WORDS USED',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: UndercoverTheme.skyBlue,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Civilians Word', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    controller.activeCivilianWord,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              Container(height: 30, width: 1, color: Colors.white10),
              Column(
                children: [
                  const Text('Undercover Word', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    controller.activeUndercoverWord,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(List players) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Leaderboard & Points',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.leaderboard_rounded, color: Colors.amber, size: 22),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: players.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 12),
              itemBuilder: (context, index) {
                final player = players[index];
                final roundPts = player.roundPointsEarned;

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0
                          ? Colors.amber.withOpacity(0.2)
                          : const Color(0xFF334155),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index == 0 ? Colors.amber : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (roundPts > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.withOpacity(0.4)),
                        ),
                        child: Text(
                          '+$roundPts pts',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      '${player.score} pts',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: UndercoverTheme.skyBlue,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSummaryList(GameController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Roles Reveal Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.players.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 16),
              itemBuilder: (context, index) {
                final player = controller.players[index];
                return Row(
                  children: [
                    Icon(
                      player.isAlive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: player.isAlive ? Colors.greenAccent : Colors.redAccent.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        player.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: player.isAlive ? Colors.white : Colors.white54,
                          decoration: player.isAlive ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    RoleBadge(
                      role: player.role,
                      showWord: true,
                      word: player.word,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(GameController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: CustomButton(
              text: 'Play Next Round (Same Scores)',
              icon: Icons.replay_rounded,
              onPressed: () => controller.playAgainSameSettings(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: CustomButton(
              text: 'Reset & New Game',
              icon: Icons.settings_rounded,
              isSecondary: true,
              onPressed: () => controller.resetToSetup(),
            ),
          ),
        ],
      ),
    );
  }
}
