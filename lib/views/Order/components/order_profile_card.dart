import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderProfileCardModel extends StatelessWidget {
  final String picUrl;
  final String name;
  final String location;
  final double distance;
  final int ordernumber;
  final int total;
  const OrderProfileCardModel({
    Key? key,
    required this.picUrl,
    required this.location,
    required this.distance,
    required this.ordernumber,
    required this.total,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 94.w,
            height: double.infinity,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: picUrl,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
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
                              '${LocaleKeys.order_order_nbr.tr()} :',
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
