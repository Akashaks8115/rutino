import 'dart:ui';
import '../../../libs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotScale;
  late Animation<double> _pathDraw;
  late Animation<double> _sparkFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _exitScale;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3500));

    _dotScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.15, curve: Curves.easeOutBack)),
    );

    _pathDraw = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.55, curve: Curves.easeInOut)),
    );

    _sparkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.65, curve: Curves.easeIn)),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.65, 0.85, curve: Curves.easeIn)),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.65, 0.85, curve: Curves.easeOut)),
    );

    _exitScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.85, 1.0, curve: Curves.easeIn)),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.85, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        SplashService.call();
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
      backgroundColor: const Color(0xFF0B0F19), // Deep Cyber Black
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _exitFade.value,
            child: Transform.scale(
              scale: _exitScale.value,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CustomPaint(
                        painter: _RLogoPainter(
                          dotScale: _dotScale.value,
                          pathDraw: _pathDraw.value,
                          sparkFade: _sparkFade.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _textSlide,
                      child: Opacity(
                        opacity: _textFade.value,
                        child: const Text(
                          "rutino",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            color: Color(0xFFF1F5F9), // Crisp ice-white
                            fontFamily: 'Roboto', // Modern font
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RLogoPainter extends CustomPainter {
  final double dotScale;
  final double pathDraw;
  final double sparkFade;

  _RLogoPainter({
    required this.dotScale,
    required this.pathDraw,
    required this.sparkFade,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF5465FF)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFF5465FF)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final sparkPaint = Paint()
      ..color = const Color(0xFF00E676)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    double startX = size.width * 0.3;
    double startY = size.height * 0.9;

    if (dotScale > 0 && pathDraw == 0) {
      canvas.drawCircle(Offset(startX, startY), 4.0 * dotScale, dotPaint);
    }

    Path rPath = Path();
    // Start at bottom of the stem
    rPath.moveTo(startX, startY);
    // Draw stem up to the top
    rPath.lineTo(startX, size.height * 0.2);
    
    // Draw the loop of the R using a bezier curve for exact control
    rPath.cubicTo(
      size.width * 0.85, size.height * 0.2,   // Control point 1: top right
      size.width * 0.85, size.height * 0.55,  // Control point 2: bottom right
      startX, size.height * 0.55              // End point: middle left (back to stem)
    );
    
    // Draw the leg of the R
    rPath.lineTo(size.width * 0.75, size.height * 0.9);

    if (pathDraw > 0) {
      PathMetrics pathMetrics = rPath.computeMetrics();
      for (PathMetric pathMetric in pathMetrics) {
        Path extractPath = pathMetric.extractPath(0.0, pathMetric.length * pathDraw);
        canvas.drawPath(extractPath, linePaint);

        if (sparkFade > 0 && pathDraw >= 1.0) {
          Tangent? tangent = pathMetric.getTangentForOffset(pathMetric.length);
          if (tangent != null) {
            canvas.drawCircle(tangent.position, 8.0 * sparkFade, sparkPaint);
            Paint coreSpark = Paint()
              ..color = Colors.white
              ..style = PaintingStyle.fill;
            canvas.drawCircle(tangent.position, 3.0 * sparkFade, coreSpark);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RLogoPainter oldDelegate) {
    return oldDelegate.dotScale != dotScale ||
        oldDelegate.pathDraw != pathDraw ||
        oldDelegate.sparkFade != sparkFade;
  }
}
