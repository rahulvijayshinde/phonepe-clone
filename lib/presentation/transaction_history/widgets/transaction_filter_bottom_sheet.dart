import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const TransactionFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<TransactionFilterBottomSheet> createState() =>
      _TransactionFilterBottomSheetState();
}

class _TransactionFilterBottomSheetState
    extends State<TransactionFilterBottomSheet> {
  late Map<String, dynamic> _filters;
  RangeValues _amountRange = const RangeValues(0, 100000);

  final List<String> _transactionTypes = [
    'All',
    'UPI',
    'Bank Transfer',
    'Card Payment',
    'Mobile Recharge',
    'Bill Payment',
    'Shopping',
    'Food',
    'Travel',
    'Entertainment',
    'Fuel',
  ];

  final List<String> _statusOptions = [
    'All',
    'Success',
    'Pending',
    'Failed',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);

    if (_filters['minAmount'] != null && _filters['maxAmount'] != null) {
      _amountRange = RangeValues(
        (_filters['minAmount'] as num).toDouble(),
        (_filters['maxAmount'] as num).toDouble(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Transactions',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Transaction Type'),
                  _buildTransactionTypeFilter(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Status'),
                  _buildStatusFilter(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Amount Range'),
                  _buildAmountRangeFilter(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Date Range'),
                  _buildDateRangeFilter(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildTransactionTypeFilter() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _transactionTypes.map((type) {
        final isSelected = _filters['type'] == type ||
            (_filters['type'] == null && type == 'All');
        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters['type'] = type == 'All' ? null : type;
            });
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor: AppTheme.lightTheme.colorScheme.primary,
          checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
          labelStyle: TextStyle(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 12.sp,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusFilter() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _statusOptions.map((status) {
        final isSelected = _filters['status'] == status ||
            (_filters['status'] == null && status == 'All');
        return FilterChip(
          label: Text(status),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters['status'] = status == 'All' ? null : status;
            });
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor: AppTheme.lightTheme.colorScheme.primary,
          checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
          labelStyle: TextStyle(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontSize: 12.sp,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmountRangeFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _amountRange,
          min: 0,
          max: 100000,
          divisions: 100,
          labels: RangeLabels(
            '₹${_amountRange.start.round()}',
            '₹${_amountRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _amountRange = values;
              _filters['minAmount'] = values.start;
              _filters['maxAmount'] = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${_amountRange.start.round()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            Text(
              '₹${_amountRange.end.round()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'date_range',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                _getDateRangeText(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateRangeText() {
    if (_filters['startDate'] != null && _filters['endDate'] != null) {
      final startDate = _filters['startDate'] as DateTime;
      final endDate = _filters['endDate'] as DateTime;
      return '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
    }
    return 'Select date range';
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _filters['startDate'] != null && _filters['endDate'] != null
              ? DateTimeRange(
                  start: _filters['startDate'] as DateTime,
                  end: _filters['endDate'] as DateTime,
                )
              : null,
    );

    if (picked != null) {
      setState(() {
        _filters['startDate'] = picked.start;
        _filters['endDate'] = picked.end;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _amountRange = const RangeValues(0, 100000);
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
