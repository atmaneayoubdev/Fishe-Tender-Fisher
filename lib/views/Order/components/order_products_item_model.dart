import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../constants.dart';

class ProductsItemModel extends StatelessWidget {
  const ProductsItemModel({
    Key? key,
    required this.imagePath,
    required this.price,
    required this.quantity,
    required this.title,
    required this.totalServie,
    required this.total,
  }) : super(key: key);
  final String imagePath;
  final String price;
  final String quantity;
  final String title;
  final String totalServie;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 357.76.w,
      height: 101.38.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 109.69.w,
            height: 96.45.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            width: 9.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.getFont(
                  'Tajawal',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: kprimaryTextColor,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                      Text(
                        LocaleKeys.price.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 14.5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalServie,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                      Text(
                        LocaleKeys.services_price.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 14.5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quantity,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                      Text(
                        LocaleKeys.quantity.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 14.5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        total,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                      Text(
                        LocaleKeys.invoices_total.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
