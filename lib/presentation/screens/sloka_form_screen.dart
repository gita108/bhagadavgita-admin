import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/sloka_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class SlokaFormScreen extends ConsumerStatefulWidget {
  final int? slokaId;
  final int? chapterId;

  const SlokaFormScreen({
    super.key,
    this.slokaId,
    this.chapterId,
  });

  @override
  ConsumerState<SlokaFormScreen> createState() => _SlokaFormScreenState();
}

class _SlokaFormScreenState extends ConsumerState<SlokaFormScreen> {
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  final _transcriptionController = TextEditingController();
  final _translationController = TextEditingController();
  final _commentController = TextEditingController();
  final _orderController = TextEditingController();

  List<Vocabulary> _vocabularies = [];
  bool _isLoading = false;
  bool _isSaving = false;
  Sloka? _sloka;

  @override
  void initState() {
    super.initState();
    if (widget.slokaId != null) {
      _loadSloka();
    } else {
      _orderController.text = '1';
    }
  }

  Future<void> _loadSloka() async {
    setState(() => _isLoading = true);
    try {
      final sloka = await ref.read(slokaDetailProvider(widget.slokaId!).future);
      _sloka = sloka;
      _nameController.text = sloka.name;
      _textController.text = sloka.text;
      _transcriptionController.text = sloka.transcription;
      _translationController.text = sloka.translation;
      _commentController.text = sloka.comment;
      _orderController.text = sloka.order.toString();
      _vocabularies = List.from(sloka.vocabularies);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _textController.dispose();
    _transcriptionController.dispose();
    _translationController.dispose();
    _commentController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        final input = SlokaInput(
          chapterId: widget.chapterId ?? _sloka!.chapterId,
          name: _nameController.text,
          text: _textController.text,
          transcription: _transcriptionController.text,
          translation: _translationController.text,
          comment: _commentController.text,
          order: int.tryParse(_orderController.text) ?? 1,
          vocabularies: _vocabularies,
        );

        if (widget.slokaId == null) {
          await client!.createSloka(input);
        } else {
          await client!.updateSloka(widget.slokaId!, input);
        }
      }

      if (mounted) context.go('/slokas');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addVocabulary() {
    final textController = TextEditingController();
    final translationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить слово'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminTextField(
              label: 'Слово (санскрит)',
              controller: textController,
            ),
            const SizedBox(height: 12),
            AdminTextField(
              label: 'Перевод',
              controller: translationController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _vocabularies.add(Vocabulary(
                  text: textController.text,
                  translation: translationController.text,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNew = widget.slokaId == null;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/slokas'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew
                    ? l10n.addSloka
                    : '${_sloka?.name ?? ''} — ${l10n.editSloka}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/slokas'),
              ),
              const SizedBox(width: 12),
              AdminButton.primary(
                label: l10n.save,
                onPressed: _isSaving ? null : _handleSave,
                isLoading: _isSaving,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Form
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AdminTextField(
                            label: l10n.slokaNumber,
                            controller: _nameController,
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 100,
                          child: AdminTextField(
                            label: l10n.slokaOrder,
                            controller: _orderController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AdminTextField(
                      label: l10n.slokaSanskrit,
                      controller: _textController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    AdminTextField(
                      label: l10n.slokaTranscription,
                      controller: _transcriptionController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    AdminTextField(
                      label: l10n.slokaTranslation,
                      controller: _translationController,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 20),
                    AdminTextField(
                      label: l10n.slokaComment,
                      controller: _commentController,
                      maxLines: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),

              // Right column - Vocabulary & Audio
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vocabulary section
                    Row(
                      children: [
                        Text(
                          l10n.slokaVocabulary,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        AdminButton.text(
                          label: l10n.add,
                          icon: Icons.add,
                          onPressed: _addVocabulary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _vocabularies.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Нет слов',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: _vocabularies.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final vocab = _vocabularies[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    vocab.text,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(vocab.translation),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _vocabularies.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Audio section
                    Text(
                      l10n.audioFiles,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AudioFileRow(
                      label: l10n.slokaAudioTranslation,
                      fileName: _sloka?.audio,
                    ),
                    const SizedBox(height: 8),
                    _AudioFileRow(
                      label: l10n.slokaAudioSanskrit,
                      fileName: _sloka?.audioSanskrit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudioFileRow extends StatelessWidget {
  final String label;
  final String? fileName;

  const _AudioFileRow({
    required this.label,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            fileName != null ? Icons.audiotrack : Icons.audiotrack_outlined,
            size: 18,
            color: fileName != null ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  fileName ?? l10n.noAudio,
                  style: TextStyle(
                    fontSize: 13,
                    color: fileName != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AdminButton.text(
            label: fileName != null ? l10n.replaceFile : l10n.add,
            onPressed: () {
              // File upload would be handled here
            },
          ),
        ],
      ),
    );
  }
}
