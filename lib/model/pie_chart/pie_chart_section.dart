import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PieChartSectionData{
  final double value;
  final String title;
  final Color color;
  final double radius;
  final TextStyle titleStyle;
  final bool showTitle;

  PieChartSectionData({
    required this.showTitle,
    required this.value,
    required this.title,
    required this.color,
    this.radius = 50,
    TextStyle? titleStyle,
  }) : titleStyle = titleStyle ??
      GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white);
}