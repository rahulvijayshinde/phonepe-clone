import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentScansWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentScans;
  final Function(Map<String, dynamic>) onScanTap;

  const RecentScansWidget({
    super.key,
    required this.recentScans,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentScans.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 2.h),
          Expanded(
            child: _buildScansList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Scans',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () {
              // Clear recent scans
            },
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScansList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: recentScans.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final scan = recentScans[index];
        return _buildScanItem(context, scan);
      },
    );
  }

  Widget _buildScanItem(BuildContext context, Map<String, dynamic> scan) {
    final scanType = scan['type'] as String? ?? 'unknown';
    final merchantName = scan['merchantName'] as String? ?? 'Unknown Merchant';
    final amount = scan['amount'] as String? ?? '';
    final timestamp = scan['timestamp'] as DateTime? ?? DateTime.now();

    return GestureDetector(
      onTap: () => onScanTap(scan),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            _buildScanIcon(context, scanType),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchantName,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      if (amount.isNotEmpty) ...[
                        Text(
                          amount,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 1,
                          height: 12,
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                        SizedBox(width: 2.w),
                      ],
                      Text(
                        _formatTimestamp(timestamp),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanIcon(BuildContext context, String scanType) {
    String iconName;
    Color iconColor;

    switch (scanType.toLowerCase()) {
      case 'payment':
        iconName = 'payment';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'merchant':
        iconName = 'store';
        iconColor = Colors.orange;
        break;
      case 'personal':
        iconName = 'person';
        iconColor = Colors.green;
        break;
      case 'url':
        iconName = 'link';
        iconColor = Colors.blue;
        break;
      default:
        iconName = 'qr_code';
        iconColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.4),
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Recent Scans',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your recently scanned QR codes will appear here',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
