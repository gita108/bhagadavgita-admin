import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/admin_api_client.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/api_response.dart';
import '../../data/models/language_model.dart';
import '../../data/models/book_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/sloka_model.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/device_model.dart';
import 'auth_provider.dart';

// API Client provider
final apiClientProvider = Provider<AdminApiClient?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config == null || config.isMockMode) return null;
  return AdminApiClient(config.apiUrl!, config.authToken);
});

// Languages
final languagesProvider = FutureProvider<List<Language>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.languages;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getLanguages();
});

// Books
final booksProvider = FutureProvider.family<List<Book>, int?>((ref, languageId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    if (languageId == null) return MockData.books;
    return MockData.books.where((b) => b.languageId == languageId).toList();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getBooks(languageId: languageId);
});

final allBooksProvider = FutureProvider<List<Book>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.books;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getBooks();
});

// Chapters
final chaptersProvider = FutureProvider.family<List<Chapter>, int>((ref, bookId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getChapters(bookId);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getChapters(bookId);
});

// Slokas query
class SlokaQuery {
  final int chapterId;
  final int page;
  final int limit;

  SlokaQuery({required this.chapterId, this.page = 1, this.limit = 20});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlokaQuery &&
          runtimeType == other.runtimeType &&
          chapterId == other.chapterId &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => chapterId.hashCode ^ page.hashCode ^ limit.hashCode;
}

final slokasProvider = FutureProvider.family<PaginatedResponse<Sloka>, SlokaQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getSlokas(query.chapterId, page: query.page, limit: query.limit);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getSlokas(query.chapterId, page: query.page, limit: query.limit);
});

final slokaDetailProvider = FutureProvider.family<Sloka, int>((ref, id) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getSloka(id);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getSloka(id);
});

// Quotes
final quotesProvider = FutureProvider.family<List<Quote>, int?>((ref, languageId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    if (languageId == null) return MockData.quotes;
    return MockData.quotes.where((q) => q.languageId == languageId).toList();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getQuotes(languageId: languageId);
});

// Devices
class DeviceQuery {
  final String? platform;
  final int page;
  final int limit;

  DeviceQuery({this.platform, this.page = 1, this.limit = 50});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceQuery &&
          runtimeType == other.runtimeType &&
          platform == other.platform &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => (platform?.hashCode ?? 0) ^ page.hashCode ^ limit.hashCode;
}

final devicesProvider = FutureProvider.family<PaginatedResponse<Device>, DeviceQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getDevices(platform: query.platform, page: query.page, limit: query.limit);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getDevices(platform: query.platform, page: query.page, limit: query.limit);
});

final deviceStatsProvider = FutureProvider<DeviceStats>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.deviceStats;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getDeviceStats();
});

// Selected filters state
final selectedBookIdProvider = StateProvider<int?>((ref) => null);
final selectedChapterIdProvider = StateProvider<int?>((ref) => null);
final selectedLanguageIdProvider = StateProvider<int?>((ref) => null);
