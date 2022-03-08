import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants.dart';
import 'package:easy_localization/easy_localization.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
      required this.type,
      required this.number,
      required this.date,
      required this.state,
      required this.amount})
      : super(key: key);
  final String number;
  final String date;
  final String state;
  final String type;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 9.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            number,
            style: GoogleFonts.getFont(
              'Tajawal',
              fontSize: 12.sp,
              color: kprimaryTextColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
          Text(
            date,
            style: GoogleFonts.getFont(
              'Tajawal',
              fontSize: 12.sp,
              color: kprimaryTextColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
          Text(
            state == "1"
                ? LocaleKeys.completed.tr()
                : state == "2"
                    ? LocaleKeys.on_hold.tr()
                    : LocaleKeys.canceled.tr(),
            style: GoogleFonts.getFont(
              'Tajawal',
              fontSize: 12.sp,
              color: state == "1"
                  ? kprimaryGreenColor
                  : state == "2"
                      ? kprimaryColor
                      : kredcolor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
          Text(
            amount,
            style: GoogleFonts.getFont(
              'Tajawal',
              fontSize: 12.sp,
              color: type == "1" ? kprimaryGreenColor : kredcolor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ],
      ),
    );
  }
}
