import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UnitWidget extends StatefulWidget {
  const UnitWidget({
    required this.name,
    required this.isSelected,
    required this.price,
  });
  final String name;
  final bool isSelected;
  final String price;

  @override
  _UnitWidgetState createState() => _UnitWidgetState();
}

class _UnitWidgetState extends State<UnitWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      width: widget.isSelected ? 80.w : 45.w,
      decoration: BoxDecoration(
        color: widget.isSelected ? kprimaryColor : kprimaryLightColor,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: kshadowcolor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              widget.name,
              style: GoogleFonts.tajawal(
                fontSize: 16.sp,
                color:
                    widget.isSelected ? kprimaryLightColor : kprimaryTextColor,
              ),
            ),
          ),
          if (widget.isSelected)
            SizedBox(
              width: 3.w,
            ),
          if (widget.isSelected)
            Container(
              child: Text(
                "(${double.parse(widget.price).toStringAsFixed(2)})",
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 13.sp,
                  color: Colors.amber,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
