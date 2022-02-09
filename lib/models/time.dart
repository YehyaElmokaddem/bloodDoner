import 'package:flutter/material.dart';

class Time {
  final String dayTime;
  final String timeRange;
  final String imgPath;
  final int index;

  Time({
    @required this.dayTime,
    @required this.imgPath,
    @required this.timeRange,
    this.index
  });
}
