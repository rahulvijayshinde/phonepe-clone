import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_setup_widget.dart';
import './widgets/pin_input_widget.dart';
import './widgets/pin_strength_indicator_widget.dart';
import './widgets/security_guidelines_widget.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _initialPin = '';
  String _confirmPin = '';
  String? _errorMessage;
  bool _isBiometricEnabled = false;
  bool _isLoading = false;
  int _currentStep = 0; // 0: Initial PIN, 1: Confirm PIN, 2: Biometric Setup

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onInitialPinChanged(String pin) {
    setState(() {
      _initialPin = pin;
      _errorMessage = null;
    });
  }

  void _onInitialPinCompleted(String pin) {
    if (pin.length == 4) {
      _moveToConfirmation();
    }
  }

  void _onConfirmPinChanged(String pin) {
    setState(() {
      _confirmPin = pin;
      _errorMessage = null;
    });
  }

  void _onConfirmPinCompleted(String pin) {
    if (pin.length == 4) {
      if (pin == _initialPin) {
        _moveToBiometricSetup();
      } else {
        setState(() {
          _errorMessage = 'PINs do not match. Please try again.';
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _moveToConfirmation() {
    setState(() {
      _currentStep = 1;
      _errorMessage = null;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _moveToBiometricSetup() {
    setState(() {
      _currentStep = 2;
      _errorMessage = null;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onBiometricToggle(bool enabled) {
    setState(() {
      _isBiometricEnabled = enabled;
    });
  }

  Future<void> _setupPin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate PIN setup process
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to setup PIN. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.green,
                  size: 40,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'PIN Setup Complete!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Your account is now secured with a 4-digit PIN${_isBiometricEnabled ? ' and biometric authentication' : ''}.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    // Auto navigate to home dashboard after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close dialog
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-dashboard',
        (route) => false,
      );
    });
  }

  void _skipForNow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: Colors.orange,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Skip PIN Setup?',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          content: Text(
            'You can skip PIN setup for now, but you\'ll need to set it up before making your first transaction for security.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home-dashboard',
                  (route) => false,
                );
              },
              child: Text('Skip for Now'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _errorMessage = null;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return false;
    }

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Exit PIN Setup?',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              content: Text(
                'Setting up a PIN is important for securing your transactions. Are you sure you want to exit?',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Continue Setup',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Exit',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Progress Indicator
                _buildProgressIndicator(),

                // Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildInitialPinStep(),
                      _buildConfirmPinStep(),
                      _buildBiometricStep(),
                    ],
                  ),
                ),

                // Bottom Actions
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                  _errorMessage = null;
                });
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            )
          else
            SizedBox(width: 12.w),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 32,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getStepTitle(),
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  _getStepSubtitle(),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= _currentStep;
          bool isCompleted = index < _currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              height: 0.8.h,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.primary
                    : isActive
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.5)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInitialPinStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          // PIN Input
          PinInputWidget(
            pinLength: 4,
            onPinChanged: _onInitialPinChanged,
            onPinCompleted: _onInitialPinCompleted,
            errorMessage: _errorMessage,
          ),

          SizedBox(height: 3.h),

          // PIN Strength Indicator
          PinStrengthIndicatorWidget(pin: _initialPin),

          SizedBox(height: 4.h),

          // Security Guidelines
          const SecurityGuidelinesWidget(),
        ],
      ),
    );
  }

  Widget _buildConfirmPinStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          // Confirmation Message
          Container(
            padding: EdgeInsets.all(4.w),
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Please re-enter your PIN to confirm',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PIN Input
          PinInputWidget(
            pinLength: 4,
            onPinChanged: _onConfirmPinChanged,
            onPinCompleted: _onConfirmPinCompleted,
            isConfirmation: true,
            errorMessage: _errorMessage,
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildBiometricStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          // Success Message
          Container(
            padding: EdgeInsets.all(4.w),
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.green,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'PIN created successfully! Now let\'s add biometric authentication for faster access.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Biometric Setup
          BiometricSetupWidget(
            onBiometricToggle: _onBiometricToggle,
            isEnabled: _isBiometricEnabled,
          ),

          SizedBox(height: 4.h),

          // Additional Security Info
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'shield',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Your Security',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildSecurityFeature(
                    'encrypted', 'PIN encrypted and stored securely'),
                _buildSecurityFeature(
                    'lock', 'PIN required for all transactions'),
                _buildSecurityFeature('fingerprint',
                    'Biometric fallback to PIN always available'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityFeature(String iconName, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.7),
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          if (_currentStep < 2) ...[
            // Skip for now button
            TextButton(
              onPressed: _skipForNow,
              child: Text(
                'Skip for now',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Main action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _getMainAction(),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(_getMainActionText()),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Create Your PIN';
      case 1:
        return 'Confirm Your PIN';
      case 2:
        return 'Setup Complete';
      default:
        return 'Setup PIN';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Choose a 4-digit PIN to secure your transactions';
      case 1:
        return 'Re-enter your PIN to confirm';
      case 2:
        return 'Add biometric authentication for faster access';
      default:
        return 'Secure your account with a PIN';
    }
  }

  VoidCallback? _getMainAction() {
    switch (_currentStep) {
      case 0:
        return _initialPin.length == 4 ? _moveToConfirmation : null;
      case 1:
        return _confirmPin.length == 4
            ? () {
                if (_confirmPin == _initialPin) {
                  _moveToBiometricSetup();
                }
              }
            : null;
      case 2:
        return _setupPin;
      default:
        return null;
    }
  }

  String _getMainActionText() {
    switch (_currentStep) {
      case 0:
        return 'Continue';
      case 1:
        return 'Confirm PIN';
      case 2:
        return 'Complete Setup';
      default:
        return 'Continue';
    }
  }
}
