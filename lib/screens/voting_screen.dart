import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/role_badge.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final TextEditingController _mrWhiteGuessController = TextEditingController();

  @override
  void dispose() {
    _mrWhiteGuessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final alivePlayers = controller.players.where((p) => p.isAlive).toList();
    final eliminatedPlayers = controller.players.where((p) => !p.isAlive).toList();

    return Scaffold(
      body: Container(
        decoration: UndercoverTheme.mainBackgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(controller),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAlivePlayersSection(context, controller, alivePlayers),
                      if (eliminatedPlayers.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildEliminatedSection(eliminatedPlayers),
                      ],
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

  Widget _buildHeader(GameController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: UndercoverTheme.headerCardGradient,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'VOTING PHASE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Select who everyone voted to eliminate',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Round Alive: ${controller.players.where((p) => p.isAlive).length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlivePlayersSection(
    BuildContext context,
    GameController controller,
    List<Player> alivePlayers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Players',
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
          itemCount: alivePlayers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final player = alivePlayers[index];
            return Card(
              color: const Color(0xFF1E293B),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: UndercoverTheme.vibrantBlue.withOpacity(0.2),
                  child: Text(
                    player.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: UndercoverTheme.skyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                title: Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: const Text(
                  'Status: Alive',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                trailing: CustomButton(
                  text: 'Vote Out',
                  isSecondary: true,
                  color: UndercoverTheme.undercoverRed,
                  onPressed: () => _confirmElimination(context, controller, player),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEliminatedSection(List<Player> eliminatedPlayers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eliminated Players',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: eliminatedPlayers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final player = eliminatedPlayers[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Spacer(),
                  RoleBadge(
                    role: player.role,
                    showWord: true,
                    word: player.word,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _confirmElimination(
    BuildContext context,
    GameController controller,
    Player player,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminate ${player.name}?'),
          content: Text(
            'Are you sure the group voted to eliminate ${player.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: UndercoverTheme.undercoverRed,
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.eliminatePlayer(player);

                if (controller.phase == GamePhase.mrWhiteGuess) {
                  _showMrWhiteGuessDialog(context, controller, player);
                } else {
                  _showRoleRevealDialog(context, controller, player);
                }
              },
              child: const Text('Yes, Eliminate'),
            ),
          ],
        );
      },
    );
  }

  void _showRoleRevealDialog(
    BuildContext context,
    GameController controller,
    Player player,
  ) {
    final role = player.role;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: role.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(role.icon, size: 48, color: role.color),
              ),
              const SizedBox(height: 16),
              Text(
                '${player.name} is ELIMINATED!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              RoleBadge(
                role: role,
                showWord: true,
                word: player.word,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: controller.phase == GamePhase.gameOver ? 'See Game Results' : 'Continue Game',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMrWhiteGuessDialog(
    BuildContext context,
    GameController controller,
    Player player,
  ) {
    _mrWhiteGuessController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Role.mrWhite.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Role.mrWhite.icon, size: 48, color: Role.mrWhite.color),
              ),
              const SizedBox(height: 16),
              Text(
                '${player.name} was MR. WHITE!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mr. White gets 1 FINAL chance to guess the Civilians\' exact secret word!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _mrWhiteGuessController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter Civilian Secret Word',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Submit Guess',
                  onPressed: () {
                    final guess = _mrWhiteGuessController.text;
                    Navigator.pop(context);
                    controller.submitMrWhiteGuess(guess);
                    _showMrWhiteGuessResultDialog(context, controller, player);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMrWhiteGuessResultDialog(
    BuildContext context,
    GameController controller,
    Player player,
  ) {
    final isCorrect = controller.mrWhiteGuessCorrect == true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.emoji_events_rounded : Icons.cancel_rounded,
                size: 56,
                color: isCorrect ? Colors.amber : Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? 'CORRECT GUESS!' : 'WRONG GUESS!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.amber : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCorrect
                    ? 'Mr. White guessed "${controller.mrWhiteLastGuess}" and STEALS THE WIN!'
                    : 'Mr. White guessed "${controller.mrWhiteLastGuess}", but was incorrect.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Continue',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
