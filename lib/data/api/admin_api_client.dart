import 'dart:io';
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/language_model.dart';
import '../models/book_model.dart';
import '../models/chapter_model.dart';
import '../models/sloka_model.dart';
import '../models/quote_model.dart';
import '../models/device_model.dart';

class AdminApiClient {
  final Dio _dio;
  final String baseUrl;

  AdminApiClient(this.baseUrl, [String? authToken])
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Auth
  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return ApiResponse.fromJson(response.data, (data) => data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResponse(success: false, error: e.message ?? 'Login failed');
    }
  }

  // Languages
  Future<List<Language>> getLanguages() async {
    final response = await _dio.get('/languages');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load languages');
  }

  Future<Language> getLanguage(int id) async {
    final response = await _dio.get('/languages/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Language.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Language not found');
  }

  Future<Language> createLanguage(LanguageInput input) async {
    final response = await _dio.post('/languages', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Language.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create language');
  }

  Future<Language> updateLanguage(int id, LanguageInput input) async {
    final response = await _dio.put('/languages/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Language.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update language');
  }

  Future<void> deleteLanguage(int id) async {
    final response = await _dio.delete('/languages/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete language');
    }
  }

  // Books
  Future<List<Book>> getBooks({int? languageId}) async {
    final response = await _dio.get('/books', queryParameters: {
      if (languageId != null) 'languageId': languageId,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load books');
  }

  Future<Book> getBook(int id) async {
    final response = await _dio.get('/books/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Book.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Book not found');
  }

  Future<Book> createBook(BookInput input) async {
    final response = await _dio.post('/books', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Book.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create book');
  }

  Future<Book> updateBook(int id, BookInput input) async {
    final response = await _dio.put('/books/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Book.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update book');
  }

  Future<void> deleteBook(int id) async {
    final response = await _dio.delete('/books/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete book');
    }
  }

  // Chapters
  Future<List<Chapter>> getChapters(int bookId) async {
    final response = await _dio.get('/chapters', queryParameters: {'bookId': bookId});
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load chapters');
  }

  Future<Chapter> getChapter(int id) async {
    final response = await _dio.get('/chapters/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Chapter.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Chapter not found');
  }

  Future<Chapter> createChapter(ChapterInput input) async {
    final response = await _dio.post('/chapters', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Chapter.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create chapter');
  }

  Future<Chapter> updateChapter(int id, ChapterInput input) async {
    final response = await _dio.put('/chapters/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Chapter.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update chapter');
  }

  Future<void> deleteChapter(int id) async {
    final response = await _dio.delete('/chapters/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete chapter');
    }
  }

  Future<void> reorderChapters(int bookId, List<int> order) async {
    final response = await _dio.put('/chapters/reorder', data: {
      'bookId': bookId,
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder chapters');
    }
  }

  // Slokas
  Future<PaginatedResponse<Sloka>> getSlokas(int chapterId, {int page = 1, int limit = 20}) async {
    final response = await _dio.get('/slokas', queryParameters: {
      'chapterId': chapterId,
      'page': page,
      'limit': limit,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      final slokas = (apiResponse.data as List)
          .map((e) => Sloka.fromListJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResponse(
        data: slokas,
        pagination: apiResponse.pagination ?? Pagination(page: page, limit: limit, total: slokas.length),
      );
    }
    throw Exception(apiResponse.error ?? 'Failed to load slokas');
  }

  Future<Sloka> getSloka(int id) async {
    final response = await _dio.get('/slokas/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Sloka.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Sloka not found');
  }

  Future<Sloka> createSloka(SlokaInput input) async {
    final response = await _dio.post('/slokas', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Sloka.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create sloka');
  }

  Future<Sloka> updateSloka(int id, SlokaInput input) async {
    final response = await _dio.put('/slokas/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Sloka.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update sloka');
  }

  Future<void> deleteSloka(int id) async {
    final response = await _dio.delete('/slokas/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete sloka');
    }
  }

  Future<void> reorderSlokas(int chapterId, List<int> order) async {
    final response = await _dio.put('/slokas/reorder', data: {
      'chapterId': chapterId,
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder slokas');
    }
  }

  // Quotes
  Future<List<Quote>> getQuotes({int? languageId}) async {
    final response = await _dio.get('/quotes', queryParameters: {
      if (languageId != null) 'languageId': languageId,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load quotes');
  }

  Future<Quote> getQuote(int id) async {
    final response = await _dio.get('/quotes/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Quote.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Quote not found');
  }

  Future<Quote> createQuote(QuoteInput input) async {
    final response = await _dio.post('/quotes', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Quote.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create quote');
  }

  Future<Quote> updateQuote(int id, QuoteInput input) async {
    final response = await _dio.put('/quotes/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Quote.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update quote');
  }

  Future<void> deleteQuote(int id) async {
    final response = await _dio.delete('/quotes/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete quote');
    }
  }

  Future<void> setQuoteOfDay(int id) async {
    final response = await _dio.put('/quotes/$id/set-day');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to set quote of day');
    }
  }

  // Devices
  Future<PaginatedResponse<Device>> getDevices({String? platform, int page = 1, int limit = 50}) async {
    final response = await _dio.get('/devices', queryParameters: {
      if (platform != null) 'platform': platform,
      'page': page,
      'limit': limit,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      final devices = (apiResponse.data as List)
          .map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResponse(
        data: devices,
        pagination: apiResponse.pagination ?? Pagination(page: page, limit: limit, total: devices.length),
      );
    }
    throw Exception(apiResponse.error ?? 'Failed to load devices');
  }

  Future<DeviceStats> getDeviceStats() async {
    final response = await _dio.get('/devices/stats');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return DeviceStats.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to load device stats');
  }

  // Import
  Future<ImportResult> importXml(int bookId, File file) async {
    final formData = FormData.fromMap({
      'bookId': bookId,
      'file': await MultipartFile.fromFile(file.path, filename: 'book.xml'),
    });
    final response = await _dio.post('/import/xml', data: formData);
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return ImportResult.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Import failed');
  }

  // Files
  Future<String> uploadFile(File file, {String folder = 'uploads'}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'folder': folder,
    });
    final response = await _dio.post('/files/upload', data: formData);
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as Map<String, dynamic>)['url'] as String? ?? '';
    }
    throw Exception(apiResponse.error ?? 'Upload failed');
  }
}
