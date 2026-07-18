import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/book_model.dart';
import '../../data/models/language_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  int? _selectedLanguageId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languagesAsync = ref.watch(languagesProvider);
    final booksAsync = ref.watch(booksProvider(_selectedLanguageId));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuBooks,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Language filter
              languagesAsync.when(
                data: (languages) => _LanguageFilter(
                  languages: languages,
                  selectedId: _selectedLanguageId,
                  onChanged: (id) => setState(() => _selectedLanguageId = id),
                ),
                loading: () => const SizedBox(width: 150),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addBook,
                icon: Icons.add,
                onPressed: () => _showBookDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: booksAsync.when(
              data: (books) => AdminTable<Book>(
                columns: [
                  AdminTableColumn(
                    header: 'ID',
                    width: 60,
                    cellBuilder: (book) => AdminTableCell('${book.id}'),
                  ),
                  AdminTableColumn(
                    header: l10n.bookName,
                    flex: true,
                    cellBuilder: (book) => AdminTableCell(book.name, bold: true),
                  ),
                  AdminTableColumn(
                    header: l10n.bookInitials,
                    width: 80,
                    cellBuilder: (book) => AdminTableCell(book.initials),
                  ),
                  AdminTableColumn(
                    header: l10n.bookLanguage,
                    width: 120,
                    cellBuilder: (book) => AdminTableCell(
                      book.language?.name ?? '—',
                      secondary: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.bookChapters,
                    width: 80,
                    cellBuilder: (book) => AdminTableCell('${book.chaptersCount}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (book) => AdminTableActions(
                      onEdit: () => _showBookDialog(context, ref, book: book),
                      onDelete: () => _confirmDelete(context, ref, book),
                    ),
                  ),
                ],
                data: books,
                onRowTap: (book) => _showBookDialog(context, ref, book: book),
              ),
              loading: () => const AdminTable<Book>(
                columns: [],
                data: [],
                isLoading: true,
              ),
              error: (e, _) => Center(
                child: Text('${l10n.error}: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBookDialog(BuildContext context, WidgetRef ref, {Book? book}) async {
    final l10n = AppLocalizations.of(context);
    final languages = await ref.read(languagesProvider.future);

    final nameController = TextEditingController(text: book?.name ?? '');
    final initialsController = TextEditingController(text: book?.initials ?? '');
    int? languageId = book?.languageId ?? languages.firstOrNull?.id;

    if (!context.mounted) return;

    await AdminFormDialog.show<Book>(
      context: context,
      title: book == null ? l10n.addBook : l10n.editBook,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminTextField(
              label: l10n.bookName,
              controller: nameController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: l10n.bookInitials,
              controller: initialsController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminDropdown<int>(
              label: l10n.bookLanguage,
              value: languageId,
              required: true,
              items: languages
                  .map((lang) => DropdownMenuItem(
                        value: lang.id,
                        child: Text(lang.name),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => languageId = v),
            ),
          ],
        ),
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          // Mock mode - just return
          return book;
        }

        final client = ref.read(apiClientProvider);
        final input = BookInput(
          name: nameController.text,
          initials: initialsController.text,
          languageId: languageId!,
        );

        if (book == null) {
          return await client!.createBook(input);
        } else {
          return await client!.updateBook(book.id, input);
        }
      },
    );

    ref.invalidate(booksProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Book book) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteBookConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deleteBook(book.id);
      }
      ref.invalidate(booksProvider);
    }
  }
}

class _LanguageFilter extends StatelessWidget {
  final List<Language> languages;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _LanguageFilter({
    required this.languages,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedId,
          hint: Text(l10n.bookLanguage),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text('${l10n.bookLanguage}: все'),
            ),
            ...languages.map((lang) => DropdownMenuItem(
                  value: lang.id,
                  child: Text(lang.name),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
