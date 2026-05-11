enum FilteringMode { none, alphabet, aplhabetReversed, date, dateReversed }

extension FilteringModeExtension on FilteringMode {
  String get readable {
    switch (this) {
      case FilteringMode.none:
        return 'None';
      case FilteringMode.alphabet:
        return 'Alphabet';
      case FilteringMode.aplhabetReversed:
        return 'Alphabet Reversed';
      case FilteringMode.date:
        return 'Date';
      case FilteringMode.dateReversed:
        return 'Date Reversed';
    }
  }
}
