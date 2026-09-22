import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../data/word_pairs.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/role_badge.dart';
import '../models/role.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _customCivilianController = TextEditingController();
  final TextEditingController _customUndercoverController = TextEditingController();
  final Map<int, TextEditingController> _nameControllers = {};

  @override
  void dispose() {
    _customCivilianController.dispose();
    _customUndercoverController.dispose();
    for (var c in _nameControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncNameControllers(GameController controller) {
    for (int i = 0; i < controller.playerNames.length; i++) {
      if (!_nameControllers.containsKey(i)) {
        _nameControllers[i] = TextEditingController(text: controller.playerNames[i]);
      } else if (_nameControllers[i]!.text != controller.playerNames[i]) {
        _nameControllers[i]!.text = controller.playerNames[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    _syncNameControllers(controller);

    return Scaffold(
      body: Container(
        decoration: UndercoverTheme.mainBackgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),
                      _buildRoleCounters(controller),
                      const SizedBox(height: 20),
                      _buildPlayerNamesList(controller),
                      const SizedBox(height: 20),
                      _buildWordCategorySelector(controller),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: UndercoverTheme.headerCardGradient,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'UNDERCOVER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'Find the spy among you',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
                onPressed: () => _showRulesDialog(context),
                tooltip: 'How to Play',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCounters(GameController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Players & Roles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: UndercoverTheme.vibrantBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total: ${controller.totalPlayers}',
                    style: const TextStyle(
                      color: UndercoverTheme.skyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 24),
            _buildCounterRow(
              title: 'Civilians',
              subtitle: 'Shares the majority secret word',
              role: Role.civilian,
              count: controller.civiliansCount,
              onDecrement: () => controller.updateRoleCounts(
                civilians: controller.civiliansCount - 1,
              ),
              onIncrement: () => controller.updateRoleCounts(
                civilians: controller.civiliansCount + 1,
              ),
            ),
            const SizedBox(height: 14),
            _buildCounterRow(
              title: 'Undercover Agents',
              subtitle: 'Gets a related secret word',
              role: Role.undercover,
              count: controller.undercoverCount,
              onDecrement: controller.undercoverCount > 1
                  ? () => controller.updateRoleCounts(
                        undercover: controller.undercoverCount - 1,
                      )
                  : null,
              onIncrement: () => controller.updateRoleCounts(
                    undercover: controller.undercoverCount + 1,
                  ),
            ),
            const SizedBox(height: 14),
            _buildCounterRow(
              title: 'Mr. White',
              subtitle: 'Gets NO word (?)',
              role: Role.mrWhite,
              count: controller.mrWhiteCount,
              onDecrement: controller.mrWhiteCount > 0
                  ? () => controller.updateRoleCounts(
                        mrWhite: controller.mrWhiteCount - 1,
                      )
                  : null,
              onIncrement: () => controller.updateRoleCounts(
                    mrWhite: controller.mrWhiteCount + 1,
                  ),
            ),
            if (!controller.isSetupValid) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Civilians must strictly outnumber Undercovers + Mr. White!',
                        style: TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({
    required String title,
    required String subtitle,
    required Role role,
    required int count,
    required VoidCallback? onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: RoleBadge(role: role),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildMiniIconButton(
              icon: Icons.remove_rounded,
              onPressed: onDecrement,
            ),
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            _buildMiniIconButton(
              icon: Icons.add_rounded,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: onPressed != null ? const Color(0xFF334155) : Colors.white10,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 18,
            color: onPressed != null ? Colors.white : Colors.white30,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerNamesList(GameController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Player Names',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => controller.shufflePlayerNames(),
                  icon: const Icon(Icons.shuffle_rounded, size: 16),
                  label: const Text('Shuffle Order'),
                  style: TextButton.styleFrom(
                    foregroundColor: UndercoverTheme.skyBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.playerNames.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: UndercoverTheme.vibrantBlue.withOpacity(0.2),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: UndercoverTheme.skyBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _nameControllers[index],
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Player ${index + 1} Name',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        onChanged: (value) {
                          controller.updatePlayerName(index, value);
                        },
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

  Widget _buildWordCategorySelector(GameController controller) {
    final categories = ['All Categories', ...WordPairsData.categories.skip(1), 'Custom'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Secret Word Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = controller.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: UndercoverTheme.vibrantBlue,
                  backgroundColor: const Color(0xFF334155),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      controller.setCategory(cat);
                    }
                  },
                );
              }).toList(),
            ),
            if (controller.selectedCategory == 'Custom') ...[
              const SizedBox(height: 16),
              const Text(
                'Enter Custom Word Pair:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: UndercoverTheme.skyBlue,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _customCivilianController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Civilian Secret Word (e.g., Coffee)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                onChanged: (_) {
                  controller.setCustomWords(
                    _customCivilianController.text,
                    _customUndercoverController.text,
                  );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _customUndercoverController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Undercover Secret Word (e.g., Tea)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                onChanged: (_) {
                  controller.setCustomWords(
                    _customCivilianController.text,
                    _customUndercoverController.text,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(GameController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: CustomButton(
          text: 'Start Game',
          icon: Icons.play_arrow_rounded,
          onPressed: controller.isSetupValid ? () => controller.startGame() : null,
        ),
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.help_outline_rounded, color: UndercoverTheme.skyBlue),
              SizedBox(width: 10),
              Text('How to Play'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '1. Role & Word Distribution:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Pass phone around. Civilians get the main word. Undercovers get a related word. Mr. White gets no word (?).',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 12),
                Text(
                  '2. Description Phase:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'In order around the circle, each player gives a 1-sentence hint describing their word without spoiling it.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 12),
                Text(
                  '3. Discussion & Voting:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Debate and vote to eliminate a suspect. If Mr. White is eliminated, they get 1 final chance to guess the Civilians\' word!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 12),
                Text(
                  '4. Victory:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Civilians win if all Spies are eliminated. Spies win if they equal or outnumber Civilians!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got It!'),
            ),
          ],
        );
      },
    );
  }
}
