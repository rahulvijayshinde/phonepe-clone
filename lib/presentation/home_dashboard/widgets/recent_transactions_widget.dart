import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentTransactions = [
      {
        'id': 'TXN001',
        'type': 'send',
        'icon': 'arrow_upward',
        'merchant': 'Rahul Kumar',
        'amount': -500.0,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'completed',
      },
      {
        'id': 'TXN002',
        'type': 'receive',
        'icon': 'arrow_downward',
        'merchant': 'Priya Sharma',
        'amount': 1200.0,
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'status': 'completed',
      },
      {
        'id': 'TXN003',
        'type': 'bill',
        'icon': 'receipt',
        'merchant': 'Electricity Bill',
        'amount': -850.0,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'completed',
      },
      {
        'id': 'TXN004',
        'type': 'recharge',
        'icon': 'phone_android',
        'merchant': 'Mobile Recharge',
        'amount': -299.0,
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'status': 'completed',
      },
      {
        'id': 'TXN005',
        'type': 'cashback',
        'icon': 'card_giftcard',
        'merchant': 'Cashback Reward',
        'amount': 50.0,
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'completed',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/transaction-history');
                  },
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.08),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(2.w),
              itemCount: recentTransactions.length,
              separatorBuilder: (context, index) => Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.12),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                final isPositive = (transaction['amount'] as double) > 0;

                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? const Color(0xFF00c851).withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: transaction['icon'] as String,
                      color: isPositive
                          ? const Color(0xFF00c851)
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    transaction['merchant'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _formatTimestamp(transaction['timestamp'] as DateTime),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  trailing: Text(
                    '${isPositive ? '+' : ''}₹${(transaction['amount'] as double).abs().toStringAsFixed(0)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isPositive
                          ? const Color(0xFF00c851)
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // Navigate to transaction details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
