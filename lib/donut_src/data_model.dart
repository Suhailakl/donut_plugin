import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
class DonutData{
  String title;
  int percent;
  int amount;
  ui.Image icon;

  DonutData({this.title, this.percent, this.amount, this.icon});
}