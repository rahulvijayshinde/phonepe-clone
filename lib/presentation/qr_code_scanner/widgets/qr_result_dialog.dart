import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrResultDialog extends StatelessWidget {
  final Map<String, dynamic> qrResult;
  final VoidCallback? onPayNow;
  final VoidCallback? onSaveContact;
  final VoidCallback? onOpenUrl;

  const QrResultDialog({
    super.key,
    required this.qrResult,
    this.onPayNow,
    this.onSaveContact,
    this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final qrType = qrResult['type'] as String? ?? 'unknown';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 85.w,
        constraints: BoxConstraints(maxHeight: 70.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, qrType),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5.w),
                child: _buildContent(context, qrType),
              ),
            ),
            _buildActionButtons(context, qrType),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String qrType) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: _getTypeColor(qrType).withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getTypeColor(qrType).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getTypeIcon(qrType),
                color: _getTypeColor(qrType),
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTypeTitle(qrType),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getTypeColor(qrType),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'QR Code Scanned Successfully',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, String qrType) {
    switch (qrType.toLowerCase()) {
      case 'payment':
      case 'upi':
        return _buildPaymentContent(context);
      case 'contact':
        return _buildContactContent(context);
      case 'url':
        return _buildUrlContent(context);
      case 'text':
        return _buildTextContent(context);
      default:
        return _buildGenericContent(context);
    }
  }

  Widget _buildPaymentContent(BuildContext context) {
    final merchantName =
        qrResult['merchantName'] as String? ?? 'Unknown Merchant';
    final amount = qrResult['amount'] as String? ?? '';
    final upiId = qrResult['upiId'] as String? ?? '';
    final transactionNote = qrResult['note'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          context,
          title: 'Merchant Details',
          items: [
            if (merchantName.isNotEmpty) _buildInfoItem('Name', merchantName),
            if (upiId.isNotEmpty) _buildInfoItem('UPI ID', upiId),
          ],
        ),
        if (amount.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildInfoCard(
            context,
            title: 'Payment Amount',
            items: [
              _buildInfoItem('Amount', amount, isHighlighted: true),
            ],
          ),
        ],
        if (transactionNote.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildInfoCard(
            context,
            title: 'Transaction Note',
            items: [
              _buildInfoItem('Note', transactionNote),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildContactContent(BuildContext context) {
    final name = qrResult['name'] as String? ?? '';
    final phone = qrResult['phone'] as String? ?? '';
    final email = qrResult['email'] as String? ?? '';

    return _buildInfoCard(
      context,
      title: 'Contact Information',
      items: [
        if (name.isNotEmpty) _buildInfoItem('Name', name),
        if (phone.isNotEmpty) _buildInfoItem('Phone', phone),
        if (email.isNotEmpty) _buildInfoItem('Email', email),
      ],
    );
  }

  Widget _buildUrlContent(BuildContext context) {
    final url = qrResult['url'] as String? ?? '';
    final title = qrResult['title'] as String? ?? 'Website';

    return _buildInfoCard(
      context,
      title: 'Website Information',
      items: [
        _buildInfoItem('Title', title),
        if (url.isNotEmpty) _buildInfoItem('URL', url, isCopyable: true),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final text = qrResult['text'] as String? ?? '';

    return _buildInfoCard(
      context,
      title: 'Text Content',
      items: [
        _buildInfoItem('Content', text, isCopyable: true),
      ],
    );
  }

  Widget _buildGenericContent(BuildContext context) {
    final rawData = qrResult['rawData'] as String? ?? '';

    return _buildInfoCard(
      context,
      title: 'QR Code Data',
      items: [
        _buildInfoItem('Raw Data', rawData, isCopyable: true),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value, {
    bool isHighlighted = false,
    bool isCopyable = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isHighlighted ? FontWeight.w600 : FontWeight.w400,
                      color: isHighlighted
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isCopyable)
                  GestureDetector(
                    onTap: () => _copyToClipboard(value),
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      child: CustomIconWidget(
                        iconName: 'content_copy',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
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

  Widget _buildActionButtons(BuildContext context, String qrType) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _getPrimaryAction(context, qrType),
              child: Text(_getPrimaryActionText(qrType)),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _getPrimaryAction(BuildContext context, String qrType) {
    switch (qrType.toLowerCase()) {
      case 'payment':
      case 'upi':
        return onPayNow;
      case 'contact':
        return onSaveContact;
      case 'url':
        return onOpenUrl;
      default:
        return () => Navigator.of(context).pop();
    }
  }

  String _getPrimaryActionText(String qrType) {
    switch (qrType.toLowerCase()) {
      case 'payment':
      case 'upi':
        return 'Pay Now';
      case 'contact':
        return 'Save Contact';
      case 'url':
        return 'Open URL';
      default:
        return 'OK';
    }
  }

  String _getTypeTitle(String qrType) {
    switch (qrType.toLowerCase()) {
      case 'payment':
      case 'upi':
        return 'Payment QR Code';
      case 'contact':
        return 'Contact QR Code';
      case 'url':
        return 'Website QR Code';
      case 'text':
        return 'Text QR Code';
      default:
        return 'QR Code';
    }
  }

  String _getTypeIcon(String qrType) {
    switch (qrType.toLowerCase()) {
      case 'payment':
      case 'upi':
        return 'payment';
      case 'contact':
        return 'contact_phone';
      case 'url':
        return 'link';
      case 'text':
        return 'text_fields';
      default:
        return 'qr_code';
    }
  }

  Color _getTypeColor(String qrType) {
    switch (qrType.toLowerCase()) {
      case 'payment':
      case 'upi':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'contact':
        return Colors.green;
      case 'url':
        return Colors.blue;
      case 'text':
        return Colors.orange;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
