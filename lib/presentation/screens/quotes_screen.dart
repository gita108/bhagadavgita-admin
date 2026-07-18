import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/language_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class QuotesScreen extends ConsumerStatefulWidget {
  const QuotesScreen({super.key});

  @override
  ConsumerState<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends ConsumerState<QuotesScreen> {
  int? _selectedLanguageId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languagesAsync = ref.watch(languagesProvider);
    final quotesAsync = ref.watch(quotesProvider(_selectedLanguageId));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuQuotes,
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
                label: l10n.addQuote,
                icon: Icons.add,
                onPressed: () => _showQuoteDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: quotesAsync.when(
              data: (quotes) => AdminTable<Quote>(
                columns: [
                  AdminTableColumn(
                    header: 'ID',
                    width: 60,
                    cellBuilder: (q) => AdminTableCell('${q.id}'),
                  ),
                  AdminTableColumn(
                    header: l10n.quoteAuthor,
                    width: 150,
                    cellBuilder: (q) => AdminTableCell(q.author, bold: true),
                  ),
                  AdminTableColumn(
                    header: l10n.quoteText,
                    flex: true,
                    cellBuilder: (q) => AdminTableCell(
                      q.text.length > 100
                          ? '${q.text.substring(0, 100)}...'
                          : q.text,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.bookLanguage,
                    width: 100,
                    cellBuilder: (q) => AdminTableCell(
                      q.language?.name ?? '—',
                      secondary: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.quoteOfDay,
                    width: 100,
                    cellBuilder: (q) => _QuoteOfDayBadge(isDay: q.isDay),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (q) => AdminTableActions(
                      onEdit: () => _showQuoteDialog(context, ref, quote: q),
                      onDelete: () => _confirmDelete(context, ref, q),
                    ),
                  ),
                ],
                data: quotes,
                onRowTap: (q) => _showQuoteDialog(context, ref, quote: q),
              ),
              loading: () => const AdminTable<Quote>(
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

  Future<void> _showQuoteDialog(BuildContext context, WidgetRef ref,
      {Quote? quote}) async {
    final l10n = AppLocalizations.of(context);
    final languages = await ref.read(languagesProvider.future);

    final authorController = TextEditingController(text: quote?.author ?? '');
    final textController = TextEditingController(text: quote?.text ?? '');
    int? languageId = quote?.languageId ?? languages.firstOrNull?.id;
    bool isDay = quote?.isDay ?? false;

    if (!context.mounted) return;

    await AdminFormDialog.show<Quote>(
      context: context,
      title: quote == null ? l10n.addQuote : l10n.editQuote,
      width: 600,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(height: 16),
            AdminTextField(
              label: l10n.quoteAuthor,
              controller: authorController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: l10n.quoteText,
              controller: textController,
              required: true,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            AdminCheckbox(
              label: l10n.setAsQuoteOfDay,
              value: isDay,
              onChanged: (v) => setState(() => isDay = v ?? false),
            ),
          ],
        ),
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return quote;
        }

        final client = ref.read(apiClientProvider);
        final input = QuoteInput(
          languageId: languageId!,
          author: authorController.text,
          text: textController.text,
          isDay: isDay,
        );

        if (quote == null) {
          return await client!.createQuote(input);
        } else {
          return await client!.updateQuote(quote.id, input);
        }
      },
    );

    ref.invalidate(quotesProvider);
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Quote quote) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteQuoteConfirm),
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
        await client!.deleteQuote(quote.id);
      }
      ref.invalidate(quotesProvider);
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

class _QuoteOfDayBadge extends StatelessWidget {
  final bool isDay;

  const _QuoteOfDayBadge({required this.isDay});

  @override
  Widget build(BuildContext context) {
    if (!isDay) {
      return const Text(
        '—',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: AppColors.success),
          SizedBox(width: 4),
          Text(
            'День',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
