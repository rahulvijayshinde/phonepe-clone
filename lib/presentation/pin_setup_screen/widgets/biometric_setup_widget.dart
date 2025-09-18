import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricSetupWidget extends StatefulWidget {
  final Function(bool) onBiometricToggle;
  final bool isEnabled;

  const BiometricSetupWidget({
    super.key,
    required this.onBiometricToggle,
    this.isEnabled = false,
  });

  @override
  State<BiometricSetupWidget> createState() => _BiometricSetupWidgetState();
}

class _BiometricSetupWidgetState extends State<BiometricSetupWidget> {
  bool _isBiometricAvailable = false;
  bool _isCheckingBiometric = true;
  String _biometricType = 'Biometric';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Simulate biometric availability check
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock biometric availability based on platform
      setState(() {
        _isBiometricAvailable = true;
        _biometricType = _getBiometricType();
        _isCheckingBiometric = false;
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
        _isCheckingBiometric = false;
      });
    }
  }

  String _getBiometricType() {
    // Mock platform-specific biometric types
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return 'Face ID / Touch ID';
    } else {
      return 'Fingerprint';
    }
  }

  Future<void> _authenticateBiometric() async {
    try {
      HapticFeedback.lightImpact();

      // Show platform-native biometric prompt simulation
      bool authenticated = await _showBiometricDialog();

      if (authenticated) {
        widget.onBiometricToggle(true);
        _showSuccessMessage();
      }
    } catch (e) {
      _showErrorMessage('Biometric authentication failed. Please try again.');
    }
  }

  Future<bool> _showBiometricDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'fingerprint',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Biometric Authentication',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Use your $_biometricType to enable quick access to PayFlutter Pro',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: Theme.of(context).platform == TargetPlatform.iOS
                          ? 'face'
                          : 'fingerprint',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Authenticate'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_biometricType enabled successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingBiometric) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            SizedBox(
              width: 5.w,
              height: 5.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Checking biometric availability...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: Theme.of(context).platform == TargetPlatform.iOS
                      ? 'face'
                      : 'fingerprint',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable $_biometricType',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Quick and secure access to your account',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.isEnabled,
                onChanged: (value) {
                  if (value) {
                    _authenticateBiometric();
                  } else {
                    widget.onBiometricToggle(false);
                  }
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
          if (widget.isEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.green,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '$_biometricType is enabled',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
