import 'dart:math';

import 'package:flutter/material.dart';

class CustomSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  final int numberOfMilestone;
  final int selectedValue;

  CustomSliderTrackShape(this.numberOfMilestone, this.selectedValue);

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }
    double trackHeight = sliderTheme.trackHeight ?? 0;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Tween<double> opacityTween = Tween<double>(begin: 0, end: 1);


    final Paint fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;


    _drawTrackShape(
      context: context,
      numberOfMilestone: numberOfMilestone,
      trackHeight: trackHeight,
      fillPaint: fillPaint,
      trackRect: trackRect,
    );


    final Paint fillPaint1 = Paint()
      ..color = Colors.blue.withOpacity(opacityTween.evaluate(enableAnimation))
      ..style = PaintingStyle.fill;

    if (selectedValue > 1) {
      final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top +4, thumbCenter.dx, trackRect.bottom -4);
      _drawTrackShape(
        context: context,
        numberOfMilestone: selectedValue,
        trackHeight: 12,
        fillPaint: fillPaint1,
        trackRect: leftTrackSegment,
      );
    }
  }



  void _drawTrackShape({
    required double trackHeight,
    required Rect trackRect,
    required int numberOfMilestone,
    required PaintingContext context,
    required Paint fillPaint,
}) {
    final path = Path();
    double dis = trackRect.width / (numberOfMilestone - 1);
    path.moveTo(trackRect.centerLeft.dx - (trackHeight / 2), trackRect.centerLeft.dy);
    for (int i = 0; i < numberOfMilestone; i++) {
      double dx = trackRect.left - (trackHeight / 2) + i * dis;
      var rect = Rect.fromLTRB(dx, trackRect.top, dx + trackHeight, trackRect.bottom);
      double startAngle = i == 0 ? pi : 7 * pi / 6;
      double sweepAngle =
      (i == 0 || i == numberOfMilestone - 1) ? 5 * pi / 6 : 2 * pi / 3;
      path.arcTo(rect, startAngle, sweepAngle, false);
    }

    for (int i = numberOfMilestone - 1; i >= 0; i--) {
      double dx = trackRect.left - (trackHeight / 2) + i * dis;
      var rect = Rect.fromLTRB(dx, trackRect.top, dx + trackHeight, trackRect.bottom);
      double startAngle = i == numberOfMilestone - 1 ? 0 : pi / 6;
      double sweepAngle =
      (i == 0 || i == numberOfMilestone - 1) ? 5 * pi / 6 : 2 * pi / 3;
      path.arcTo(rect, startAngle, sweepAngle, false);
    }
    context.canvas.drawPath(path, fillPaint);
  }
}
