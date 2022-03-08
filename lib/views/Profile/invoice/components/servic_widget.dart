import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    Key? key,
    required this.name,
    required this.price,
    this.discount,
  }) : super(key: key);
  final String name;
  final String price;
  final String? discount;

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
          if (discount != "" && double.parse(price) != 0 && discount != null)
            Container(
              child: Text(
                (((double.parse(price)) * (double.parse(discount!))) / 100)
                    .toStringAsFixed(2),
                style: GoogleFonts.tajawal(
                  fontSize: 15.sp,
                  color: kprimaryTextColor,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          SizedBox(
            width: 2.w,
          ),
          if (discount == "")
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
          if (discount != "")
            Text(
              double.parse(price) == 0 ? LocaleKeys.free : "($price)",
              style: GoogleFonts.tajawal(
                fontSize: double.parse(price) == 0 ? 16.sp : 12.sp,
                color: double.parse(price) == 0
                    ? kprimaryGreenColor
                    : kprimaryTextColor,
                decoration: double.parse(price) == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
                height: double.parse(price) == 0 ? 1.5 : 2,
              ),
            )
        ],
      ),
    );
  }
}
