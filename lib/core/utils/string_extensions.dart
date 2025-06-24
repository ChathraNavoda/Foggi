String normalize(String input) {
  final lower = input.toLowerCase().trim();
  final withoutArticles = lower.replaceAll(RegExp(r'^(a|an|the)\s+'), '');
  final singular = withoutArticles.endsWith('s') && withoutArticles.length > 3
      ? withoutArticles.substring(0, withoutArticles.length - 1)
      : withoutArticles;

  return singular;
}
