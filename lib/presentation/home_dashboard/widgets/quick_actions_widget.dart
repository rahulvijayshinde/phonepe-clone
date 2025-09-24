import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickActions = [
      {
        'icon': 'send',
        'label': 'Send Money',
        'color': AppTheme.lightTheme.colorScheme.primary,
        'route': AppRoutes.sendMoney,
      },
      {
        'icon': 'receipt_long',
        'label': 'Pay Bills',
        'color': const Color(0xFF00c851),
        'route': AppRoutes.payBills,
      },
      {
        'icon': 'phone_android',
        'label': 'Recharge',
        'color': const Color(0xFFff8800),
        'route': AppRoutes.recharge,
      },
      {
        'icon': 'qr_code_scanner',
        'label': 'Scan QR',
        'color': const Color(0xFF5f259f),
        'route': AppRoutes.qrCodeScanner,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 13.5.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: quickActions.length,
              separatorBuilder: (context, index) => SizedBox(width: 4.w),
              itemBuilder: (context, index) {
                final action = quickActions[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, action['route'] as String);
                  },
                  child: Container(
                    width: 20.w,
                    padding: EdgeInsets.all(2.2.w),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.4.w),
                          decoration: BoxDecoration(
                            color: (action['color'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: action['icon'] as String,
                            color: action['color'] as Color,
                            size: 26,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          (action['label'] as String).toUpperCase(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
