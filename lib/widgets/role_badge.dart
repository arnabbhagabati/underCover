import 'package:flutter/material.dart';
import '../models/role.dart';

class RoleBadge extends StatelessWidget {
  final Role role;
  final bool showWord;
  final String? word;

  const RoleBadge({
    super.key,
    required this.role,
    this.showWord = false,
    this.word,
  });

  @override
  Widget build(BuildContext context) {
    final color = role.color;
    final icon = role.icon;
    final name = role.displayName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          if (showWord && word != null) ...[
            const SizedBox(width: 6),
            Container(
              height: 12,
              width: 1,
              color: color.withOpacity(0.4),
            ),
            const SizedBox(width: 6),
            Text(
              '("$word")',
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
