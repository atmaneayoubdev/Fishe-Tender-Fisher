import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';

import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Order/components/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class OrderProfileView extends StatefulWidget {
  final Order2 order;
  final String picUrl;
  final String name;
  final String phone;
  final String email;
  final String totalorders;
  final String totalPrice;

  const OrderProfileView(
      {Key? key,
      required this.order,
      required this.picUrl,
      required this.name,
      required this.phone,
      required this.email,
      required this.totalorders,
      required this.totalPrice})
      : super(key: key);
  @override
  _OrderProfileViewState createState() => _OrderProfileViewState();
}

class _OrderProfileViewState extends State<OrderProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: widget.name,
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 21.h,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.w,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 86.5.h,
                            width: 86.5.w,
                            child: ClipOval(
                              child: Hero(
                                tag: "img" + widget.order.user.picUrl,
                                child: CachedNetworkImage(
                                  imageUrl: widget.picUrl,
                                  fit: BoxFit.contain,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 21.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => ProfileOrdersView(
                              //           order: widget.order,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Icon(
                              //         Icons.history,
                              //         size: 12.sp,
                              //         color: kprimaryColor,
                              //       ),
                              //       SizedBox(
                              //         width: 5.w,
                              //       ),
                              //       Text(
                              //         LocaleKeys.order_orders_hist.tr(),
                              //         style: GoogleFonts.getFont(
                              //           'Tajawal',
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w600,
                              //           color: kprimaryColor,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    Divider(),
                    SizedBox(
                      height: 13.5.h,
                    ),
                    Text(
                      LocaleKeys.order_personal_info.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    Text(
                      LocaleKeys.order_username.tr(),
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ksecondaryTextColor),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      widget.name,
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      LocaleKeys.order_phone_nbr.tr(),
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ksecondaryTextColor),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      widget.phone,
                      textDirection: TextDirection.ltr,
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      LocaleKeys.order_email.tr(),
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ksecondaryTextColor),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      widget.email,
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: kprimaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      LocaleKeys.order_total_order.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ksecondaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      '${widget.totalorders}',
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: kprimaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      LocaleKeys.order_total_price.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ksecondaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      '${widget.totalPrice}' + " " + LocaleKeys.rs.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: kprimaryTextColor,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        UrlLauncher.launch("tel://${widget.order.user.phone}");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 56.0.h,
                        decoration: BoxDecoration(
                          color: kprimaryColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              color: kprimaryLightColor,
                              size: 15.sp,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              LocaleKeys.order_call.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: kprimaryLightColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (widget.order.delivery == "1" &&
                        widget.order.deliveryBy == "1")
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            enableDrag: false,
                            builder: (BuildContext context) {
                              return UserLocations(
                                latLng: new LatLng(
                                  double.parse(widget.order.latitude),
                                  double.parse(widget.order.longitude),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 56.0.h,
                          decoration: BoxDecoration(
                            color: kprimaryColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city_outlined,
                                color: kprimaryLightColor,
                                size: 15.sp,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                LocaleKeys.order_address.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: kprimaryLightColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
