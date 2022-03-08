import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants.dart';

class FaqItem extends StatefulWidget {
  const FaqItem({Key? key, required this.questin, required this.answer})
      : super(key: key);
  final String questin;
  final String answer;

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (mounted)
          setState(() {
            isActive = !isActive;
          });
      },
      child: Container(
        margin: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 321.w,
                  child: Text(
                    widget.questin,
                    style: GoogleFonts.getFont(
                      'Tajawal',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: kprimaryTextColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ksecondaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: kshadowcolor,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0.0, 3.0)),
                    ],
                  ),
                  height: 28.h,
                  width: 28.w,
                  child: GestureDetector(
                    child: SizedBox(
                      child: Icon(
                        isActive
                            ? FontAwesomeIcons.chevronUp
                            : FontAwesomeIcons.chevronDown,
                        size: 15.sp,
                        color: kprimaryLightColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isActive)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  widget.answer,
                  style: GoogleFonts.getFont(
                    'Tajawal',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: ksecondaryTextColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
