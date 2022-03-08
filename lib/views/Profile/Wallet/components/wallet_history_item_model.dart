import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletHistoryItem extends StatelessWidget {
  final String transactionType;
  final String image;
  final String name;
  final String orderNb;
  final String date;
  final String transaction;
  const WalletHistoryItem(
      {Key? key,
      required this.transactionType,
      required this.name,
      required this.orderNb,
      required this.date,
      required this.transaction,
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
            child: ClipOval(
              child: transactionType == "2"
                  ? SvgPicture.asset(
                      image,
                      color: kprimaryColor,
                    )
                  : CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
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
                    transactionType == "2"
                        ? LocaleKeys.withdrawal.tr()
                        : transactionType == "3"
                            ? LocaleKeys.offers.tr()
                            : name,
                    textDirection: TextDirection.ltr,
                    style: GoogleFonts.getFont('Tajawal',
                        fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      LocaleKeys.wallet_order_number.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ksecondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '#$orderNb',
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: kprimaryGreenColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          date,
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: ksecondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 250.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.transaction_amount.tr(),
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
                        '$transaction' + " " + LocaleKeys.rs.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: transactionType == "1"
                              ? kprimaryGreenColor
                              : kredcolor,
                        ),
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
