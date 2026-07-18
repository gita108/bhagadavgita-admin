import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimens.dart';
import '../../core/l10n/app_localizations.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentPath = GoRouterState.of(context).matchedLocation;

    return Container(
      width: AppDimens.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _MenuItem(
            label: l10n.menuBooks,
            isSelected: currentPath == '/books',
            onTap: () => context.go('/books'),
          ),
          _MenuItem(
            label: l10n.menuChapters,
            isSelected: currentPath == '/chapters',
            onTap: () => context.go('/chapters'),
          ),
          _MenuItem(
            label: l10n.menuSlokas,
            isSelected: currentPath.startsWith('/slokas'),
            onTap: () => context.go('/slokas'),
          ),
          _MenuItem(
            label: l10n.menuQuotes,
            isSelected: currentPath == '/quotes',
            onTap: () => context.go('/quotes'),
          ),
          _MenuItem(
            label: l10n.menuLanguages,
            isSelected: currentPath == '/languages',
            onTap: () => context.go('/languages'),
          ),
          _MenuItem(
            label: l10n.menuImport,
            isSelected: currentPath == '/import',
            onTap: () => context.go('/import'),
          ),
          _MenuItem(
            label: l10n.menuDevices,
            isSelected: currentPath == '/devices',
            onTap: () => context.go('/devices'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.menuItemPaddingH,
          vertical: AppDimens.menuItemPadding,
        ),
        color: isSelected ? AppColors.primary : Colors.transparent,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
