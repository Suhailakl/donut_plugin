import 'dart:math' as math;

import 'package:donutplugin/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data_model.dart';

class  InnerChartPainter extends CustomPainter {
  List<Paint> _paintList = [];
  List<double> _subParts;
  double _total = 0;
  double _totalAngle = math.pi * 2;

  final Color chartValueBackgroundColor;
  final bool showValuesInPercentage;
  final bool showChartValueLabel;
  final String centerText;
  final Function formatChartValues;
  final double strokeWidth;
  final double radius;
  final TextStyle innerPercentageStyle;
  final TextStyle innerTitleStyle;
  final TextStyle innerAmountStyle;
  DonutData selectedDonut;
  Map<DonutData, double> dataMap = Map();
  double _prevAngle = 0;
  Paint _paint;
  InnerChartPainter(
      double angleFactor, {
        this.chartValueBackgroundColor,
        this.showValuesInPercentage,
        this.showChartValueLabel,
        this.centerText,
        this.formatChartValues,
        this.strokeWidth,
        this.dataMap,
        this.radius,
        this.selectedDonut,
        this.innerPercentageStyle,
        this.innerTitleStyle,
        this.innerAmountStyle
      }) {
    DrawCircle();
    List<double> values=dataMap.values.toList(growable: false);
    _totalAngle = angleFactor * math.pi * 2;

    _subParts = values;
    _total = values.fold(0, (v1, v2) => v1 + v2);
  }

  DrawCircle() {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width/0.45, size.height/.47), radius, _paint);
    _drawCenterText(canvas,selectedDonut,size);
  }
  void _drawCenterText(Canvas canvas,DonutData donutData,Size size) {
    _drawCenter(canvas, donutData, 0, 0,size);
  }
  void _drawCenter(Canvas canvas, DonutData donutData, double x, double y, Size size) {
    final side = size.width < size.height ? size.width : size.height*2;
    TextSpan span = TextSpan(
      style: innerPercentageStyle,
      text: donutData.percent.toString()+"%",
    );
    TextPainter tp = TextPainter(textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: span
    );
    tp.layout();

    tp.paint(
      canvas,
      new Offset(
        (side / 0.9 + x) - (tp.width / 2),
        (side / 1.6 + y) - (tp.height / 2),
      ),
    );
    final sideTitle = size.width < size.height ? size.width : size.height*2;
    TextSpan spanTitle = TextSpan(
      style: innerTitleStyle,
      text: donutData.title.toString(),
    );
    TextPainter tpTitle = TextPainter(textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        text: spanTitle,
    );
    tpTitle.layout();
    tpTitle.paint(
      canvas,
      new Offset(
        (sideTitle / 0.91 + x) - (tpTitle.width / 2),
        (sideTitle / 1.1 + y) - (tpTitle.height / 2),
      ),
    );
    final sideAmount = size.width < size.height ? size.width : size.height*2;
    TextSpan spanAmount = TextSpan(
      style: innerAmountStyle,
      text: "\$ "+donutData.amount.toString(),
    );
    TextPainter tpAmount = TextPainter(textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: spanAmount,
    );
    tpAmount.layout();
    tpAmount.paint(
      canvas,
      new Offset(
        (sideAmount / 0.91 + x) - (tpAmount.width / 2),
        (sideAmount / 0.8 + y) - (tpAmount.height / 2),
      ),
    );
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
