import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './transaction_card.dart';

class MonthlyTransactionGroup extends StatefulWidget {
  final String monthYear;
  final List<Map<String, dynamic>> transactions;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;
  final Function(Map<String, dynamic>)? onTransactionTap;
  final Function(Map<String, dynamic>)? onViewReceipt;
  final Function(Map<String, dynamic>)? onRepeatTransaction;
  final Function(Map<String, dynamic>)? onDispute;
  final Function(Map<String, dynamic>)? onShare;

  const MonthlyTransactionGroup({
    super.key,
    required this.monthYear,
    required this.transactions,
    required this.isExpanded,
    this.onToggleExpanded,
    this.onTransactionTap,
    this.onViewReceipt,
    this.onRepeatTransaction,
    this.onDispute,
    this.onShare,
  });

  @override
  State<MonthlyTransactionGroup> createState() =>
      _MonthlyTransactionGroupState();
}

class _MonthlyTransactionGroupState extends State<MonthlyTransactionGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MonthlyTransactionGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.transactions.fold<double>(
      0.0,
      (sum, transaction) {
        final amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
        final isCredit = transaction['isCredit'] as bool? ?? false;
        return sum + (isCredit ? amount : -amount);
      },
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onToggleExpanded,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.monthYear,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${widget.transactions.length} transactions',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${totalAmount >= 0 ? '+' : ''}₹${totalAmount.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: totalAmount >= 0
                              ? Colors.green[600]
                              : AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          size: 20,
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: widget.transactions.map((transaction) {
                return TransactionCard(
                  transaction: transaction,
                  onTap: () => widget.onTransactionTap?.call(transaction),
                  onViewReceipt: () => widget.onViewReceipt?.call(transaction),
                  onRepeatTransaction: () =>
                      widget.onRepeatTransaction?.call(transaction),
                  onDispute: () => widget.onDispute?.call(transaction),
                  onShare: () => widget.onShare?.call(transaction),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
