import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppBarVariant {
  standard,
  centered,
  minimal,
  search,
  profile,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final AppBarVariant variant;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final TextEditingController? searchController;
  final String? searchHint;
  final VoidCallback? onSearchChanged;
  final String? profileName;
  final String? profileSubtitle;
  final Widget? profileAvatar;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.variant = AppBarVariant.standard,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = false,
    this.flexibleSpace,
    this.bottom,
    this.systemOverlayStyle,
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.profileName,
    this.profileSubtitle,
    this.profileAvatar,
  });

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    if (variant == AppBarVariant.profile) {
      height = 120;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case AppBarVariant.centered:
        return _buildCenteredAppBar(context, theme);
      case AppBarVariant.minimal:
        return _buildMinimalAppBar(context, theme);
      case AppBarVariant.search:
        return _buildSearchAppBar(context, theme);
      case AppBarVariant.profile:
        return _buildProfileAppBar(context, theme);
      case AppBarVariant.standard:
        return _buildStandardAppBar(context, theme);
    }
  }

  Widget _buildStandardAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      actions: _buildActions(context),
      leading: _buildLeading(context),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      centerTitle: centerTitle,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(theme),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildCenteredAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      actions: _buildActions(context),
      leading: _buildLeading(context),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      centerTitle: true,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(theme),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildMinimalAppBar(BuildContext context, ThemeData theme) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (_buildLeading(context) != null) ...[
                _buildLeading(context)!,
                const SizedBox(width: 16),
              ],
              Expanded(
                child: title != null
                    ? Text(
                        title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: foregroundColor ?? theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (_buildActions(context) != null) ...[
                const SizedBox(width: 16),
                Row(children: _buildActions(context)!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(31),
          ),
        ),
        child: TextField(
          controller: searchController,
          onChanged: (_) => onSearchChanged?.call(),
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(153),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withAlpha(153),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(theme),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildProfileAppBar(BuildContext context, ThemeData theme) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(204),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  if (_buildLeading(context) != null) ...[
                    _buildLeading(context)!,
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: title != null
                        ? Text(
                            title!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (_buildActions(context) != null) ...[
                    const SizedBox(width: 16),
                    Row(children: _buildActions(context)!),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  profileAvatar ??
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            theme.colorScheme.onPrimary.withAlpha(51),
                        child: Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimary,
                          size: 24,
                        ),
                      ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (profileName != null)
                          Text(
                            profileName!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (profileSubtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            profileSubtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary.withAlpha(204),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    // Default actions based on variant
    switch (variant) {
      case AppBarVariant.search:
        return [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action
            },
            tooltip: 'Filter',
          ),
        ];
      case AppBarVariant.profile:
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/profile-settings');
            },
            tooltip: 'Settings',
          ),
        ];
      default:
        return null;
    }
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}
