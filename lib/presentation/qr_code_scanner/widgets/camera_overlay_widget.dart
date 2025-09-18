import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraOverlayWidget extends StatelessWidget {
  final bool isScanning;
  final bool hasFlash;
  final bool isFlashOn;
  final VoidCallback? onFlashToggle;
  final VoidCallback? onGalleryTap;
  final VoidCallback? onManualEntry;

  const CameraOverlayWidget({
    super.key,
    required this.isScanning,
    this.hasFlash = false,
    this.isFlashOn = false,
    this.onFlashToggle,
    this.onGalleryTap,
    this.onManualEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Dark overlay with scanning frame cutout
          _buildOverlayWithFrame(context),

          // Top controls
          _buildTopControls(context),

          // Scanning frame with corner guides
          _buildScanningFrame(context),

          // Bottom controls
          _buildBottomControls(context),

          // Instruction text
          _buildInstructionText(context),
        ],
      ),
    );
  }

  Widget _buildOverlayWithFrame(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _ScanningOverlayPainter(
          scanAreaSize: 60.w,
          borderColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    return Positioned(
      top: 8.h,
      left: 4.w,
      right: 4.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Flash toggle (only show if flash is available)
          if (hasFlash)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: onFlashToggle,
                icon: CustomIconWidget(
                  iconName: isFlashOn ? 'flash_on' : 'flash_off',
                  color: isFlashOn ? Colors.yellow : Colors.white,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScanningFrame(BuildContext context) {
    return Center(
      child: Container(
        width: 60.w,
        height: 60.w,
        child: Stack(
          children: [
            // Corner guides
            _buildCornerGuide(context, Alignment.topLeft),
            _buildCornerGuide(context, Alignment.topRight),
            _buildCornerGuide(context, Alignment.bottomLeft),
            _buildCornerGuide(context, Alignment.bottomRight),

            // Scanning animation
            if (isScanning) _buildScanningAnimation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerGuide(BuildContext context, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 8.w,
        height: 8.w,
        child: CustomPaint(
          painter: _CornerGuidePainter(
            alignment: alignment,
            color: AppTheme.lightTheme.colorScheme.primary,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildScanningAnimation(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Positioned(
          top: value * 55.w,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.lightTheme.colorScheme.primary,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Positioned(
      bottom: 12.h,
      left: 4.w,
      right: 4.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button
          _buildControlButton(
            context,
            icon: 'photo_library',
            label: 'Gallery',
            onTap: onGalleryTap,
          ),

          // Manual entry button
          _buildControlButton(
            context,
            icon: 'keyboard',
            label: 'Manual',
            onTap: onManualEntry,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required String icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText(BuildContext context) {
    return Positioned(
      top: 75.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Point camera at QR code',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ScanningOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Color borderColor;

  _ScanningOverlayPainter({
    required this.scanAreaSize,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scanAreaRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Create path for overlay with cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
          RRect.fromRectAndRadius(scanAreaRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerGuidePainter extends CustomPainter {
  final Alignment alignment;
  final Color color;
  final double strokeWidth;

  _CornerGuidePainter({
    required this.alignment,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cornerLength = size.width * 0.6;

    if (alignment == Alignment.topLeft) {
      // Top line
      canvas.drawLine(
        const Offset(0, 0),
        Offset(cornerLength, 0),
        paint,
      );
      // Left line
      canvas.drawLine(
        const Offset(0, 0),
        Offset(0, cornerLength),
        paint,
      );
    } else if (alignment == Alignment.topRight) {
      // Top line
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width - cornerLength, 0),
        paint,
      );
      // Right line
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, cornerLength),
        paint,
      );
    } else if (alignment == Alignment.bottomLeft) {
      // Bottom line
      canvas.drawLine(
        Offset(0, size.height),
        Offset(cornerLength, size.height),
        paint,
      );
      // Left line
      canvas.drawLine(
        Offset(0, size.height),
        Offset(0, size.height - cornerLength),
        paint,
      );
    } else if (alignment == Alignment.bottomRight) {
      // Bottom line
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height),
        paint,
      );
      // Right line
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
