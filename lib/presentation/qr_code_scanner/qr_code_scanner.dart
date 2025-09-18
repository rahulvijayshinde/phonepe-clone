import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/manual_entry_dialog.dart';
import './widgets/qr_result_dialog.dart';
import './widgets/recent_scans_widget.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner>
    with TickerProviderStateMixin {
  // Camera and scanning controllers
  CameraController? _cameraController;
  MobileScannerController? _mobileScannerController;
  List<CameraDescription> _cameras = [];

  // State variables
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  bool _hasFlash = false;
  bool _isFlashOn = false;
  bool _showRecentScans = false;
  String? _lastScannedCode;

  // Animation controllers
  late AnimationController _scanAnimationController;
  late AnimationController _overlayAnimationController;

  // Mock data for recent scans
  final List<Map<String, dynamic>> _recentScans = [
    {
      "id": 1,
      "type": "payment",
      "merchantName": "Starbucks Coffee",
      "amount": "₹ 450.00",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "qrData": "upi://pay?pa=starbucks@paytm&pn=Starbucks&am=450.00",
    },
    {
      "id": 2,
      "type": "merchant",
      "merchantName": "Local Grocery Store",
      "amount": "₹ 1,250.00",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "qrData": "upi://pay?pa=grocery@upi&pn=Local%20Grocery&am=1250.00",
    },
    {
      "id": 3,
      "type": "personal",
      "merchantName": "Rahul Sharma",
      "amount": "",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "qrData": "upi://pay?pa=rahul.sharma@okaxis&pn=Rahul%20Sharma",
    },
    {
      "id": 4,
      "type": "url",
      "merchantName": "Restaurant Menu",
      "amount": "",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "qrData": "https://restaurant.com/menu",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _mobileScannerController?.dispose();
    _scanAnimationController.dispose();
    _overlayAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _overlayAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        _showPermissionDeniedDialog();
        return;
      }

      // Initialize mobile scanner for QR detection
      _mobileScannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );

      // Initialize camera for preview
      if (!kIsWeb) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras.first,
          );

          _cameraController = CameraController(
            camera,
            ResolutionPreset.high,
            enableAudio: false,
          );

          await _cameraController!.initialize();
          _hasFlash = _cameraController!.description.lensDirection ==
              CameraLensDirection.back;
        }
      }

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isScanning = true;
        });
        _startScanningAnimation();
      }
    } catch (e) {
      _showErrorDialog('Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  void _startScanningAnimation() {
    _scanAnimationController.repeat();
  }

  void _stopScanningAnimation() {
    _scanAnimationController.stop();
  }

  void _onQrCodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty && _isScanning) {
      final barcode = barcodes.first;
      final qrData = barcode.rawValue ?? '';

      if (qrData.isNotEmpty && qrData != _lastScannedCode) {
        _lastScannedCode = qrData;
        _processQrCode(qrData);
      }
    }
  }

  void _processQrCode(String qrData) {
    setState(() {
      _isScanning = false;
    });

    _stopScanningAnimation();
    _provideFeedback();

    final qrResult = _parseQrData(qrData);
    _showQrResultDialog(qrResult);
  }

  Map<String, dynamic> _parseQrData(String qrData) {
    // Parse UPI payment QR codes
    if (qrData.startsWith('upi://pay?')) {
      final uri = Uri.parse(qrData);
      return {
        'type': 'payment',
        'merchantName': uri.queryParameters['pn'] ?? 'Unknown Merchant',
        'upiId': uri.queryParameters['pa'] ?? '',
        'amount': uri.queryParameters['am'] != null
            ? '₹ ${uri.queryParameters['am']}'
            : '',
        'note': uri.queryParameters['tn'] ?? '',
        'rawData': qrData,
      };
    }

    // Parse URLs
    if (qrData.startsWith('http://') || qrData.startsWith('https://')) {
      return {
        'type': 'url',
        'url': qrData,
        'title': 'Website Link',
        'rawData': qrData,
      };
    }

    // Parse contact information (vCard format)
    if (qrData.startsWith('BEGIN:VCARD')) {
      final lines = qrData.split('\n');
      String name = '';
      String phone = '';
      String email = '';

      for (final line in lines) {
        if (line.startsWith('FN:')) {
          name = line.substring(3);
        } else if (line.startsWith('TEL:')) {
          phone = line.substring(4);
        } else if (line.startsWith('EMAIL:')) {
          email = line.substring(6);
        }
      }

      return {
        'type': 'contact',
        'name': name,
        'phone': phone,
        'email': email,
        'rawData': qrData,
      };
    }

    // Default to text
    return {
      'type': 'text',
      'text': qrData,
      'rawData': qrData,
    };
  }

  void _provideFeedback() {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Visual feedback
    _overlayAnimationController.forward().then((_) {
      _overlayAnimationController.reverse();
    });
  }

  void _toggleFlash() async {
    if (!_hasFlash || _cameraController == null) return;

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );

      await _mobileScannerController?.toggleTorch();
    } catch (e) {
      // Handle flash toggle error
    }
  }

  void _openGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // In a real implementation, you would use an image processing library
        // to extract QR code from the selected image
        _showInfoDialog('Gallery QR scanning is not implemented in this demo');
      }
    } catch (e) {
      _showErrorDialog('Failed to open gallery');
    }
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => ManualEntryDialog(
        onQrDataEntered: (qrData) {
          _processQrCode(qrData);
        },
      ),
    );
  }

  void _showQrResultDialog(Map<String, dynamic> qrResult) {
    showDialog(
      context: context,
      builder: (context) => QrResultDialog(
        qrResult: qrResult,
        onPayNow: () {
          Navigator.of(context).pop();
          _navigateToPayment(qrResult);
        },
        onSaveContact: () {
          Navigator.of(context).pop();
          _saveContact(qrResult);
        },
        onOpenUrl: () {
          Navigator.of(context).pop();
          _openUrl(qrResult);
        },
      ),
    ).then((_) {
      // Resume scanning after dialog is closed
      setState(() {
        _isScanning = true;
        _lastScannedCode = null;
      });
      _startScanningAnimation();
    });
  }

  void _navigateToPayment(Map<String, dynamic> qrResult) {
    // Navigate to payment screen with QR data
    Navigator.pushNamed(context, '/home-dashboard');
  }

  void _saveContact(Map<String, dynamic> qrResult) {
    _showInfoDialog('Contact saved successfully');
  }

  void _openUrl(Map<String, dynamic> qrResult) {
    final url = qrResult['url'] as String? ?? '';
    _showInfoDialog('Opening: $url');
  }

  void _onRecentScanTap(Map<String, dynamic> scan) {
    final qrData = scan['qrData'] as String? ?? '';
    if (qrData.isNotEmpty) {
      _processQrCode(qrData);
    }
  }

  void _toggleRecentScans() {
    setState(() {
      _showRecentScans = !_showRecentScans;
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'Please grant camera permission to scan QR codes. You can enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Information'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            _buildCameraPreview(),

            // Camera overlay with scanning frame
            if (_isCameraInitialized)
              CameraOverlayWidget(
                isScanning: _isScanning,
                hasFlash: _hasFlash,
                isFlashOn: _isFlashOn,
                onFlashToggle: _toggleFlash,
                onGalleryTap: _openGallery,
                onManualEntry: _showManualEntryDialog,
              ),

            // Recent scans bottom sheet
            if (_showRecentScans) _buildRecentScansSheet(),

            // Recent scans toggle button
            _buildRecentScansToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing Camera...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Camera preview
        if (_cameraController != null && !kIsWeb)
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_cameraController!),
          ),

        // Mobile scanner for QR detection
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: MobileScanner(
            controller: _mobileScannerController,
            onDetect: _onQrCodeDetected,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScansSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Recent scans content
            Container(
              constraints: BoxConstraints(maxHeight: 50.h),
              child: RecentScansWidget(
                recentScans: _recentScans,
                onScanTap: _onRecentScanTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScansToggle() {
    return Positioned(
      bottom: 4.h,
      right: 4.w,
      child: GestureDetector(
        onTap: _toggleRecentScans,
        child: Container(
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: _showRecentScans ? 'keyboard_arrow_down' : 'history',
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
