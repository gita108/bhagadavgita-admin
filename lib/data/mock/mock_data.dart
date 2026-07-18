import '../models/language_model.dart';
import '../models/book_model.dart';
import '../models/chapter_model.dart';
import '../models/sloka_model.dart';
import '../models/quote_model.dart';
import '../models/device_model.dart';
import '../models/api_response.dart';

class MockData {
  static final languages = [
    Language(id: 1, name: 'English', code: 'en', booksCount: 3, quotesCount: 66),
    Language(id: 2, name: 'Русский', code: 'ru', booksCount: 1, quotesCount: 46),
    Language(id: 3, name: 'Deutsch', code: 'de', booksCount: 1, quotesCount: 4),
    Language(id: 5, name: 'Español', code: 'spa', booksCount: 1, quotesCount: 0),
  ];

  static final books = [
    Book(
      id: 1,
      languageId: 2,
      name: 'Бхагавад Гита Жемчужина мудрости Востока',
      initials: 'ШМ',
      chaptersCount: 18,
      language: languages[1],
    ),
    Book(
      id: 2,
      languageId: 1,
      name: 'Bhagavad-gītā. The Hidden Treasure of the Sweet Absolute',
      initials: 'SM',
      chaptersCount: 18,
      language: languages[0],
    ),
    Book(
      id: 5,
      languageId: 1,
      name: 'Visvanath Cakravarti Thakur commentary',
      initials: 'VC',
      chaptersCount: 18,
      language: languages[0],
    ),
  ];

  static List<Chapter> getChapters(int bookId) {
    return [
      Chapter(id: 1, bookId: bookId, name: 'Осмотр Армий', order: 1, slokasCount: 47),
      Chapter(id: 2, bookId: bookId, name: 'Душа в мире материи', order: 2, slokasCount: 72),
      Chapter(id: 3, bookId: bookId, name: 'Йога деятельности', order: 3, slokasCount: 43),
      Chapter(id: 4, bookId: bookId, name: 'Йога обретения духовного знания', order: 4, slokasCount: 42),
    ];
  }

  static PaginatedResponse<Sloka> getSlokas(int chapterId, {int page = 1, int limit = 20}) {
    final allSlokas = List.generate(
      47,
      (i) => Sloka(
        id: i + 1,
        chapterId: chapterId,
        name: '1.${i + 1}',
        translation: 'Перевод шлоки ${i + 1}...',
        order: i + 1,
        audio: i < 5 ? 'audio.mp3' : null,
        audioSanskrit: i < 5 ? 'sanskrit.mp3' : null,
      ),
    );

    final start = (page - 1) * limit;
    final end = start + limit > allSlokas.length ? allSlokas.length : start + limit;
    final pageSlokas = allSlokas.sublist(start, end);

    return PaginatedResponse(
      data: pageSlokas,
      pagination: Pagination(page: page, limit: limit, total: allSlokas.length),
    );
  }

  static Sloka getSloka(int id) {
    return Sloka(
      id: id,
      chapterId: 1,
      name: '1.$id',
      text: 'धृतराष्ट्र उवाच ।\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।',
      transcription: 'дхр̣тара̄ш̣т̣ра ува̄ча\nдхарма-кш̣етре куру-кш̣етре...',
      translation: 'Дхритараштра сказал:\nСанджая! Что произошло...',
      comment: 'Комментарий к шлоке...',
      order: id,
      audio: 'audio.mp3',
      audioSanskrit: 'sanskrit.mp3',
      vocabularies: [
        Vocabulary(text: 'дхр̣тара̄ш̣т̣рах̣ ува̄ча', translation: 'Дхр̣тара̄ш̣т̣ра сказал'),
        Vocabulary(text: 'дхарма-кш̣етре', translation: 'на священной земле'),
      ],
    );
  }

  static final quotes = [
    Quote(
      id: 1,
      languageId: 2,
      author: 'Bhagavad Gita',
      text: 'Желая воодушевить Дурьодхану, Бхишма, старейшина династии Куру...',
      isDay: true,
      language: languages[1],
    ),
    Quote(
      id: 2,
      languageId: 2,
      author: 'Bhagavad Gita',
      text: 'Громоподобный звук этих раковин, раскатившись эхом по земле и небу...',
      isDay: false,
      language: languages[1],
    ),
    Quote(
      id: 3,
      languageId: 1,
      author: 'Bhagavad Gita',
      text: 'Know that all species, either moving or stationary...',
      isDay: false,
      language: languages[0],
    ),
  ];

  static final deviceStats = DeviceStats(
    total: 12480,
    active30days: 3214,
    byPlatform: {'android': 6000, 'ios': 5000, 'windows': 1480},
  );

  static PaginatedResponse<Device> getDevices({String? platform, int page = 1, int limit = 50}) {
    final allDevices = [
      Device(id: 1, platform: 1, platformName: 'ios', culture: 'ru', lastModified: DateTime.now(), pushToken: 'dK4x...f9Qz'),
      Device(id: 2, platform: 0, platformName: 'android', culture: 'en', lastModified: DateTime.now(), pushToken: 'eR7m...a2Lp'),
      Device(id: 3, platform: 2, platformName: 'windows', culture: 'ru', lastModified: DateTime.now().subtract(const Duration(days: 1)), pushToken: 'tG1c...x8Wd'),
      Device(id: 4, platform: 1, platformName: 'ios', culture: 'de', lastModified: DateTime.now().subtract(const Duration(days: 3)), pushToken: 'hV9s...k3Nb'),
    ];

    final filtered = platform != null
        ? allDevices.where((d) => d.platformName == platform).toList()
        : allDevices;

    return PaginatedResponse(
      data: filtered,
      pagination: Pagination(page: page, limit: limit, total: filtered.length),
    );
  }

  static final importResult = ImportResult(
    chapters: 18,
    slokas: 700,
    vocabularies: 6480,
    warnings: ['Пустой комментарий у 1.7', 'Пустой комментарий у 1.28'],
  );
}
