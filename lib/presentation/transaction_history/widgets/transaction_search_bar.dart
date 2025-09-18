import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterTap;
  final VoidCallback? onDateRangeTap;
  final Function(String)? onChanged;
  final bool showDateRange;
  final String? dateRangeText;

  const TransactionSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search transactions...',
    this.onFilterTap,
    this.onDateRangeTap,
    this.onChanged,
    this.showDateRange = true,
    this.dateRangeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          controller.clear();
                          onChanged?.call('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          size: 20,
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    IconButton(
                      onPressed: onFilterTap,
                      icon: CustomIconWidget(
                        iconName: 'tune',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          if (showDateRange) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: onDateRangeTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'date_range',
                      size: 18,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        dateRangeText ?? 'Select date range',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: dateRangeText != null
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          fontWeight: dateRangeText != null
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      size: 18,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
