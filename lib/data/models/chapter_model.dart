class Chapter {
  final int id;
  final int bookId;
  final String name;
  final int order;
  final int slokasCount;

  Chapter({
    required this.id,
    required this.bookId,
    required this.name,
    required this.order,
    this.slokasCount = 0,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int,
      bookId: json['bookId'] as int,
      name: json['name'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      slokasCount: json['slokasCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'name': name,
      'order': order,
    };
  }

  Chapter copyWith({
    int? id,
    int? bookId,
    String? name,
    int? order,
    int? slokasCount,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      order: order ?? this.order,
      slokasCount: slokasCount ?? this.slokasCount,
    );
  }
}

class ChapterInput {
  final int bookId;
  final String name;
  final int? order;

  ChapterInput({
    required this.bookId,
    required this.name,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'name': name,
      if (order != null) 'order': order,
    };
  }
}
