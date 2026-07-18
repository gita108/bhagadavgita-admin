import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/book_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/sloka_model.dart';
import '../providers/data_providers.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_pagination.dart';

class SlokasScreen extends ConsumerStatefulWidget {
  const SlokasScreen({super.key});

  @override
  ConsumerState<SlokasScreen> createState() => _SlokasScreenState();
}

class _SlokasScreenState extends ConsumerState<SlokasScreen> {
  int? _selectedBookId;
  int? _selectedChapterId;
  int _currentPage = 1;
  static const _itemsPerPage = 20;

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
                l10n.menuSlokas,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Book filter
              booksAsync.when(
                data: (books) => _BookDropdown(
                  books: books,
                  selectedId: _selectedBookId,
                  onChanged: (id) => setState(() {
                    _selectedBookId = id;
                    _selectedChapterId = null;
                    _currentPage = 1;
                  }),
                ),
                loading: () => const SizedBox(width: 200),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 12),
              // Chapter filter
              if (_selectedBookId != null)
                Consumer(
                  builder: (context, ref, _) {
                    final chaptersAsync =
                        ref.watch(chaptersProvider(_selectedBookId!));
                    return chaptersAsync.when(
                      data: (chapters) => _ChapterDropdown(
                        chapters: chapters,
                        selectedId: _selectedChapterId,
                        onChanged: (id) => setState(() {
                          _selectedChapterId = id;
                          _currentPage = 1;
                        }),
                      ),
                      loading: () => const SizedBox(width: 150),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addSloka,
                icon: Icons.add,
                onPressed: _selectedChapterId != null
                    ? () => context.go('/slokas/new?chapterId=$_selectedChapterId')
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content
          Expanded(
            child: _selectedChapterId == null
                ? Center(
                    child: Text(
                      l10n.selectChapter,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Consumer(
                    builder: (context, ref, _) {
                      final query = SlokaQuery(
                        chapterId: _selectedChapterId!,
                        page: _currentPage,
                        limit: _itemsPerPage,
                      );
                      final slokasAsync = ref.watch(slokasProvider(query));

                      return slokasAsync.when(
                        data: (response) => Column(
                          children: [
                            Expanded(
                              child: AdminTable<Sloka>(
                                columns: [
                                  AdminTableColumn(
                                    header: 'ID',
                                    width: 60,
                                    cellBuilder: (s) =>
                                        AdminTableCell('${s.id}'),
                                  ),
                                  AdminTableColumn(
                                    header: l10n.slokaNumber,
                                    width: 80,
                                    cellBuilder: (s) =>
                                        AdminTableCell(s.name, bold: true),
                                  ),
                                  AdminTableColumn(
                                    header: l10n.slokaTranslation,
                                    flex: true,
                                    cellBuilder: (s) => AdminTableCell(
                                      s.translation ?? l10n.notFilled,
                                      secondary: s.translation == null,
                                    ),
                                  ),
                                  AdminTableColumn(
                                    header: l10n.audioFiles,
                                    width: 80,
                                    cellBuilder: (s) => _AudioIndicator(
                                      hasTranslation: s.audio != null,
                                      hasSanskrit: s.audioSanskrit != null,
                                    ),
                                  ),
                                  AdminTableColumn(
                                    header: '',
                                    width: 60,
                                    cellBuilder: (s) => IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      onPressed: () =>
                                          context.go('/slokas/${s.id}'),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                                data: response.data,
                                onRowTap: (s) => context.go('/slokas/${s.id}'),
                              ),
                            ),
                            AdminPagination(
                              currentPage: response.pagination.page,
                              totalPages: response.pagination.totalPages,
                              totalItems: response.pagination.total,
                              itemsPerPage: response.pagination.limit,
                              onPageChanged: (page) =>
                                  setState(() => _currentPage = page),
                            ),
                          ],
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
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
}

class _BookDropdown extends StatelessWidget {
  final List<Book> books;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _BookDropdown({
    required this.books,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedId,
          isExpanded: true,
          hint: Text(l10n.selectBook),
          items: books
              .map((book) => DropdownMenuItem(
                    value: book.id,
                    child: Text(
                      book.initials,
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

class _ChapterDropdown extends StatelessWidget {
  final List<Chapter> chapters;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _ChapterDropdown({
    required this.chapters,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedId,
          isExpanded: true,
          hint: Text(l10n.selectChapter),
          items: chapters
              .map((ch) => DropdownMenuItem(
                    value: ch.id,
                    child: Text('${ch.order}. ${ch.name}'),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _AudioIndicator extends StatelessWidget {
  final bool hasTranslation;
  final bool hasSanskrit;

  const _AudioIndicator({
    required this.hasTranslation,
    required this.hasSanskrit,
  });

  @override
  Widget build(BuildContext context) {
    final count = (hasTranslation ? 1 : 0) + (hasSanskrit ? 1 : 0);

    if (count == 0) {
      return const Text(
        '—',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.audiotrack,
          size: 16,
          color: count == 2 ? AppColors.success : AppColors.warning,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            color: count == 2 ? AppColors.success : AppColors.warning,
          ),
        ),
      ],
    );
  }
}
