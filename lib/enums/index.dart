enum EntityType {
  CHARACTER,
  SPACE,
  CITY,
}

extension EntityTypeExtension on EntityType {
  String get displayTitle {
    switch (this) {
      case EntityType.CHARACTER:
        return "Character";
      case EntityType.SPACE:
        return "Space";
      case EntityType.CITY:
        return "City or village";
    }
  }
}

enum Language {
  RU,
  US,
}

extension LanguageExtension on Language {
  String get displayTitle {
    switch (this) {
      case Language.RU:
        return "Русский";
      case Language.US:
        return "English";
    }
  }
}