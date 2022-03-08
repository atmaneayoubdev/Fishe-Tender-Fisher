import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/models/products/section_model.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../constants.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({
    Key? key,
    required this.imageUrl,
    required this.section,
    required this.type,
    required this.state,
  }) : super(key: key);
  final String state;
  final String imageUrl;
  final String type;
  final Section section;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // showModalBottomSheet<void>(
        //   context: context,
        //   isScrollControlled: true,
        //   enableDrag: true,
        //   backgroundColor: Colors.transparent,
        //   builder: (BuildContext context) {
        //     return OfferBottomSheet2(
        //       amount: amount,
        //       from: from,
        //       to: to,
        //       imageUrl: imageUrl,
        //       section: section,
        //     );
        //   },
        // );
      },
      child: Container(
        height: type == "1" ? 70.h : 200.h,
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        decoration: BoxDecoration(
          color: kprimaryLightColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: kshadowcolor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0.0, 3.0)),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            if (type == "2")
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                height: 130.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        type == "1"
                            ? LocaleKeys.fixed_ad.tr()
                            : LocaleKeys.slide_ad.tr(),
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          color: kprimaryTextColor,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        LocaleKeys.ad_type.tr(),
                        style: GoogleFonts.tajawal(
                          color: ksecondaryTextColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        state == "1"
                            ? LocaleKeys.accepted.tr()
                            : state == "2"
                                ? LocaleKeys.under_review.tr()
                                : LocaleKeys.order_rejected,
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          color: state == "1"
                              ? kprimaryGreenColor
                              : state == "2"
                                  ? kprimaryColor
                                  : kredcolor,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        LocaleKeys.wallet_state.tr(),
                        style: GoogleFonts.tajawal(
                          color: ksecondaryTextColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        section.id == 1
                            ? LocaleKeys.fishe_market.tr()
                            : section.id == 2
                                ? LocaleKeys.freezers.tr()
                                : section.id == 3
                                    ? LocaleKeys.fishe_resto.tr()
                                    : section.id == 4
                                        ? LocaleKeys.sushi.tr()
                                        : LocaleKeys.caviar.tr(),
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                          color: kprimaryTextColor,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        LocaleKeys.section.tr(),
                        style: GoogleFonts.tajawal(
                          color: ksecondaryTextColor,
                          fontSize: 16.sp,
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
    );
  }
}
