import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _loadingOpacityAnimation;

  bool _showRetryOption = false;
  bool _isInitializing = true;
  String _loadingText = 'Initializing PayFlutter Pro...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Loading opacity animation
    _loadingOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();

    // Start loading animation after logo animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingAnimationController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization tasks
      await _performInitializationTasks();

      // Navigate based on user state
      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    final List<Future<void>> initTasks = [
      _checkAuthenticationStatus(),
      _loadUserPreferences(),
      _fetchPaymentConfigurations(),
      _prepareCachedData(),
    ];

    // Execute all initialization tasks
    await Future.wait(initTasks);
  }

  Future<void> _checkAuthenticationStatus() async {
    setState(() {
      _loadingText = 'Checking authentication...';
    });
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _loadingText = 'Loading preferences...';
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _fetchPaymentConfigurations() async {
    setState(() {
      _loadingText = 'Configuring payment services...';
    });
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _prepareCachedData() async {
    setState(() {
      _loadingText = 'Preparing transaction data...';
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _navigateToNextScreen() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Simulate user state check
    final bool isAuthenticated = await _checkUserAuthentication();
    final bool hasCompletedKYC = await _checkKYCStatus();
    final bool isNewUser = await _checkIfNewUser();

    // Navigation logic based on user state
    String nextRoute;
    if (isNewUser) {
      nextRoute = '/pin-setup-screen';
    } else if (isAuthenticated && hasCompletedKYC) {
      nextRoute = '/home-dashboard';
    } else {
      nextRoute = '/pin-setup-screen';
    }

    // Smooth transition with fade effect
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  Future<bool> _checkUserAuthentication() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 200));
    return false; // Mock: user not authenticated
  }

  Future<bool> _checkKYCStatus() async {
    // Simulate KYC status check
    await Future.delayed(const Duration(milliseconds: 200));
    return false; // Mock: KYC not completed
  }

  Future<bool> _checkIfNewUser() async {
    // Simulate new user check
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Mock: new user
  }

  void _handleInitializationError() {
    setState(() {
      _isInitializing = false;
      _showRetryOption = true;
      _loadingText =
          'Unable to connect. Please check your internet connection.';
    });

    // Show retry option after 5 seconds if still on splash
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isInitializing) {
        setState(() {
          _showRetryOption = true;
        });
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _showRetryOption = false;
      _isInitializing = true;
      _loadingText = 'Retrying initialization...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.primaryContainer,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Section
                      AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: _buildLogo(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 8.h),

                      // App Name
                      AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Text(
                              'PayFlutter Pro',
                              style: AppTheme.lightTheme.textTheme.headlineLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Tagline
                      AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _logoOpacityAnimation.value * 0.9,
                            child: Text(
                              'Secure Digital Payments',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.9),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Loading Section
              AnimatedBuilder(
                animation: _loadingAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _loadingOpacityAnimation.value,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      child: Column(
                        children: [
                          // Loading Indicator
                          if (_isInitializing && !_showRetryOption) ...[
                            SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],

                          // Loading Text
                          Text(
                            _loadingText,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary
                                  .withValues(alpha: 0.8),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          // Retry Button
                          if (_showRetryOption) ...[
                            SizedBox(height: 3.h),
                            ElevatedButton(
                              onPressed: _retryInitialization,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                foregroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Security Badges
              AnimatedBuilder(
                animation: _loadingAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _loadingOpacityAnimation.value * 0.7,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSecurityBadge('RBI Compliant'),
                          SizedBox(width: 4.w),
                          _buildSecurityBadge('Bank Grade Security'),
                          SizedBox(width: 4.w),
                          _buildSecurityBadge('ISO 27001'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'payment',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildSecurityBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 8.sp,
        ),
      ),
    );
  }
}
