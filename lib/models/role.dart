import 'package:flutter/material.dart';

enum Role {
  civilian,
  undercover,
  mrWhite,
}

extension RoleExtension on Role {
  String get displayName {
    switch (this) {
      case Role.civilian:
        return 'Civilian';
      case Role.undercover:
        return 'Undercover';
      case Role.mrWhite:
        return 'Mr. White';
    }
  }

  String get description {
    switch (this) {
      case Role.civilian:
        return 'You share the majority word with other Civilians.';
      case Role.undercover:
        return 'You have a slightly different word. Blend in!';
      case Role.mrWhite:
        return 'You have NO word! Listen carefully and guess the word.';
    }
  }

  IconData get icon {
    switch (this) {
      case Role.civilian:
        return Icons.people_alt_rounded;
      case Role.undercover:
        return Icons.security_rounded;
      case Role.mrWhite:
        return Icons.help_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case Role.civilian:
        return const Color(0xFF10B981); // Emerald Green
      case Role.undercover:
        return const Color(0xFFEF4444); // Red
      case Role.mrWhite:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  Color get badgeBgColor {
    switch (this) {
      case Role.civilian:
        return const Color(0xFFD1FAE5);
      case Role.undercover:
        return const Color(0xFFFEE2E2);
      case Role.mrWhite:
        return const Color(0xFFEDE9FE);
    }
  }
}
