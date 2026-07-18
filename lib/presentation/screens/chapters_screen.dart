import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/book_model.dart';
import '../../data/models/chapter_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class ChaptersScreen extends ConsumerStatefulWidget {
  const ChaptersScreen({super.key});

  @override
  ConsumerState<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends ConsumerState<ChaptersScreen> {
  int? _selectedBookId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booksAsync = ref.watch(allBooksProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuChapters,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Book filter
              booksAsync.when(
                data: (books) => _BookFilter(
                  books: books,
                  selectedId: _selectedBookId,
                  onChanged: (id) => setState(() => _selectedBookId = id),
                ),
                loading: () => const SizedBox(width: 200),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addChapter,
                icon: Icons.add,
                onPressed: _selectedBookId != null
                    ? () => _showChapterDialog(context, ref)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: _selectedBookId == null
                ? Center(
                    child: Text(
                      l10n.selectBook,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Consumer(
                    builder: (context, ref, _) {
                      final chaptersAsync =
                          ref.watch(chaptersProvider(_selectedBookId!));
                      return chaptersAsync.when(
                        data: (chapters) => AdminTable<Chapter>(
                          columns: [
                            AdminTableColumn(
                              header: 'ID',
                              width: 60,
                              cellBuilder: (ch) => AdminTableCell('${ch.id}'),
                            ),
                            AdminTableColumn(
                              header: l10n.chapterOrder,
                              width: 80,
                              cellBuilder: (ch) =>
                                  AdminTableCell('${ch.order}'),
                            ),
                            AdminTableColumn(
                              header: l10n.chapterName,
                              flex: true,
                              cellBuilder: (ch) =>
                                  AdminTableCell(ch.name, bold: true),
                            ),
                            AdminTableColumn(
                              header: l10n.chapterSlokas,
                              width: 80,
                              cellBuilder: (ch) =>
                                  AdminTableCell('${ch.slokasCount}'),
                            ),
                            AdminTableColumn(
                              header: '',
                              width: 100,
                              cellBuilder: (ch) => AdminTableActions(
                                onEdit: () =>
                                    _showChapterDialog(context, ref, chapter: ch),
                                onDelete: () => _confirmDelete(context, ref, ch),
                              ),
                            ),
                          ],
                          data: chapters,
                          onRowTap: (ch) =>
                              _showChapterDialog(context, ref, chapter: ch),
                        ),
                        loading: () => const AdminTable<Chapter>(
                          columns: [],
                          data: [],
                          isLoading: true,
                        ),
                        error: (e, _) => Center(
                          child: Text('${l10n.error}: $e'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showChapterDialog(BuildContext context, WidgetRef ref,
      {Chapter? chapter}) async {
    final l10n = AppLocalizations.of(context);

    final nameController = TextEditingController(text: chapter?.name ?? '');
    final orderController =
        TextEditingController(text: chapter?.order.toString() ?? '1');

    await AdminFormDialog.show<Chapter>(
      context: context,
      title: chapter == null ? l10n.addChapter : l10n.editChapter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminTextField(
            label: l10n.chapterName,
            controller: nameController,
            required: true,
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: l10n.chapterOrder,
            controller: orderController,
            required: true,
          ),
        ],
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return chapter;
        }

        final client = ref.read(apiClientProvider);
        final input = ChapterInput(
          bookId: _selectedBookId!,
          name: nameController.text,
          order: int.tryParse(orderController.text) ?? 1,
        );

        if (chapter == null) {
          return await client!.createChapter(input);
        } else {
          return await client!.updateChapter(chapter.id, input);
        }
      },
    );

    ref.invalidate(chaptersProvider(_selectedBookId!));
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Chapter chapter) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteChapterConfirm),
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

    if (confirmed == true && _selectedBookId != null) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deleteChapter(chapter.id);
      }
      ref.invalidate(chaptersProvider(_selectedBookId!));
    }
  }
}

class _BookFilter extends StatelessWidget {
  final List<Book> books;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _BookFilter({
    required this.books,
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
          hint: Text(l10n.selectBook),
          items: books
              .map((book) => DropdownMenuItem(
                    value: book.id,
                    child: Text(
                      '${book.initials} — ${book.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
