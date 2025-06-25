String normalize(String input) {
  final lower = input.toLowerCase().trim();

  // Remove articles like "a", "an", "the" from start
  final noArticles = lower.replaceFirst(RegExp(r'^(a|an|the)\s+'), '');

  // Remove plural "s" if word is longer than 3 letters (basic plural handling)
  final singular = noArticles.endsWith('s') && noArticles.length > 3
      ? noArticles.substring(0, noArticles.length - 1)
      : noArticles;

  // Remove punctuation
  final noPunctuation = singular.replaceAll(RegExp(r'[^\w\s]'), '');

  // Collapse multiple spaces
  final normalized = noPunctuation.replaceAll(RegExp(r'\s+'), ' ');

  return normalized;
}
