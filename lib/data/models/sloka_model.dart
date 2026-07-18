class Vocabulary {
  final String text;
  final String translation;

  Vocabulary({
    required this.text,
    required this.translation,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      text: json['text'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'translation': translation,
    };
  }
}

class Sloka {
  final int id;
  final int chapterId;
  final String name;
  final String text;
  final String transcription;
  final String translation;
  final String comment;
  final int order;
  final String? audio;
  final String? audioSanskrit;
  final List<Vocabulary> vocabularies;

  Sloka({
    required this.id,
    required this.chapterId,
    required this.name,
    this.text = '',
    this.transcription = '',
    this.translation = '',
    this.comment = '',
    this.order = 0,
    this.audio,
    this.audioSanskrit,
    this.vocabularies = const [],
  });

  factory Sloka.fromJson(Map<String, dynamic> json) {
    return Sloka(
      id: json['id'] as int,
      chapterId: json['chapterId'] as int,
      name: json['name'] as String? ?? '',
      text: json['text'] as String? ?? '',
      transcription: json['transcription'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      audio: json['audio'] as String?,
      audioSanskrit: json['audioSanskrit'] as String?,
      vocabularies: (json['vocabularies'] as List<dynamic>?)
              ?.map((e) => Vocabulary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Creates Sloka from list response (without full details)
  factory Sloka.fromListJson(Map<String, dynamic> json) {
    return Sloka(
      id: json['id'] as int,
      chapterId: json['chapterId'] as int,
      name: json['name'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      audio: json['hasAudio'] == true ? 'audio' : null,
      audioSanskrit: json['hasAudioSanskrit'] == true ? 'audioSanskrit' : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'name': name,
      'text': text,
      'transcription': transcription,
      'translation': translation,
      'comment': comment,
      'order': order,
      if (audio != null) 'audio': audio,
      if (audioSanskrit != null) 'audioSanskrit': audioSanskrit,
      'vocabularies': vocabularies.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasAudio => audio != null && audio!.isNotEmpty;
  bool get hasAudioSanskrit => audioSanskrit != null && audioSanskrit!.isNotEmpty;
  int get audioCount => (hasAudio ? 1 : 0) + (hasAudioSanskrit ? 1 : 0);

  Sloka copyWith({
    int? id,
    int? chapterId,
    String? name,
    String? text,
    String? transcription,
    String? translation,
    String? comment,
    int? order,
    String? audio,
    String? audioSanskrit,
    List<Vocabulary>? vocabularies,
  }) {
    return Sloka(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      name: name ?? this.name,
      text: text ?? this.text,
      transcription: transcription ?? this.transcription,
      translation: translation ?? this.translation,
      comment: comment ?? this.comment,
      order: order ?? this.order,
      audio: audio ?? this.audio,
      audioSanskrit: audioSanskrit ?? this.audioSanskrit,
      vocabularies: vocabularies ?? this.vocabularies,
    );
  }
}

class SlokaInput {
  final int chapterId;
  final String name;
  final String text;
  final String transcription;
  final String translation;
  final String comment;
  final int? order;
  final String? audio;
  final String? audioSanskrit;
  final List<Vocabulary>? vocabularies;

  SlokaInput({
    required this.chapterId,
    required this.name,
    this.text = '',
    this.transcription = '',
    this.translation = '',
    this.comment = '',
    this.order,
    this.audio,
    this.audioSanskrit,
    this.vocabularies,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'name': name,
      'text': text,
      'transcription': transcription,
      'translation': translation,
      'comment': comment,
      if (order != null) 'order': order,
      if (audio != null) 'audio': audio,
      if (audioSanskrit != null) 'audioSanskrit': audioSanskrit,
      if (vocabularies != null)
        'vocabularies': vocabularies!.map((e) => e.toJson()).toList(),
    };
  }
}
