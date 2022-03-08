import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class ServiceWidgetOrder extends StatelessWidget {
  const ServiceWidgetOrder({
    Key? key,
    required this.name,
    required this.price,
  }) : super(key: key);
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      child: Row(
        children: [
          Icon(Icons.check_box_outlined),
          SizedBox(
            width: 10.w,
          ),
          Text(
            name,
            style: GoogleFonts.tajawal(
              fontSize: 16.sp,
              color: kprimaryTextColor,
              height: 1.5,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          SizedBox(
            width: 2.w,
          ),
          Text(
            double.parse(price) == 0
                ? LocaleKeys.free.tr()
                : "($price)" + LocaleKeys.rs.tr(),
            style: GoogleFonts.tajawal(
              fontSize: 15.sp,
              color: double.parse(price) == 0
                  ? kprimaryGreenColor
                  : kprimaryTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
