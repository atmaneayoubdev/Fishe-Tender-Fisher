import 'dart:async';

import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackabrDialog extends StatefulWidget {
  const SnackabrDialog({
    required this.message,
    required this.onPopFunction,
    required this.status,
    this.duration,
  });
  final String message;
  final Function onPopFunction;
  final bool status;
  final int? duration;

  @override
  _SnackabrDialogState createState() => _SnackabrDialogState();
}

class _SnackabrDialogState extends State<SnackabrDialog> {
  double _width = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(
            milliseconds: widget.duration == null ? 1500 : widget.duration!),
        () {
      widget.onPopFunction();
    });
    Future.delayed(const Duration(microseconds: 1), () {
      if (mounted)
        setState(() {
          _width = 360.w;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      height: 70.h,
      width: 360.w,
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.status
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/_ic_snackbar_ok.svg",
                            color: kprimaryColor,
                          ),
                          Center(
                            child: Icon(
                              Icons.check,
                              color: kprimaryLightColor,
                              size: 20.sp,
                            ),
                          )
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/_ic_snackbar_ok.svg",
                            color: kprimaryColor,
                          ),
                          Center(
                            child: Icon(
                              Icons.clear,
                              color: kprimaryLightColor,
                              size: 20.sp,
                            ),
                          )
                        ],
                      ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  widget.message,
                  style: GoogleFonts.getFont(
                    'Tajawal',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: ksecondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 4.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1300),
                color: kprimaryColor,
                height: 4.h,
                width: _width,
                curve: Curves.easeInOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
