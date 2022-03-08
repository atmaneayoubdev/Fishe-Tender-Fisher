import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class MyTicketsItem extends StatelessWidget {
  const MyTicketsItem(
      {Key? key,
      required this.state,
      required this.message,
      required this.date,
      required this.number})
      : super(key: key);
  final String state;
  final String message;
  final String date;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 118.h,
      width: 355.w,
      padding: EdgeInsets.only(
        top: 10.h,
        right: 16.w,
        left: 16.w,
      ),
      margin: EdgeInsets.only(right: 17.w, left: 17.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border:
            Border.all(style: BorderStyle.solid, width: 1, color: kbordercolor),
        color: kprimaryLightColor,
        boxShadow: [
          BoxShadow(
            color: kshadowcolor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
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
                        number,
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
                        LocaleKeys.myTickets_ticket_number.tr(),
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
                Container(
                  height: 32.h,
                  width: 81.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: state == "2" ? ksecondaryColor : kprimaryGreenColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    state == "1"
                        ? LocaleKeys.myTickets_open.tr()
                        : LocaleKeys.myTickets_closed.tr(),
                    style: GoogleFonts.getFont(
                      'Tajawal',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          state == "1" ? kprimaryTextColor : kprimaryLightColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
