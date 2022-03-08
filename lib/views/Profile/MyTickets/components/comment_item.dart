import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key? key,
    required this.sender,
    required this.message,
    required this.date,
  }) : super(key: key);
  final String sender;
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 118.h,
      width: 355.w,
      padding: EdgeInsets.only(
        top: 19.h,
        right: 16.w,
        left: 16.w,
      ),
      margin: EdgeInsets.only(right: 17.w, left: 17.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
              style: BorderStyle.solid, width: 1, color: kbordercolor),
          color: kprimaryLightColor,
          boxShadow: [
            BoxShadow(
              color: kshadowcolor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0.0, 3.0),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //height: 36.h,
            //width: 265.w,
            margin: EdgeInsets.only(bottom: 5.h),

            child: Html(
              data: message,
              style: {
                "body,h1,tr,td,head": Style(
                  fontSize: FontSize(12.0.sp),
                  color: ksecondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              },
            ),
            // child: Text(
            //   message,
            //   style: GoogleFonts.getFont(
            //     'Tajawal',
            //     fontSize: 12.sp,
            //     fontWeight: FontWeight.w600,
            //     color: ksecondaryTextColor,
            //   ),
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            // ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        sender,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      child: Text(
                        LocaleKeys.market_account_from.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ksecondaryTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        date,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      child: Text(
                        LocaleKeys.myTickets_date.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ksecondaryTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
