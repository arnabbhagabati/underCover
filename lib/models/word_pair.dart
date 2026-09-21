class WordPair {
  final String civilianWord;
  final String undercoverWord;
  final String category;

  const WordPair({
    required this.civilianWord,
    required this.undercoverWord,
    this.category = 'General',
  });
}
