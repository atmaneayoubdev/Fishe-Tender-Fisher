import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderItemModel extends StatelessWidget {
  const OrderItemModel(
      {Key? key,
      required this.subtotal,
      required this.imagePath,
      required this.orderNbr,
      required this.location,
      required this.date,
      required this.state,
      required this.orderPrice,
      required this.deliveryPrice,
      required this.deliveryBy,
      required this.delivery})
      : super(key: key);
  final String imagePath;
  final String orderNbr;
  final String location;
  final String date;
  final String state;
  final String orderPrice;
  final String deliveryPrice;
  final String deliveryBy;
  final String delivery;
  final String subtotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 375.w,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 100.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$orderNbr',
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryTextColor,
                            ),
                          ),
                          Text(
                            LocaleKeys.order_order_nbr.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      if (state != "6")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (delivery == "0")
                              Text(
                                LocaleKeys.client_deivery.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryGreenColor,
                                ),
                              ),
                            if (delivery == "1")
                              Text(
                                deliveryBy == "3"
                                    ? LocaleKeys.company_delivery.tr()
                                    : deliveryBy == "1"
                                        ? LocaleKeys.store_delivery.tr()
                                        : deliveryBy == "2"
                                            ? LocaleKeys.fisheTender.tr()
                                            : LocaleKeys.delivey_pending_choice
                                                .tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: delivery == "0"
                                      ? kredcolor
                                      : kprimaryGreenColor,
                                ),
                              ),
                            Text(
                              LocaleKeys.delivry_service.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: ksecondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      Container(
                        width: 81.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: state == "1"
                              ? Color.fromRGBO(148, 148, 148, 1)
                              : state == "2"
                                  ? Color.fromRGBO(0, 194, 105, 1)
                                  : state == "3"
                                      ? Colors.orange
                                      : state == "4"
                                          ? Color.fromRGBO(237, 183, 39, 1)
                                          : state == "5"
                                              ? Color.fromRGBO(255, 215, 0, 1)
                                              : Color.fromRGBO(255, 96, 96, 1),
                        ),
                        child: Text(
                          state == "1"
                              ? LocaleKeys.order_pending.tr()
                              : state == "2"
                                  ? LocaleKeys.order_accepted.tr()
                                  : state == "3"
                                      ? LocaleKeys.order_prepered.tr()
                                      : state == "4"
                                          ? LocaleKeys.order_delivery.tr()
                                          : state == "5"
                                              ? LocaleKeys.order_received.tr()
                                              : LocaleKeys.order_rejected.tr(),
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: kprimaryLightColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderPrice,
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryGreenColor,
                            ),
                          ),
                          Text(
                            deliveryBy == "1" && delivery == "1"
                                ? LocaleKeys.order_total_price.tr()
                                : LocaleKeys.price.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      if (deliveryBy == "1" && delivery == "1")
                        Column(
                          children: [
                            Text(
                              subtotal,
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryTextColor,
                              ),
                            ),
                            Text(
                              LocaleKeys.help_and_support_order_price.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: ksecondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      if (deliveryBy == "1" && delivery == "1")
                        Column(
                          children: [
                            Text(
                              deliveryPrice,
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryTextColor,
                              ),
                            ),
                            Text(
                              LocaleKeys.delivery_price.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: ksecondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (delivery == "1")
                        Container(
                          width: 180.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location,
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                LocaleKeys.order_location.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ksecondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              date,
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryTextColor,
                              ),
                            ),
                            Text(
                              LocaleKeys.order_date.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: ksecondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
