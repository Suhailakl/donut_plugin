import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:donutplugin/donut_src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:touchable/touchable.dart';
import 'dart:ui' as ui;
import 'data_model.dart';

class PieChartPainter extends CustomPainter {
  List<Paint> _paintList = [];
  List<double> _subParts;
  double _total = 0;
  double _totalAngle = math.pi * 2;

  final Color chartValueBackgroundColor;
  final double initialAngle;
  final String centerText;
  Function onTap;
  final Function formatChartValues;
  final double strokeWidth;
  final double selectedStrokeWidth;
  DonutData selectedDonut;
  BuildContext context;
  Map<DonutData, double> dataMap = Map();
  double _prevAngle = 0;
  PieChartPainter(
      this.context,
      double angleFactor,
      List<Color> colorList, {
        this.chartValueBackgroundColor,
        this.initialAngle,
        this.centerText,
        this.formatChartValues,
        this.strokeWidth,
        this.dataMap,
        this.selectedStrokeWidth,
        this.selectedDonut,
        this.onTap,
      }) {
    List<double> values=dataMap.values.toList(growable: false);
    int selectedDonutIndex;
    int i=0;
    for(var item in dataMap.keys){
      if(selectedDonut==item){
        selectedDonutIndex=i;
      }
      i++;
    }
    for (int i = 0; i < values.length; i++) {
      print("dsfdsf "+selectedDonutIndex.toString()+" "+i.toString());
      Paint paint;

      if(i==selectedDonutIndex) {
        paint = Paint()..color = selectedArcColor;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = selectedStrokeWidth;
      }else {
        if(i%2!=0&&i!=selectedDonutIndex-1&&i!=selectedDonutIndex+1&&(selectedDonutIndex==0?i!=values.length-1:true)){
          paint = Paint()..color = Colors.white;
          paint.style = PaintingStyle.stroke;
        }
        else
          paint = Paint()..color = getColor(colorList, i);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = strokeWidth;
      }
      _paintList.add(paint);
    }
    _totalAngle = angleFactor * math.pi * 2;

    _subParts = values;
    _total = values.fold(0, (v1, v2) => v1 + v2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var donutCanvas = TouchyCanvas(context,canvas);
    final side = size.width < size.height ? size.width : size.height;
    _prevAngle =0.0;
    for (int i = 0; i < _subParts.length; i++) {
      DonutData donutData=dataMap.keys.toList(growable: false)[i];
      donutCanvas.drawArc(
          new Rect.fromLTWH(0.0, 0.0, side, size.height),
          _prevAngle,
          (((_totalAngle) / _total) * _subParts[i]),
          false,
          _paintList[i],
          onTapDown: (t){
            print("jdhfjsdhffds");
            if(donutData.icon!=null&&donutData.title!=null) {
              this.onTap(donutData);
            }
          },

      );

      final radius= side / 2;
      final x = (radius) *
          math.cos(
              _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
      final y = (radius) *
          math.sin(
              _prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
      if (_subParts.elementAt(i).toInt() != 0) {

        _drawIcon(canvas, donutData, x, y, side);
      }


      _prevAngle = _prevAngle + (((_totalAngle) / _total) * _subParts[i]);


    }
  }

  Future<ui.Image> _getImageFromBytes(Uint8List imageBytes) async {
    var completer = Completer<ui.Image>();
    ui.decodeImageFromList(imageBytes, (image) {
      completer.complete(image);
    });

    return completer.future;
  }
  Future<void> _drawIcon(Canvas canvas, DonutData donutData, double x, double y, double side) async {

    IconData icon =Icons.category;
    TextPainter tp = TextPainter(textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    tp.text = TextSpan(text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: 20.0,fontFamily: icon.fontFamily));
    tp.layout();

//    tp.paint(
//      canvas,
//      new Offset(
//        (side / 2 + x) - (tp.width / 2),
//        (side / 2 + y) - (tp.height / 2),
//      ),
//    );
    final paint = new Paint();
    canvas.drawImage(donutData.icon, Offset(
      (side / 2 + x) - (tp.width / 2),
      (side / 2 + y) - (tp.height / 2),
    ), paint);









//    tp.text = TextSpan(text: String.fromCharCode(icon.codePoint),
//        style: TextStyle(fontSize: 20.0,fontFamily: icon.fontFamily));
    //  paint.layout();

//    paint.paint(
//      canvas,
//      new Offset(
//        (side / 2 + x) - (tp.width / 2),
//        (side / 2 + y) - (tp.height / 2),
//      ),
//    );
    var _paint=Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
//    if(donutData.title!=null&&selectedDonut==donutData) {
//      print("dxgfsdgfds");
//      canvas.drawLine(Offset(
//        (side / 2 + x) - (tp.width / 2),
//        ((side / 2 + y) - (tp.height / 2)),
//      ), Offset(-10.0, 0.0), _paint);
//    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate._totalAngle != _totalAngle;
}
