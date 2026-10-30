import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );


    _controller.forward();

    // Navigate to login after 2.8 seconds
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnim,
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: Image.asset(
                  'assets/images/logo_talemark.png',
                  width: 240,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Menggambar logo TaleMark: dua kurva lengkung (arch) yang menyatu di atas
/// dengan garis horizontal di puncak, dan satu tiang vertikal di tengah.
// ignore: unused_element
class _TaleMarkLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.065
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double w = size.width;
    final double h = size.height;

    // ── Horizontal top bar ──────────────────────────────────────────
    final double barY = h * 0.18;
    final double barLeft = w * 0.05;
    final double barRight = w * 0.95;
    canvas.drawLine(Offset(barLeft, barY), Offset(barRight, barY), paint);

    // ── Left arch - mulai dari ~30% bar, melengkung kuat ke luar ──────
    final Path leftArch = Path()
      ..moveTo(w * 0.32, barY)
      ..cubicTo(
        w * 0.02, h * 0.32, // ctrl1: tarik jauh ke kiri atas
        w * 0.01, h * 0.68, // ctrl2: tetap jauh kiri bawah
        w * 0.07, h * 0.98, // ujung bawah kiri
      );
    canvas.drawPath(leftArch, paint);

    // ── Right arch - mulai dari ~68% bar, melengkung kuat ke luar ─────
    final Path rightArch = Path()
      ..moveTo(w * 0.68, barY)
      ..cubicTo(
        w * 0.98, h * 0.32, // ctrl1: tarik jauh ke kanan atas
        w * 0.99, h * 0.68, // ctrl2: tetap jauh kanan bawah
        w * 0.93, h * 0.98, // ujung bawah kanan
      );
    canvas.drawPath(rightArch, paint);

    // ── Center vertical stem ─────────────────────────────────────────
    canvas.drawLine(
      Offset(w * 0.50, barY),
      Offset(w * 0.50, h * 0.98),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
