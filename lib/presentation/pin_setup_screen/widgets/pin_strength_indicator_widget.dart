import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PinStrengthIndicatorWidget extends StatelessWidget {
  final String pin;

  const PinStrengthIndicatorWidget({
    super.key,
    required this.pin,
  });

  PinStrength _calculatePinStrength(String pin) {
    if (pin.length < 4) return PinStrength.weak;

    // Check for sequential digits
    bool hasSequential = false;
    for (int i = 0; i < pin.length - 1; i++) {
      int current = int.tryParse(pin[i]) ?? 0;
      int next = int.tryParse(pin[i + 1]) ?? 0;
      if ((next - current).abs() == 1) {
        hasSequential = true;
        break;
      }
    }

    // Check for repeated digits
    bool hasRepeated = false;
    for (int i = 0; i < pin.length - 1; i++) {
      if (pin[i] == pin[i + 1]) {
        hasRepeated = true;
        break;
      }
    }

    // Check for common patterns
    List<String> commonPatterns = [
      '1234',
      '4321',
      '1111',
      '2222',
      '3333',
      '4444',
      '5555',
      '6666',
      '7777',
      '8888',
      '9999',
      '0000'
    ];
    bool hasCommonPattern = commonPatterns.contains(pin);

    if (hasCommonPattern || hasRepeated) {
      return PinStrength.weak;
    } else if (hasSequential) {
      return PinStrength.medium;
    } else {
      return PinStrength.strong;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pin.isEmpty) return const SizedBox.shrink();

    PinStrength strength = _calculatePinStrength(pin);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PIN Strength',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.8.h,
                  decoration: BoxDecoration(
                    color: strength == PinStrength.weak
                        ? AppTheme.lightTheme.colorScheme.error
                        : strength == PinStrength.medium
                            ? Colors.orange
                            : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Container(
                  height: 0.8.h,
                  decoration: BoxDecoration(
                    color: strength == PinStrength.medium ||
                            strength == PinStrength.strong
                        ? strength == PinStrength.medium
                            ? Colors.orange
                            : Colors.green
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Container(
                  height: 0.8.h,
                  decoration: BoxDecoration(
                    color: strength == PinStrength.strong
                        ? Colors.green
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            _getStrengthText(strength),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: strength == PinStrength.weak
                  ? AppTheme.lightTheme.colorScheme.error
                  : strength == PinStrength.medium
                      ? Colors.orange
                      : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (strength == PinStrength.weak) ...[
            SizedBox(height: 0.5.h),
            Text(
              'Avoid sequential or repeated digits',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStrengthText(PinStrength strength) {
    switch (strength) {
      case PinStrength.weak:
        return 'Weak PIN';
      case PinStrength.medium:
        return 'Medium PIN';
      case PinStrength.strong:
        return 'Strong PIN';
    }
  }
}

enum PinStrength { weak, medium, strong }
