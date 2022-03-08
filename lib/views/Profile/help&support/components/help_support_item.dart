import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportItem extends StatelessWidget {
  const HelpSupportItem({Key? key, required this.title, required this.function})
      : super(key: key);
  final String title;
  // final String route;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: kprimaryLightColor,
        boxShadow: [
          BoxShadow(
              color: kshadowcolor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0.0, 3.0)),
        ],
      ),
      height: 54.h,
      width: 355.w,
      margin: EdgeInsets.only(left: 18.w, right: 17.w, top: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              title,
              style: GoogleFonts.getFont('Tajawal',
                  fontSize: 16.sp,
                  color: kprimaryTextColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kprimaryColor,
              boxShadow: [
                BoxShadow(
                    color: kshadowcolor,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0.0, 3.0)),
              ],
            ),
            height: 25.h,
            width: 25.w,
            child: InkWell(
              splashColor: ksecondaryColor, // Splash color
              onTap: () {
                function();
              },
              child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 15.sp,
                    color: kprimaryLightColor,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
