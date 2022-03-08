import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationModel extends StatelessWidget {
  const NotificationModel({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 17.h,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 18.w,
      ),
      height: 83.h,
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: kbordercolor,
        ),
        boxShadow: [
          BoxShadow(
              color: kshadowcolor,
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(0.0, 3.0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                scale: 1.2,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                title,
                style: GoogleFonts.getFont(
                  'Tajawal',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: kprimaryTextColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Tajawal',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ksecondaryTextColor,
            ),
          )
        ],
      ),
    );
  }
}
