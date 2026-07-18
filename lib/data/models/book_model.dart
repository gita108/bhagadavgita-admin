import 'language_model.dart';

class Book {
  final int id;
  final int languageId;
  final String name;
  final String initials;
  final int chaptersCount;
  final Language? language;

  Book({
    required this.id,
    required this.languageId,
    required this.name,
    required this.initials,
    this.chaptersCount = 0,
    this.language,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      languageId: json['languageId'] as int,
      name: json['name'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      chaptersCount: json['chaptersCount'] as int? ?? 0,
      language: json['language'] != null
          ? Language.fromJson(json['language'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'name': name,
      'initials': initials,
    };
  }

  Book copyWith({
    int? id,
    int? languageId,
    String? name,
    String? initials,
    int? chaptersCount,
    Language? language,
  }) {
    return Book(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      chaptersCount: chaptersCount ?? this.chaptersCount,
      language: language ?? this.language,
    );
  }
}

class BookInput {
  final int languageId;
  final String name;
  final String initials;

  BookInput({
    required this.languageId,
    required this.name,
    required this.initials,
  });

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'name': name,
      'initials': initials,
    };
  }
}
