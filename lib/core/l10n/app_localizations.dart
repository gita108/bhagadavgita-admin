import 'package:flutter/material.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ru'),
    Locale('en'),
  ];

  // General
  String get appTitle;
  String get adminPanel;
  String get login;
  String get logout;
  String get save;
  String get cancel;
  String get add;
  String get edit;
  String get delete;
  String get confirm;
  String get yes;
  String get no;
  String get loading;
  String get error;
  String get success;
  String get rememberMe;

  // Login
  String get email;
  String get password;
  String get loginButton;
  String get loginError;

  // Menu
  String get menuBooks;
  String get menuChapters;
  String get menuSlokas;
  String get menuQuotes;
  String get menuLanguages;
  String get menuImport;
  String get menuDevices;

  // Books
  String get bookName;
  String get bookInitials;
  String get bookLanguage;
  String get bookChapters;
  String get addBook;
  String get editBook;
  String get deleteBookConfirm;

  // Chapters
  String get chapterName;
  String get chapterOrder;
  String get chapterSlokas;
  String get addChapter;
  String get editChapter;
  String get deleteChapterConfirm;
  String get selectBook;

  // Slokas
  String get slokaNumber;
  String get slokaSanskrit;
  String get slokaTranscription;
  String get slokaVocabulary;
  String get slokaTranslation;
  String get slokaComment;
  String get slokaOrder;
  String get slokaAudioTranslation;
  String get slokaAudioSanskrit;
  String get addSloka;
  String get editSloka;
  String get deleteSlokaConfirm;
  String get selectChapter;
  String get audioFiles;
  String get noAudio;
  String get replaceFile;
  String get notFilled;

  // Quotes
  String get quoteAuthor;
  String get quoteText;
  String get quoteOfDay;
  String get addQuote;
  String get editQuote;
  String get deleteQuoteConfirm;
  String get setAsQuoteOfDay;

  // Languages
  String get languageName;
  String get languageCode;
  String get languageBooks;
  String get languageQuotes;
  String get addLanguage;
  String get editLanguage;
  String get deleteLanguageConfirm;
  String get cannotDeleteLanguage;

  // Import
  String get importTitle;
  String get importSelectBook;
  String get importDragHint;
  String get importOr;
  String get importSelectFile;
  String get importButton;
  String get importLog;
  String get importChapters;
  String get importSlokas;
  String get importVocabularies;
  String get importWarnings;

  // Devices
  String get devicesTitle;
  String get devicesPushQuote;
  String get devicesPushDescription;
  String get devicesSendNow;
  String get devicesTotal;
  String get devicesActive30;
  String get devicesToken;
  String get devicesPlatform;
  String get devicesLanguage;
  String get devicesLastActivity;
  String get devicesAllPlatforms;

  // Pagination
  String get page;
  String get pageOf;
  String showing(int start, int end, int total);

  // File drop zone
  String get dragFileHere;
  String get orClickToSelect;
  String get allowedFormats;

  // Confirm dialog
  String get confirmDeleteTitle;
  String confirmDeleteMessage(String item);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ru', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'ru':
      default:
        return AppLocalizationsRu();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
