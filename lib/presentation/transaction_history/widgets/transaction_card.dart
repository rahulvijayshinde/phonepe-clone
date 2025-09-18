import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onViewReceipt;
  final VoidCallback? onRepeatTransaction;
  final VoidCallback? onDispute;
  final VoidCallback? onShare;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onViewReceipt,
    this.onRepeatTransaction,
    this.onDispute,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final String type = transaction['type'] as String? ?? '';
    final String merchantName = transaction['merchantName'] as String? ?? '';
    final double amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
    final String status = transaction['status'] as String? ?? '';
    final DateTime timestamp =
        transaction['timestamp'] as DateTime? ?? DateTime.now();
    final bool isCredit = transaction['isCredit'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(transaction['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onViewReceipt?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              icon: Icons.receipt_outlined,
              label: 'Receipt',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onRepeatTransaction?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              icon: Icons.repeat,
              label: 'Repeat',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onDispute?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              icon: Icons.report_problem_outlined,
              label: 'Dispute',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.share_outlined,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _getTransactionIconColor(type),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getTransactionIcon(type),
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchantName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Text(
                              _formatTimestamp(timestamp),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: _getStatusColor(status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isCredit ? '+' : '-'} ₹${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isCredit
                              ? Colors.green[600]
                              : AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      CustomIconWidget(
                        iconName: 'chevron_right',
                        size: 16,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'upi':
        return 'account_balance_wallet';
      case 'bank_transfer':
        return 'account_balance';
      case 'card_payment':
        return 'credit_card';
      case 'mobile_recharge':
        return 'phone_android';
      case 'bill_payment':
        return 'receipt_long';
      case 'shopping':
        return 'shopping_cart';
      case 'food':
        return 'restaurant';
      case 'travel':
        return 'flight';
      case 'entertainment':
        return 'movie';
      case 'fuel':
        return 'local_gas_station';
      default:
        return 'payment';
    }
  }

  Color _getTransactionIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'upi':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'bank_transfer':
        return Colors.blue[600]!;
      case 'card_payment':
        return Colors.orange[600]!;
      case 'mobile_recharge':
        return Colors.green[600]!;
      case 'bill_payment':
        return Colors.purple[600]!;
      case 'shopping':
        return Colors.pink[600]!;
      case 'food':
        return Colors.red[600]!;
      case 'travel':
        return Colors.indigo[600]!;
      case 'entertainment':
        return Colors.teal[600]!;
      case 'fuel':
        return Colors.brown[600]!;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[600]!;
      case 'failed':
      case 'cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
