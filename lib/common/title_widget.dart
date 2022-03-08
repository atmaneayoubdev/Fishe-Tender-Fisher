import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Color color;
  final TextStyle? textStyle;
  const TitleWidget({
    Key? key,
    required this.title,
    required this.color,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.topLeft,

      height: 38.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle == null
                ? GoogleFonts.getFont('Tajawal',
                    fontSize: 17.sp, fontWeight: FontWeight.bold)
                : textStyle,
          ),
          Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10.r)),
            height: 6.66.h,
            width: 25.7.w,
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }
}
