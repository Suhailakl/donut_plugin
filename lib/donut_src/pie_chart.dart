import 'package:donutplugin/src/inner_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'chart_painter.dart';
import 'data_model.dart';
import 'utils.dart';

enum LegendPosition { top, bottom, left, right }

enum ChartType { disc, ring }

class PieChart extends StatefulWidget {
  PieChart({
    @required this.context,
    @required this.dataMap,
    this.chartValueBackgroundColor = Colors.grey,
    this.animationDuration,
    this.colorList = defaultColorList,
    this.formatChartValues,
    this.innerPercentageStyle,
    this.innerTitleStyle,
    this.innerAmountStyle,
    Key key,
  }) : super(key: key);

  Map<DonutData, double> dataMap;
  final Color chartValueBackgroundColor;

  BuildContext context;
 
  final Duration animationDuration;
  final List<Color> colorList;
  final Function formatChartValues;
  final TextStyle innerPercentageStyle;
  final TextStyle innerTitleStyle;
  final TextStyle innerAmountStyle;


  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _fraction = 0.0;
  Map<DonutData, double> _newdataMap=Map();
  DonutData selectedDonut;
  double chartRadius;
  double strokeWidth;
  void initData() {

    assert(
    widget.dataMap != null && widget.dataMap.isNotEmpty,
    "dataMap passed to pie chart cant be null or empty",
    );
  }

  @override
  void initState() {
    super.initState();
    chartRadius=MediaQuery.of(widget.context).size.width / 1.7;
    strokeWidth=MediaQuery.of(widget.context).size.width/8;

    int i=0;
    for(var it in widget.dataMap.entries ){
      _newdataMap[it.key]= it.value/10;
      _newdataMap[DonutData(amount: i,icon: null,percent: 1,title: null)]= 0.02;
      i++;
    }
   setState(() {
   selectedDonut=_newdataMap.keys.toList()[0];
   });
    initData();
    controller = AnimationController(
      duration: widget.animationDuration ?? Duration(milliseconds: 800),
      vsync: this,
    );
    final Animation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    //This condition isn't working oldWidget.data is giving same data as
    //new widget.
    // print(oldWidget.dataMap);
    // print(widget.dataMap);
    //if (oldWidget.dataMap != widget.dataMap) initData();
    initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  _getChart() {
    return Stack(
      children: <Widget>[
        LayoutBuilder(
          builder: (_, c) => Container(
            height: chartRadius != null
                ? c.maxWidth < chartRadius
                ? c.maxWidth
                : chartRadius
                : null,
            child:
            CanvasTouchDetector(
                builder: (context) =>
                    CustomPaint(
                      painter: PieChartPainter(
                          context,
                          _fraction,
                          widget.colorList,
                          chartValueBackgroundColor: widget.chartValueBackgroundColor,
                          formatChartValues: widget.formatChartValues,
                          strokeWidth: strokeWidth,
                          dataMap:_newdataMap,
                          selectedStrokeWidth: chartRadius-MediaQuery.of(context).size.width / 2.7,
                          selectedDonut: selectedDonut,
                          onTap: (selDonut){
                          setState(() {
                            selectedDonut=selDonut;
                          });

                          },

                      ),
                      child: AspectRatio(aspectRatio: 1),
                    )
            )

          ),
        ),
        LayoutBuilder(
          builder: (_, c) => Container(
            height: chartRadius != null
                ? c.maxWidth < chartRadius
                ? c.maxWidth
                : chartRadius-MediaQuery.of(context).size.width / 2.2
                : null,
            child: CustomPaint(
              painter: InnerChartPainter(
                _fraction,
                formatChartValues: widget.formatChartValues,
                strokeWidth: strokeWidth,
                dataMap: _newdataMap,
                selectedDonut: selectedDonut,
                radius:chartRadius != null
                    ? c.maxWidth < chartRadius
                    ? c.maxWidth
                    : chartRadius-MediaQuery.of(context).size.width / 2.9
                    : null,
                innerTitleStyle: widget.innerTitleStyle,
                innerPercentageStyle: widget.innerPercentageStyle,
                innerAmountStyle: widget.innerAmountStyle
              ),
              child: AspectRatio(aspectRatio: 1),
            ),
          ),
        ),
      ],
    );
  }



  _getPieChart() {
  return _getChart();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      child: _getPieChart(),
    );
  }
}
