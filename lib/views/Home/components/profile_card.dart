import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileCard extends StatelessWidget {
  final Image image;
  final String name;
  final String location;
  final double distance;
  final double ordernumber;
  final double total;
  const ProfileCard(
      {Key? key,
      required this.name,
      required this.location,
      required this.distance,
      required this.ordernumber,
      required this.total,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 106.h,
      width: 375.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: kprimaryLightColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
                color: kshadowcolor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0.0, 3.0)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 94.w,
            height: double.infinity,
            child: CircleAvatar(
              child: image,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Text(
                    name,
                    style: GoogleFonts.getFont('Tajawal',
                        fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14.sp,
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Text(
                      location,
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '$distance Km',
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ksecondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: 250.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '${LocaleKeys.order_order_nbr.tr()}  :',
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: ksecondaryTextColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            Text(
                              '$ordernumber',
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryGreenColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            ' ${LocaleKeys.order_total_price.tr()} :',
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor,
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Text(
                            '$total SR',
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
