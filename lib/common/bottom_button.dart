import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomButton extends StatelessWidget {
  final String title;
  //final Function onTape;
  final Color? bgcolor;
  final Color? bordercolor;
  final Color? color;
  const BottomButton(
      {required this.title, this.bgcolor, this.bordercolor, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 56.0.h,
      decoration: BoxDecoration(
          color: bgcolor == null ? kprimaryColor : bgcolor,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
              color: bordercolor != null ? bordercolor! : Colors.transparent)),
      child: Text(
        title,
        style: GoogleFonts.getFont('Tajawal',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color == null ? kprimaryLightColor : color),
      ),
    );
  }
}
