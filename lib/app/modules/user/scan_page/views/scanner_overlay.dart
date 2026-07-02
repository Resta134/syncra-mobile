import 'package:flutter/material.dart';

class ScannerOverlay extends StatefulWidget {
  final double width;
  final double height;

  const ScannerOverlay({
    super.key,
    this.width = 280, // Dibuat sedikit lebih lebar agar mirip gambar
    this.height = 280, // Dibuat persegi
  });

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // 1. Siku Scanner (Brackets) Custom Painter
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: BracketPainter(
              color: const Color(0xFF00dbe7),
            ), // Tertiary Cyber Mint
          ),

          // 2. Garis Scanner Bergerak
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: _animation.value * (widget.height - 4),
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF89CEFF), // Primary Cyan
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF89CEFF).withOpacity(0.8),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Logika untuk menggambar 4 siku di sudut
class BracketPainter extends CustomPainter {
  final Color color;
  BracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const double lineLength = 40.0; // Panjang sisi tiap siku

    // Siku Kiri Atas
    canvas.drawPath(
      Path()
        ..moveTo(0, lineLength)
        ..lineTo(0, 0)
        ..lineTo(lineLength, 0),
      paint,
    );
    // Siku Kanan Atas
    canvas.drawPath(
      Path()
        ..moveTo(size.width - lineLength, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, lineLength),
      paint,
    );
    // Siku Kiri Bawah
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - lineLength)
        ..lineTo(0, size.height)
        ..lineTo(lineLength, size.height),
      paint,
    );
    // Siku Kanan Bawah
    canvas.drawPath(
      Path()
        ..moveTo(size.width - lineLength, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - lineLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
