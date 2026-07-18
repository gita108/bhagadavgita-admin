import 'app_localizations.dart';

class AppLocalizationsRu implements AppLocalizations {
  @override String get appTitle => 'Бхагавад Гита';
  @override String get adminPanel => 'Панель администратора';
  @override String get login => 'Вход';
  @override String get logout => 'Выйти';
  @override String get save => 'Сохранить';
  @override String get cancel => 'Отмена';
  @override String get add => 'Добавить';
  @override String get edit => 'Изменить';
  @override String get delete => 'Удалить';
  @override String get confirm => 'Подтвердить';
  @override String get yes => 'Да';
  @override String get no => 'Нет';
  @override String get loading => 'Загрузка...';
  @override String get error => 'Ошибка';
  @override String get success => 'Успешно';
  @override String get rememberMe => 'Запомнить меня';

  @override String get email => 'Email';
  @override String get password => 'Пароль';
  @override String get loginButton => 'Войти';
  @override String get loginError => 'Неверный логин или пароль';

  @override String get menuBooks => 'Книги';
  @override String get menuChapters => 'Главы';
  @override String get menuSlokas => 'Шлоки';
  @override String get menuQuotes => 'Цитаты';
  @override String get menuLanguages => 'Языки';
  @override String get menuImport => 'Импорт';
  @override String get menuDevices => 'Устройства / Push';

  @override String get bookName => 'Название';
  @override String get bookInitials => 'Инициалы';
  @override String get bookLanguage => 'Язык';
  @override String get bookChapters => 'Глав';
  @override String get addBook => 'Добавить книгу';
  @override String get editBook => 'Редактировать книгу';
  @override String get deleteBookConfirm => 'Книга и все главы/шлоки будут удалены';

  @override String get chapterName => 'Название';
  @override String get chapterOrder => 'Порядок';
  @override String get chapterSlokas => 'Шлок';
  @override String get addChapter => 'Добавить главу';
  @override String get editChapter => 'Редактировать главу';
  @override String get deleteChapterConfirm => 'Глава и все шлоки будут удалены';
  @override String get selectBook => 'Выберите книгу';

  @override String get slokaNumber => 'Номер';
  @override String get slokaSanskrit => 'Санскрит';
  @override String get slokaTranscription => 'Транскрипция';
  @override String get slokaVocabulary => 'Пословный перевод (словарь)';
  @override String get slokaTranslation => 'Перевод';
  @override String get slokaComment => 'Комментарий';
  @override String get slokaOrder => 'Порядок';
  @override String get slokaAudioTranslation => 'Аудио — перевод';
  @override String get slokaAudioSanskrit => 'Аудио — санскрит';
  @override String get addSloka => 'Добавить шлоку';
  @override String get editSloka => 'редактирование';
  @override String get deleteSlokaConfirm => 'Шлока будет удалена';
  @override String get selectChapter => 'Выберите главу';
  @override String get audioFiles => 'файла';
  @override String get noAudio => 'нет';
  @override String get replaceFile => 'Заменить';
  @override String get notFilled => 'Не заполнено';

  @override String get quoteAuthor => 'Автор';
  @override String get quoteText => 'Текст';
  @override String get quoteOfDay => 'Цитата дня';
  @override String get addQuote => 'Добавить цитату';
  @override String get editQuote => 'Редактировать цитату';
  @override String get deleteQuoteConfirm => 'Цитата будет удалена';
  @override String get setAsQuoteOfDay => 'Сделать цитатой дня';

  @override String get languageName => 'Название';
  @override String get languageCode => 'Код';
  @override String get languageBooks => 'Книг';
  @override String get languageQuotes => 'Цитат';
  @override String get addLanguage => 'Добавить язык';
  @override String get editLanguage => 'Редактировать язык';
  @override String get deleteLanguageConfirm => 'Язык будет удален';
  @override String get cannotDeleteLanguage => 'Нельзя удалить язык с книгами или цитатами';

  @override String get importTitle => 'Импорт книги из XML';
  @override String get importSelectBook => 'Книга';
  @override String get importDragHint => 'Перетащите файл book.xml сюда';
  @override String get importOr => 'или';
  @override String get importSelectFile => 'Выбрать файл';
  @override String get importButton => 'Импортировать';
  @override String get importLog => 'Лог последнего импорта';
  @override String get importChapters => 'Глав';
  @override String get importSlokas => 'Шлок';
  @override String get importVocabularies => 'Словарь';
  @override String get importWarnings => 'Предупреждений';

  @override String get devicesTitle => 'Устройства / Push';
  @override String get devicesPushQuote => 'Push «Цитата дня»';
  @override String get devicesPushDescription => 'Ежедневно в 09:00 по часовому поясу устройства';
  @override String get devicesSendNow => 'Отправить сейчас';
  @override String get devicesTotal => 'Всего устройств';
  @override String get devicesActive30 => 'активных за 30 дней';
  @override String get devicesToken => 'Токен';
  @override String get devicesPlatform => 'Платформа';
  @override String get devicesLanguage => 'Язык';
  @override String get devicesLastActivity => 'Последняя активность';
  @override String get devicesAllPlatforms => 'Все платформы';

  @override String get page => 'Страница';
  @override String get pageOf => 'из';
  @override String showing(int start, int end, int total) => 'Показано $start–$end из $total';

  @override String get dragFileHere => 'Перетащите файл сюда';
  @override String get orClickToSelect => 'или нажмите для выбора';
  @override String get allowedFormats => 'Допустимые форматы';

  @override String get confirmDeleteTitle => 'Подтверждение удаления';
  @override String confirmDeleteMessage(String item) => 'Удалить "$item"?';
}
