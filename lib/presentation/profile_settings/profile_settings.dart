import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/logout_button_widget.dart';
import './widgets/photo_picker_bottom_sheet.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // User data
  final Map<String, dynamic> _userData = {
    "id": "user_001",
    "name": "Rajesh Kumar",
    "phone": "+91 98765 43210",
    "email": "rajesh.kumar@email.com",
    "profileImage":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
    "isVerified": true,
    "kycStatus": "Completed",
    "joinDate": "March 2023",
  };

  // Settings states
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = true;
  bool _transactionNotifications = true;
  bool _offerNotifications = false;
  bool _promotionNotifications = true;
  String _selectedLanguage = "English";
  String _defaultPaymentMethod = "UPI";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfileTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Profile & Settings',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to notifications
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'notifications_outlined',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
        unselectedLabelColor:
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          ProfileHeaderWidget(
            userName: _userData["name"] as String,
            userPhone: _userData["phone"] as String,
            userEmail: _userData["email"] as String?,
            profileImageUrl: _userData["profileImage"] as String?,
            isVerified: _userData["isVerified"] as bool,
            onEditProfile: _handleEditProfile,
            onChangePhoto: _handleChangePhoto,
          ),
          SizedBox(height: 3.h),
          SettingsSectionWidget(
            title: 'Personal Information',
            children: [
              SettingsItemWidget(
                title: 'Name',
                subtitle: _userData["name"] as String,
                iconName: 'person_outline',
                type: SettingsItemType.navigation,
                onTap: () => _handleEditField('name'),
              ),
              SettingsItemWidget(
                title: 'Mobile Number',
                subtitle: _userData["phone"] as String,
                iconName: 'phone_outlined',
                type: SettingsItemType.navigation,
                onTap: () => _handleEditField('phone'),
              ),
              SettingsItemWidget(
                title: 'Email Address',
                subtitle: _userData["email"] as String? ?? 'Not added',
                iconName: 'email_outlined',
                type: SettingsItemType.navigation,
                onTap: () => _handleEditField('email'),
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Account Information',
            children: [
              SettingsItemWidget(
                title: 'KYC Status',
                subtitle: 'Your account is fully verified',
                iconName: 'verified_user',
                type: SettingsItemType.info,
                trailingText: _userData["kycStatus"] as String,
                iconColor: AppTheme.successLight,
              ),
              SettingsItemWidget(
                title: 'Member Since',
                subtitle: 'Account creation date',
                iconName: 'calendar_today',
                type: SettingsItemType.info,
                trailingText: _userData["joinDate"] as String,
              ),
              SettingsItemWidget(
                title: 'Linked Devices',
                subtitle: 'Manage your trusted devices',
                iconName: 'devices',
                type: SettingsItemType.navigation,
                onTap: () => _handleLinkedDevices(),
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Documents',
            children: [
              SettingsItemWidget(
                title: 'Upload Documents',
                subtitle: 'Update your KYC documents',
                iconName: 'upload_file',
                type: SettingsItemType.navigation,
                onTap: () => _handleDocumentUpload(),
              ),
              SettingsItemWidget(
                title: 'Download Statements',
                subtitle: 'Get your transaction statements',
                iconName: 'download',
                type: SettingsItemType.navigation,
                onTap: () => _handleDownloadStatements(),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          SettingsSectionWidget(
            title: 'Security',
            children: [
              SettingsItemWidget(
                title: 'Change PIN',
                subtitle: 'Update your transaction PIN',
                iconName: 'lock_outline',
                type: SettingsItemType.navigation,
                onTap: () => Navigator.pushNamed(context, '/pin-setup-screen'),
              ),
              SettingsItemWidget(
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face unlock',
                iconName: 'fingerprint',
                type: SettingsItemType.toggle,
                toggleValue: _biometricEnabled,
                onToggleChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
              SettingsItemWidget(
                title: 'Two-Factor Authentication',
                subtitle: 'Extra security for your account',
                iconName: 'security',
                type: SettingsItemType.toggle,
                toggleValue: _twoFactorEnabled,
                onToggleChanged: (value) {
                  setState(() {
                    _twoFactorEnabled = value;
                  });
                },
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Payment Preferences',
            children: [
              SettingsItemWidget(
                title: 'Default Payment Method',
                subtitle: 'Choose your preferred payment option',
                iconName: 'payment',
                type: SettingsItemType.navigation,
                trailingText: _defaultPaymentMethod,
                onTap: () => _handlePaymentMethodSelection(),
              ),
              SettingsItemWidget(
                title: 'Transaction Limits',
                subtitle: 'Set daily and monthly limits',
                iconName: 'account_balance_wallet',
                type: SettingsItemType.navigation,
                onTap: () => _handleTransactionLimits(),
              ),
              SettingsItemWidget(
                title: 'Auto-Pay Settings',
                subtitle: 'Manage recurring payments',
                iconName: 'autorenew',
                type: SettingsItemType.navigation,
                onTap: () => _handleAutoPaySettings(),
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Notifications',
            children: [
              SettingsItemWidget(
                title: 'Transaction Alerts',
                subtitle: 'Get notified for all transactions',
                iconName: 'notifications_active',
                type: SettingsItemType.toggle,
                toggleValue: _transactionNotifications,
                onToggleChanged: (value) {
                  setState(() {
                    _transactionNotifications = value;
                  });
                },
              ),
              SettingsItemWidget(
                title: 'Offers & Cashback',
                subtitle: 'Receive promotional notifications',
                iconName: 'local_offer',
                type: SettingsItemType.toggle,
                toggleValue: _offerNotifications,
                onToggleChanged: (value) {
                  setState(() {
                    _offerNotifications = value;
                  });
                },
              ),
              SettingsItemWidget(
                title: 'Marketing Communications',
                subtitle: 'Product updates and news',
                iconName: 'campaign',
                type: SettingsItemType.toggle,
                toggleValue: _promotionNotifications,
                onToggleChanged: (value) {
                  setState(() {
                    _promotionNotifications = value;
                  });
                },
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'App Preferences',
            children: [
              SettingsItemWidget(
                title: 'Language',
                subtitle: 'Choose your preferred language',
                iconName: 'language',
                type: SettingsItemType.navigation,
                trailingText: _selectedLanguage,
                onTap: () => _handleLanguageSelection(),
              ),
              SettingsItemWidget(
                title: 'Theme',
                subtitle: 'Light or dark mode',
                iconName: 'palette',
                type: SettingsItemType.navigation,
                trailingText: 'Light',
                onTap: () => _handleThemeSelection(),
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Help & Support',
            children: [
              SettingsItemWidget(
                title: 'FAQ',
                subtitle: 'Frequently asked questions',
                iconName: 'help_outline',
                type: SettingsItemType.navigation,
                onTap: () => _handleFAQ(),
              ),
              SettingsItemWidget(
                title: 'Chat Support',
                subtitle: '24/7 customer support',
                iconName: 'chat',
                type: SettingsItemType.navigation,
                onTap: () => _handleChatSupport(),
              ),
              SettingsItemWidget(
                title: 'Call Support',
                subtitle: 'Speak with our support team',
                iconName: 'phone',
                type: SettingsItemType.navigation,
                onTap: () => _handleCallSupport(),
              ),
              SettingsItemWidget(
                title: 'Send Feedback',
                subtitle: 'Help us improve the app',
                iconName: 'feedback',
                type: SettingsItemType.navigation,
                onTap: () => _handleFeedback(),
              ),
            ],
          ),
          SettingsSectionWidget(
            title: 'Legal',
            children: [
              SettingsItemWidget(
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                iconName: 'description',
                type: SettingsItemType.action,
                onTap: () => _handleTermsOfService(),
              ),
              SettingsItemWidget(
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                iconName: 'privacy_tip',
                type: SettingsItemType.action,
                onTap: () => _handlePrivacyPolicy(),
              ),
              SettingsItemWidget(
                title: 'Regulatory Information',
                subtitle: 'Compliance and certifications',
                iconName: 'gavel',
                type: SettingsItemType.action,
                onTap: () => _handleRegulatoryInfo(),
              ),
            ],
          ),
          LogoutButtonWidget(
            onLogout: _handleLogout,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  void _handleEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit profile functionality will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleChangePhoto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PhotoPickerBottomSheet(
        onImageSelected: (XFile image) {
          setState(() {
            _userData["profileImage"] = image.path;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profile photo updated successfully',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
      ),
    );
  }

  void _handleEditField(String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit $field functionality will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleLinkedDevices() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Linked devices management will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleDocumentUpload() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Document upload functionality will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleDownloadStatements() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Statement download functionality will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handlePaymentMethodSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Default Payment Method',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              ['UPI', 'Wallet', 'Bank Account', 'Credit Card'].map((method) {
            return RadioListTile<String>(
              title: Text(method),
              value: method,
              groupValue: _defaultPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _defaultPaymentMethod = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleTransactionLimits() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Transaction limits settings will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleAutoPaySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Auto-pay settings will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleLanguageSelection() {
    final languages = [
      'English',
      'Hindi',
      'Tamil',
      'Telugu',
      'Bengali',
      'Marathi',
      'Gujarati'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleThemeSelection() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme selection will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleFAQ() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'FAQ section will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleChatSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chat support will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleCallSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Call support will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feedback form will be implemented',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Terms of service will be displayed',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handlePrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Privacy policy will be displayed',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleRegulatoryInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Regulatory information will be displayed',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleLogout() {
    // Clear user session and navigate to splash screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/splash-screen',
      (route) => false,
    );
  }
}
