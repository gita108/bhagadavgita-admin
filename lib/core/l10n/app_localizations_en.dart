import 'app_localizations.dart';

class AppLocalizationsEn implements AppLocalizations {
  @override String get appTitle => 'Bhagavad Gita';
  @override String get adminPanel => 'Admin Panel';
  @override String get login => 'Login';
  @override String get logout => 'Logout';
  @override String get save => 'Save';
  @override String get cancel => 'Cancel';
  @override String get add => 'Add';
  @override String get edit => 'Edit';
  @override String get delete => 'Delete';
  @override String get confirm => 'Confirm';
  @override String get yes => 'Yes';
  @override String get no => 'No';
  @override String get loading => 'Loading...';
  @override String get error => 'Error';
  @override String get success => 'Success';
  @override String get rememberMe => 'Remember me';

  @override String get email => 'Email';
  @override String get password => 'Password';
  @override String get loginButton => 'Login';
  @override String get loginError => 'Invalid email or password';

  @override String get menuBooks => 'Books';
  @override String get menuChapters => 'Chapters';
  @override String get menuSlokas => 'Slokas';
  @override String get menuQuotes => 'Quotes';
  @override String get menuLanguages => 'Languages';
  @override String get menuImport => 'Import';
  @override String get menuDevices => 'Devices / Push';

  @override String get bookName => 'Name';
  @override String get bookInitials => 'Initials';
  @override String get bookLanguage => 'Language';
  @override String get bookChapters => 'Chapters';
  @override String get addBook => 'Add book';
  @override String get editBook => 'Edit book';
  @override String get deleteBookConfirm => 'Book and all chapters/slokas will be deleted';

  @override String get chapterName => 'Name';
  @override String get chapterOrder => 'Order';
  @override String get chapterSlokas => 'Slokas';
  @override String get addChapter => 'Add chapter';
  @override String get editChapter => 'Edit chapter';
  @override String get deleteChapterConfirm => 'Chapter and all slokas will be deleted';
  @override String get selectBook => 'Select book';

  @override String get slokaNumber => 'Number';
  @override String get slokaSanskrit => 'Sanskrit';
  @override String get slokaTranscription => 'Transcription';
  @override String get slokaVocabulary => 'Word-by-word translation';
  @override String get slokaTranslation => 'Translation';
  @override String get slokaComment => 'Commentary';
  @override String get slokaOrder => 'Order';
  @override String get slokaAudioTranslation => 'Audio — translation';
  @override String get slokaAudioSanskrit => 'Audio — Sanskrit';
  @override String get addSloka => 'Add sloka';
  @override String get editSloka => 'editing';
  @override String get deleteSlokaConfirm => 'Sloka will be deleted';
  @override String get selectChapter => 'Select chapter';
  @override String get audioFiles => 'files';
  @override String get noAudio => 'none';
  @override String get replaceFile => 'Replace';
  @override String get notFilled => 'Not filled';

  @override String get quoteAuthor => 'Author';
  @override String get quoteText => 'Text';
  @override String get quoteOfDay => 'Quote of the day';
  @override String get addQuote => 'Add quote';
  @override String get editQuote => 'Edit quote';
  @override String get deleteQuoteConfirm => 'Quote will be deleted';
  @override String get setAsQuoteOfDay => 'Set as quote of the day';

  @override String get languageName => 'Name';
  @override String get languageCode => 'Code';
  @override String get languageBooks => 'Books';
  @override String get languageQuotes => 'Quotes';
  @override String get addLanguage => 'Add language';
  @override String get editLanguage => 'Edit language';
  @override String get deleteLanguageConfirm => 'Language will be deleted';
  @override String get cannotDeleteLanguage => 'Cannot delete language with books or quotes';

  @override String get importTitle => 'Import book from XML';
  @override String get importSelectBook => 'Book';
  @override String get importDragHint => 'Drop book.xml file here';
  @override String get importOr => 'or';
  @override String get importSelectFile => 'Select file';
  @override String get importButton => 'Import';
  @override String get importLog => 'Last import log';
  @override String get importChapters => 'Chapters';
  @override String get importSlokas => 'Slokas';
  @override String get importVocabularies => 'Vocabulary';
  @override String get importWarnings => 'Warnings';

  @override String get devicesTitle => 'Devices / Push';
  @override String get devicesPushQuote => 'Push "Quote of the day"';
  @override String get devicesPushDescription => 'Daily at 09:00 in device timezone';
  @override String get devicesSendNow => 'Send now';
  @override String get devicesTotal => 'Total devices';
  @override String get devicesActive30 => 'active in 30 days';
  @override String get devicesToken => 'Token';
  @override String get devicesPlatform => 'Platform';
  @override String get devicesLanguage => 'Language';
  @override String get devicesLastActivity => 'Last activity';
  @override String get devicesAllPlatforms => 'All platforms';

  @override String get page => 'Page';
  @override String get pageOf => 'of';
  @override String showing(int start, int end, int total) => 'Showing $start–$end of $total';

  @override String get dragFileHere => 'Drop file here';
  @override String get orClickToSelect => 'or click to select';
  @override String get allowedFormats => 'Allowed formats';

  @override String get confirmDeleteTitle => 'Confirm deletion';
  @override String confirmDeleteMessage(String item) => 'Delete "$item"?';
}
