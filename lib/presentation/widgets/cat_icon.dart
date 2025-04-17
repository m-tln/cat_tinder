import 'package:flutter/material.dart';

class CatIcon extends StatelessWidget {
  const CatIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _CatIconPainter(),
    );
  }
}

class _CatIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    // Голова
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // Глаза
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.4),
      2,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.4),
      2,
      eyePaint,
    );

    // Зрачки
    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.4),
      1,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.4),
      1,
      pupilPaint,
    );

    // Левое ухо
    final leftEarPath = Path();
    leftEarPath.moveTo(size.width * 0.15, size.height * 0.2);
    leftEarPath.lineTo(size.width * 0.3, size.height * 0.05);
    leftEarPath.lineTo(size.width * 0.35, size.height * 0.25);
    leftEarPath.close();
    canvas.drawPath(leftEarPath, paint);

    // Правое ухо
    final rightEarPath = Path();
    rightEarPath.moveTo(size.width * 0.85, size.height * 0.2);
    rightEarPath.lineTo(size.width * 0.7, size.height * 0.05);
    rightEarPath.lineTo(size.width * 0.65, size.height * 0.25);
    rightEarPath.close();
    canvas.drawPath(rightEarPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
