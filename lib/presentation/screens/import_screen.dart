import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/book_model.dart';
import '../../data/models/device_model.dart';
import '../../data/mock/mock_data.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_file_drop_zone.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  int? _selectedBookId;
  PlatformFile? _selectedFile;
  bool _isImporting = false;
  ImportResult? _lastResult;

  Future<void> _handleImport() async {
    if (_selectedBookId == null || _selectedFile == null) return;

    setState(() => _isImporting = true);

    try {
      final config = ref.read(appConfigProvider);

      if (config?.isMockMode ?? true) {
        // Simulate import delay
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _lastResult = MockData.importResult;
        });
      } else {
        final client = ref.read(apiClientProvider);
        final result = await client!.importBook(_selectedBookId!, _selectedFile!);
        setState(() {
          _lastResult = result;
        });
      }

      // Refresh data
      ref.invalidate(chaptersProvider);
      ref.invalidate(slokasProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booksAsync = ref.watch(allBooksProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Import form
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.importTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                // Book selector
                Text(
                  l10n.importSelectBook,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                booksAsync.when(
                  data: (books) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: _selectedBookId,
                        isExpanded: true,
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
                        onChanged: (v) => setState(() => _selectedBookId = v),
                      ),
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('${l10n.error}: $e'),
                ),
                const SizedBox(height: 24),

                // File drop zone
                AdminFileDropZone(
                  allowedExtensions: ['xml'],
                  hint: l10n.importDragHint,
                  onFileSelected: (file) {
                    setState(() => _selectedFile = file);
                  },
                ),
                const SizedBox(height: 24),

                // Import button
                AdminButton.primary(
                  label: l10n.importButton,
                  icon: Icons.upload,
                  onPressed: _selectedBookId != null && _selectedFile != null
                      ? (_isImporting ? null : _handleImport)
                      : null,
                  isLoading: _isImporting,
                ),
              ],
            ),
          ),

          const SizedBox(width: 48),

          // Right side - Import log
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.importLog,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                if (_lastResult == null)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Результаты последнего импорта появятся здесь',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.success.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              l10n.success,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ImportStatRow(
                          label: l10n.importChapters,
                          value: _lastResult!.chapters,
                        ),
                        _ImportStatRow(
                          label: l10n.importSlokas,
                          value: _lastResult!.slokas,
                        ),
                        _ImportStatRow(
                          label: l10n.importVocabularies,
                          value: _lastResult!.vocabularies,
                        ),
                        if (_lastResult!.warnings.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.warning_amber,
                                  color: AppColors.warning, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                '${l10n.importWarnings}: ${_lastResult!.warnings.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...(_lastResult!.warnings.take(5).map(
                                (w) => Padding(
                                  padding: const EdgeInsets.only(left: 26, top: 4),
                                  child: Text(
                                    '• $w',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              )),
                          if (_lastResult!.warnings.length > 5)
                            Padding(
                              padding: const EdgeInsets.only(left: 26, top: 4),
                              child: Text(
                                '... и ещё ${_lastResult!.warnings.length - 5}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportStatRow extends StatelessWidget {
  final String label;
  final int value;

  const _ImportStatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
