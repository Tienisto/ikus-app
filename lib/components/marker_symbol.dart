import 'package:flutter/material.dart';
import 'package:ikus_app/utility/ui.dart';

class MarkerSymbol extends StatelessWidget {

  static const double width = 20;
  static const double height = 40;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OpenPainter(),
    );
  }
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final destX = MarkerSymbol.width / 2;
    final destY = MarkerSymbol.height / 2;

    Paint painter = Paint()
      ..color = OvguColor.primary
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(destX - 10, destY - 30);
    path.lineTo(destX + 10, destY - 30);
    path.lineTo(destX, destY);
    path.close();

    canvas.drawPath(path, painter);
    canvas.drawCircle(Offset(destX, destY - 32), 10, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}