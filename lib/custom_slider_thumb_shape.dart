import 'dart:math';

import 'package:cirle_slider/custom_label.dart';
import 'package:flutter/material.dart';

class CustomSliderThumberShape extends SliderComponentShape {

  CustomSliderThumberShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(54, 88);
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);
    final Path path = Path()
      ..addArc(
          Rect.fromCenter(
              center: center, width: 2 * radius, height: 2 * radius),
          0,
          pi * 2);

    bool paintShadows = true;

    if (paintShadows) {
      canvas.drawShadow(path, Color(0xff2FB09A), evaluatedElevation, true);
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );

    canvas.drawCircle(
      center,
      11,
      Paint()..color = Color(0xff2FB09A),
    );

    canvas.drawCircle(
      center,
      6,
      Paint()..color = Colors.white,
    );

    Offset circlePoint = Offset(center.dx, center.dy-16-27-10);

    final Paint fillPaint1 = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    double dy = circlePoint.dy + 27 * cos(pi/12);
    double dxC = circlePoint.dx - 27 * sin(pi/12);

    Path pathLabel = Path();
    pathLabel.moveTo(dxC, dy);
    //pathLabel.lineTo(dxC2, dy);


    pathLabel.arcTo(
        Rect.fromLTRB(circlePoint.dx - 27, circlePoint.dy - 27, circlePoint.dx + 27, circlePoint.dy + 27),
        degreeToRadian(105),
        degreeToRadian(330), false);
    pathLabel.lineTo(circlePoint.dx, circlePoint.dy + 27 + 6);
    pathLabel.lineTo(dxC, dy);
    canvas.drawPath(pathLabel, fillPaint1);

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    var textSpan = TextSpan(
      text: '3',
      style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
      children: <TextSpan>[
        TextSpan(text: '\ndays', style: textStyle),
      ],
    );



    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100,
    );

    Offset textOffset = Offset(circlePoint.dx - textPainter.width / 2, circlePoint.dy - textPainter.height / 2);

    textPainter.paint(canvas, textOffset);

  }

  double degreeToRadian(double degree) {
    return degree * (pi / 180);
  }
}
