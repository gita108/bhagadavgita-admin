class Language {
  final int id;
  final String name;
  final String code;
  final int booksCount;
  final int quotesCount;

  Language({
    required this.id,
    required this.name,
    required this.code,
    this.booksCount = 0,
    this.quotesCount = 0,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      booksCount: json['booksCount'] as int? ?? 0,
      quotesCount: json['quotesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }

  Language copyWith({
    int? id,
    String? name,
    String? code,
    int? booksCount,
    int? quotesCount,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      booksCount: booksCount ?? this.booksCount,
      quotesCount: quotesCount ?? this.quotesCount,
    );
  }
}

class LanguageInput {
  final String name;
  final String code;

  LanguageInput({
    required this.name,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
}
