import 'language_model.dart';

class Quote {
  final int id;
  final int languageId;
  final String author;
  final String text;
  final bool isDay;
  final Language? language;

  Quote({
    required this.id,
    required this.languageId,
    this.author = '',
    this.text = '',
    this.isDay = false,
    this.language,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as int,
      languageId: json['languageId'] as int,
      author: json['author'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isDay: json['isDay'] as bool? ?? false,
      language: json['language'] != null
          ? Language.fromJson(json['language'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'author': author,
      'text': text,
      'isDay': isDay,
    };
  }

  Quote copyWith({
    int? id,
    int? languageId,
    String? author,
    String? text,
    bool? isDay,
    Language? language,
  }) {
    return Quote(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      author: author ?? this.author,
      text: text ?? this.text,
      isDay: isDay ?? this.isDay,
      language: language ?? this.language,
    );
  }
}

class QuoteInput {
  final int languageId;
  final String author;
  final String text;
  final bool? isDay;

  QuoteInput({
    required this.languageId,
    required this.author,
    required this.text,
    this.isDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'author': author,
      'text': text,
      if (isDay != null) 'isDay': isDay,
    };
  }
}
