import 'package:flutter/material.dart';

enum BottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BottomBarVariant variant;
  final bool showLabels;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? margin;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = BottomBarVariant.standard,
    this.showLabels = true,
    this.elevation,
    this.backgroundColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.qr_code_scanner_outlined),
        activeIcon: const Icon(Icons.qr_code_scanner),
        label: 'Scan',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.history_outlined),
        activeIcon: const Icon(Icons.history),
        label: 'History',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    switch (variant) {
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme, items);
      case BottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme, items);
      case BottomBarVariant.standard:
        return _buildStandardBottomBar(context, theme, items);
    }
  }

  Widget _buildStandardBottomBar(
    BuildContext context,
    ThemeData theme,
    List<BottomNavigationBarItem> items,
  ) {
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(20),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index),
          items: items,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withAlpha(153),
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
              theme.bottomNavigationBarTheme.unselectedLabelStyle,
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
    BuildContext context,
    ThemeData theme,
    List<BottomNavigationBarItem> items,
  ) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha(31),
                offset: const Offset(0, 4),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => _handleNavigation(context, index),
              items: items,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: theme.colorScheme.onSurface.withAlpha(153),
              showSelectedLabels: showLabels,
              showUnselectedLabels: showLabels,
              selectedLabelStyle:
                  theme.bottomNavigationBarTheme.selectedLabelStyle,
              unselectedLabelStyle:
                  theme.bottomNavigationBarTheme.unselectedLabelStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(
    BuildContext context,
    ThemeData theme,
    List<BottomNavigationBarItem> items,
  ) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withAlpha(31),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => _handleNavigation(context, index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withAlpha(26)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isSelected ? item.activeIcon : item.icon,
                      ),
                      if (showLabels) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.label ?? '',
                          style: (isSelected
                                  ? theme.bottomNavigationBarTheme
                                      .selectedLabelStyle
                                  : theme.bottomNavigationBarTheme
                                      .unselectedLabelStyle)
                              ?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withAlpha(153),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    onTap(index);

    // Navigate to corresponding routes
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamed(context, '/qr-code-scanner');
        break;
      case 2:
        Navigator.pushNamed(context, '/transaction-history');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }
}
