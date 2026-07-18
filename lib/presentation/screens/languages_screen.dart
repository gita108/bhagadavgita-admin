import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/language_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class LanguagesScreen extends ConsumerWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languagesAsync = ref.watch(languagesProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuLanguages,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addLanguage,
                icon: Icons.add,
                onPressed: () => _showLanguageDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: languagesAsync.when(
              data: (languages) => AdminTable<Language>(
                columns: [
                  AdminTableColumn(
                    header: 'ID',
                    width: 60,
                    cellBuilder: (lang) => AdminTableCell('${lang.id}'),
                  ),
                  AdminTableColumn(
                    header: l10n.languageName,
                    flex: true,
                    cellBuilder: (lang) => AdminTableCell(lang.name, bold: true),
                  ),
                  AdminTableColumn(
                    header: l10n.languageCode,
                    width: 100,
                    cellBuilder: (lang) => AdminTableCell(lang.code),
                  ),
                  AdminTableColumn(
                    header: l10n.languageBooks,
                    width: 80,
                    cellBuilder: (lang) => AdminTableCell('${lang.booksCount}'),
                  ),
                  AdminTableColumn(
                    header: l10n.languageQuotes,
                    width: 80,
                    cellBuilder: (lang) => AdminTableCell('${lang.quotesCount}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (lang) => AdminTableActions(
                      onEdit: () => _showLanguageDialog(context, ref, language: lang),
                      onDelete: lang.booksCount == 0 && lang.quotesCount == 0
                          ? () => _confirmDelete(context, ref, lang)
                          : null,
                    ),
                  ),
                ],
                data: languages,
                onRowTap: (lang) => _showLanguageDialog(context, ref, language: lang),
              ),
              loading: () => const AdminTable<Language>(
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

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref,
      {Language? language}) async {
    final l10n = AppLocalizations.of(context);

    final nameController = TextEditingController(text: language?.name ?? '');
    final codeController = TextEditingController(text: language?.code ?? '');

    await AdminFormDialog.show<Language>(
      context: context,
      title: language == null ? l10n.addLanguage : l10n.editLanguage,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminTextField(
            label: l10n.languageName,
            controller: nameController,
            required: true,
            hint: 'e.g., English, Русский',
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: l10n.languageCode,
            controller: codeController,
            required: true,
            hint: 'e.g., en, ru, de',
          ),
        ],
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return language;
        }

        final client = ref.read(apiClientProvider);
        final input = LanguageInput(
          name: nameController.text,
          code: codeController.text,
        );

        if (language == null) {
          return await client!.createLanguage(input);
        } else {
          return await client!.updateLanguage(language.id, input);
        }
      },
    );

    ref.invalidate(languagesProvider);
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Language language) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteLanguageConfirm),
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
        await client!.deleteLanguage(language.id);
      }
      ref.invalidate(languagesProvider);
    }
  }
}
