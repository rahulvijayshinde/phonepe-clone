import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum SettingsItemType {
  navigation,
  toggle,
  info,
  action,
}

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final SettingsItemType type;
  final VoidCallback? onTap;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;
  final String? trailingText;
  final Color? iconColor;
  final bool showDivider;

  const SettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.type,
    this.onTap,
    this.toggleValue,
    this.onToggleChanged,
    this.trailingText,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: type == SettingsItemType.toggle ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.lightTheme.colorScheme.primary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: iconColor ?? AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 2.w),
            _buildTrailingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    switch (type) {
      case SettingsItemType.navigation:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              SizedBox(width: 2.w),
            ],
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
              size: 5.w,
            ),
          ],
        );
      case SettingsItemType.toggle:
        return Switch(
          value: toggleValue ?? false,
          onChanged: onToggleChanged,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        );
      case SettingsItemType.info:
        return trailingText != null
            ? Text(
                trailingText!,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              )
            : const SizedBox.shrink();
      case SettingsItemType.action:
        return CustomIconWidget(
          iconName: 'open_in_new',
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 5.w,
        );
    }
  }
}
