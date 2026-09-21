import '../models/word_pair.dart';

class WordPairsData {
  static const List<String> categories = [
    'All Categories',
    'Food & Drinks',
    'Tech & Media',
    'Animals & Nature',
    'Objects & Daily Life',
    'Places & Travel',
  ];

  static const List<WordPair> defaultPairs = [
    // Food & Drinks
    WordPair(civilianWord: 'Coffee', undercoverWord: 'Tea', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Pizza', undercoverWord: 'Burger', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Ice Cream', undercoverWord: 'Frozen Yogurt', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Apple', undercoverWord: 'Pear', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Butter', undercoverWord: 'Margarine', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Coca-Cola', undercoverWord: 'Pepsi', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Chocolate', undercoverWord: 'Vanilla', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Sushi', undercoverWord: 'Sashimi', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Pancake', undercoverWord: 'Waffle', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Lemon', undercoverWord: 'Lime', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Cappuccino', undercoverWord: 'Latte', category: 'Food & Drinks'),
    WordPair(civilianWord: 'Hot Dog', undercoverWord: 'Sausage', category: 'Food & Drinks'),

    // Tech & Media
    WordPair(civilianWord: 'iPhone', undercoverWord: 'Android Phone', category: 'Tech & Media'),
    WordPair(civilianWord: 'Laptop', undercoverWord: 'Tablet', category: 'Tech & Media'),
    WordPair(civilianWord: 'Computer Mouse', undercoverWord: 'Trackpad', category: 'Tech & Media'),
    WordPair(civilianWord: 'Headphones', undercoverWord: 'Earbuds', category: 'Tech & Media'),
    WordPair(civilianWord: 'YouTube', undercoverWord: 'TikTok', category: 'Tech & Media'),
    WordPair(civilianWord: 'Batman', undercoverWord: 'Superman', category: 'Tech & Media'),
    WordPair(civilianWord: 'Cinema', undercoverWord: 'Theater', category: 'Tech & Media'),
    WordPair(civilianWord: 'Guitar', undercoverWord: 'Violin', category: 'Tech & Media'),
    WordPair(civilianWord: 'PlayStation', undercoverWord: 'Xbox', category: 'Tech & Media'),
    WordPair(civilianWord: 'Instagram', undercoverWord: 'Snapchat', category: 'Tech & Media'),
    WordPair(civilianWord: 'Keyboard', undercoverWord: 'Typewriter', category: 'Tech & Media'),

    // Animals & Nature
    WordPair(civilianWord: 'Cat', undercoverWord: 'Dog', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Sun', undercoverWord: 'Moon', category: 'Animals & Nature'),
    WordPair(civilianWord: 'River', undercoverWord: 'Stream', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Dolphin', undercoverWord: 'Whale', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Forest', undercoverWord: 'Jungle', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Lion', undercoverWord: 'Tiger', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Eagle', undercoverWord: 'Falcon', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Volcano', undercoverWord: 'Mountain', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Goldfish', undercoverWord: 'Shark', category: 'Animals & Nature'),
    WordPair(civilianWord: 'Bee', undercoverWord: 'Wasp', category: 'Animals & Nature'),

    // Objects & Daily Life
    WordPair(civilianWord: 'Pen', undercoverWord: 'Pencil', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Chair', undercoverWord: 'Stool', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Clock', undercoverWord: 'Watch', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Mirror', undercoverWord: 'Window', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Umbrella', undercoverWord: 'Raincoat', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Pillow', undercoverWord: 'Cushion', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Backpack', undercoverWord: 'Handbag', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Spoon', undercoverWord: 'Fork', category: 'Objects & Daily Life'),
    WordPair(civilianWord: 'Glasses', undercoverWord: 'Sunglasses', category: 'Objects & Daily Life'),

    // Places & Travel
    WordPair(civilianWord: 'Car', undercoverWord: 'Bicycle', category: 'Places & Travel'),
    WordPair(civilianWord: 'Airplane', undercoverWord: 'Helicopter', category: 'Places & Travel'),
    WordPair(civilianWord: 'Beach', undercoverWord: 'Island', category: 'Places & Travel'),
    WordPair(civilianWord: 'Hotel', undercoverWord: 'Motel', category: 'Places & Travel'),
    WordPair(civilianWord: 'Train', undercoverWord: 'Subway', category: 'Places & Travel'),
    WordPair(civilianWord: 'Castle', undercoverWord: 'Palace', category: 'Places & Travel'),
    WordPair(civilianWord: 'Library', undercoverWord: 'Bookstore', category: 'Places & Travel'),
  ];

  static List<WordPair> getPairsByCategory(String category) {
    if (category == 'All Categories' || category.isEmpty) {
      return defaultPairs;
    }
    return defaultPairs.where((p) => p.category == category).toList();
  }
}
