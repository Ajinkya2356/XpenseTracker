import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../config/theme_config.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('UPI QR Code: ${barcode.rawValue}');
                // Handle the scanned QR code here
                // You can parse UPI details and create a transaction
                _showQRCodeResult(context, barcode.rawValue ?? 'Invalid QR Code');
              }
            },
          ),

          // Background Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Scanner Frame
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15, // Moved up slightly
            left: (MediaQuery.of(context).size.width - 300) / 2, // Increased from 260
            child: Stack(
              children: [
                // Clear scanning area
                SizedBox(
                  height: 300, // Increased from 260
                  width: 300,  // Increased from 260
                ),
                
                // Corner Indicators
                SizedBox(
                  height: 300, // Increased from 260
                  width: 300,  // Increased from 260
                  child: Stack(
                    children: List.generate(4, (index) {
                      final isTop = index < 2;
                      final isLeft = index.isEven;
                      return Positioned(
                        top: isTop ? 0 : null,
                        bottom: !isTop ? 0 : null,
                        left: isLeft ? 0 : null,
                        right: !isLeft ? 0 : null,
                        child: Container(
                          height: 50, // Increased from 40
                          width: 50,  // Increased from 40
                          decoration: BoxDecoration(
                            border: Border(
                              left: isLeft ? BorderSide(
                                color: ThemeConfig.appBarColor,
                                width: 5, // Increased from 4
                              ) : BorderSide.none,
                              top: isTop ? BorderSide(
                                color: ThemeConfig.appBarColor,
                                width: 5, // Increased from 4
                              ) : BorderSide.none,
                              right: !isLeft ? BorderSide(
                                color: ThemeConfig.appBarColor,
                                width: 5, // Increased from 4
                              ) : BorderSide.none,
                              bottom: !isTop ? BorderSide(
                                color: ThemeConfig.appBarColor,
                                width: 5, // Increased from 4
                              ) : BorderSide.none,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Scanner animation
                SizedBox(
                  height: 300, // Increased from 260
                  width: 300,  // Increased from 260
                  child: AnimatedBuilder(
                    animation: controller.torchState,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ScannerOverlayPainter(
                          color: ThemeConfig.primaryColor.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Header with Back and Flash
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller.torchState,
                    builder: (context, state, child) {
                      return GestureDetector(
                        onTap: () => controller.toggleTorch(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: state == TorchState.on 
                                ? ThemeConfig.primaryColor.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                            color: state == TorchState.on ? ThemeConfig.primaryColor : Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Instructions and Gallery Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7), // Reduced from 1.0
                    Colors.black.withOpacity(0.5), // Reduced from 0.8
                    Colors.transparent,
                  ],
                  stops: const [0.3, 0.7, 1.0], // Adjusted stops
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Light background
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white.withOpacity(0.9),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Scan any QR code to pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () {
                      // Add gallery picker functionality
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Upload from Gallery'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showQRCodeResult(BuildContext context, String qrData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeConfig.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Scanned QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              qrData,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle the payment process here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.primaryColor,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this new painter class at the bottom of the file
class ScannerOverlayPainter extends CustomPainter {
  final Color color;

  ScannerOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0),
          color,
          color.withOpacity(0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScannerCutoutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ))
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
