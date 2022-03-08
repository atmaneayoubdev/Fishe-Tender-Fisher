import 'package:fishe_tender_fisher/common/offer_bottom_sheet.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_details_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MarketCardView extends StatefulWidget {
  const MarketCardView({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  _MarketCardViewState createState() => _MarketCardViewState();
}

class _MarketCardViewState extends State<MarketCardView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: widget.height,
      width: 363.w,
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.only(top: 14.h, right: 14.w, left: 14.w),
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
              color: kshadowcolor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0.0, 3.0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: context.locale.toLanguageTag() == "en"
                      ? widget.height == 120.h
                          ? 150.w
                          : 310.w
                      : widget.height == 120.h
                          ? 145.w
                          : 310.w,
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 400),
                    style: TextStyle(
                      fontSize: widget.height == 120.h ? 20.sp : 30.sp,
                    ),
                    child: Text(
                      context.locale.toLanguageTag() == "ar"
                          ? Provider.of<UserProvider>(context, listen: true)
                              .user
                              .nameAr!
                          : Provider.of<UserProvider>(context, listen: true)
                              .user
                              .name!,
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontWeight: FontWeight.bold,
                        color: kprimaryTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.height == 120.h)
                        InkWell(
                          onTap: () {
                            if (Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .status ==
                                "2") {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return OfferBottomSheet(
                                    addOffer: true,
                                  );
                                },
                              );
                            } else {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return SnackabrDialog(
                                    status: false,
                                    message:
                                        LocaleKeys.account_under_review.tr(),
                                    onPopFunction: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            }
                          },
                          splashColor: ksecondaryColor,
                          child: AnimatedContainer(
                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                            duration: Duration(milliseconds: 400),
                            curve: Curves.bounceInOut,
                            height: widget.height == 120.h ? 28.h : 0,
                            decoration: BoxDecoration(
                              border: Border.all(color: kprimaryColor),
                              color: kprimaryLightColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(50.r),
                              boxShadow: [
                                BoxShadow(
                                    color: widget.height == 120.h
                                        ? kshadowcolor
                                        : Colors.transparent,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0.0, 3.0)),
                              ],
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 400),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kprimaryTextColor,
                                  //height: 1.5,
                                ),
                                child: Text(
                                  LocaleKeys.paid_ads.tr(),
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: kprimaryTextColor,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 10.w,
                      ),
                      if (widget.height == 120.h)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MarketDetailsView(
                                        fromNumberInput: false,
                                      )),
                            );
                          },
                          splashColor: ksecondaryColor,
                          child: AnimatedContainer(
                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                            duration: Duration(milliseconds: 400),
                            curve: Curves.bounceInOut,
                            height: widget.height == 120.h ? 28.h : 0,
                            decoration: BoxDecoration(
                              border: Border.all(color: kprimaryColor),
                              color: kprimaryLightColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(50.r),
                              boxShadow: [
                                BoxShadow(
                                    color: widget.height == 120.h
                                        ? kshadowcolor
                                        : Colors.transparent,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0.0, 3.0)),
                              ],
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 400),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kprimaryTextColor,
                                  //height: 1.5,
                                ),
                                child: Text(
                                  LocaleKeys.my_store.tr(),
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: kprimaryTextColor,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.bounceInOut,
                height: widget.height == 120.h ? 28.h : 0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: LocaleKeys.wallet_state.tr() + ": ",
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ksecondaryTextColor,
                        ),
                      ),
                      TextSpan(
                        text: Provider.of<UserProvider>(
                                  context,
                                  listen: true,
                                ).user.status ==
                                "2"
                            ? LocaleKeys.active.tr()
                            : LocaleKeys.inactive.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Provider.of<UserProvider>(
                                    context,
                                    listen: true,
                                  ).user.status ==
                                  "2"
                              ? kprimaryGreenColor
                              : kredcolor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
          // SizedBox(
          //   height: 12.h,
          // ),
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: widget.height == 120.h ? 20.h : 0,
            child: Row(
              children: [
                Container(
                  width: Provider.of<UserProvider>(context, listen: true)
                              .user
                              .rate ==
                          "null"
                      ? 85.w
                      : 52.w,
                  height: widget.height == 120.h ? 20.h : 0,
                  decoration: BoxDecoration(
                    border: Border.all(color: kprimaryColor),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Provider.of<UserProvider>(context, listen: true)
                                    .user
                                    .rate ==
                                "null"
                            ? ksecondaryTextColor
                            : kprimaryColor,
                        size: widget.height == 120.h ? 16.sp : 0,
                      ),
                      SizedBox(width: 5.w),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        child: Text(
                          Provider.of<UserProvider>(
                                    context,
                                    listen: true,
                                  ).user.rate ==
                                  "null"
                              ? LocaleKeys.new_fisher.tr()
                              : '${Provider.of<UserProvider>(
                                  context,
                                  listen: true,
                                ).user.rate}',
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color:
                                Provider.of<UserProvider>(context, listen: true)
                                            .user
                                            .rate ==
                                        "null"
                                    ? ksecondaryTextColor
                                    : kprimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  width: 130.w,
                  height: widget.height == 120.h ? 20.h : 0,
                  decoration: BoxDecoration(
                    color: kshadowcolor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/ic_card_clock.svg"),
                      SizedBox(width: 7.w),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        child: Text(
                          '${Provider.of<UserProvider>(context, listen: true).user.startWorkTime} AM - ${Provider.of<UserProvider>(context, listen: true).user.endWorkTime} PM',
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: kprimaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: 10.w,
                // ),
                // Container(
                //   width: 84.w,
                //   height: 20.h,
                //   decoration: BoxDecoration(
                //     color: kshadowcolor,
                //     borderRadius: BorderRadius.circular(5.r),
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(
                //         Icons.calendar_today,
                //         color: kprimaryTextColor,
                //         size: widget.height == 120.h ? 16.sp : 0,
                //       ),
                //       SizedBox(width: 7.w),
                //       Container(
                //         margin: EdgeInsets.only(top: 4.h),
                //         child: Text(
                //           'Mon - Fri',
                //           style: GoogleFonts.getFont(
                //             'Tajawal',
                //             fontSize: 11.sp,
                //             fontWeight: FontWeight.w700,
                //             color: kprimaryTextColor,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  width: 10.w,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  width: 90.w,
                  height: widget.height == 120.h ? 20.h : 0,
                  decoration: BoxDecoration(
                    color: kshadowcolor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/ic_card_location.svg"),
                      SizedBox(width: 7.w),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        child: Text(
                          Provider.of<UserProvider>(context, listen: true)
                              .user
                              .city!,
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: kprimaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // AnimatedContainer(
          //   duration: Duration(milliseconds: 400),
          //   height: widget.height == 120.h ? 16.h : 0,
          // ),
          // if (widget.height == 120.h)
          //   SingleChildScrollView(
          //     physics: NeverScrollableScrollPhysics(),
          //     child: AnimatedContainer(
          //       duration: Duration(milliseconds: 400),
          //       height: widget.height == 120.h ? 45.h : 0,
          //       child: Row(
          //         children: [
          //           Container(
          //             height: 40.h,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   '${Provider.of<UserProvider>(context, listen: true).user.lowestPrice!}' +
          //                       LocaleKeys.rs.tr(),
          //                   style: GoogleFonts.getFont(
          //                     'Tajawal',
          //                     fontSize: 12.sp,
          //                     fontWeight: FontWeight.w600,
          //                     color: kprimaryTextColor,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 6.h,
          //                 ),
          //                 Container(
          //                   width: 90.w,
          //                   child: Text(
          //                     LocaleKeys.market_account_lowest_price.tr(),
          //                     style: GoogleFonts.getFont(
          //                       'Tajawal',
          //                       fontSize: 12.sp,
          //                       fontWeight: FontWeight.w600,
          //                       color: ksecondaryTextColor,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           SizedBox(
          //             width: 26.w,
          //           ),
          //           Container(
          //             height: 40.h,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   '${Provider.of<UserProvider>(context, listen: true).user.deliveryPrice} SR',
          //                   style: GoogleFonts.getFont(
          //                     'Tajawal',
          //                     fontSize: 12.sp,
          //                     fontWeight: FontWeight.w600,
          //                     color: kprimaryTextColor,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 6.h,
          //                 ),
          //                 Container(
          //                   width: 90.w,
          //                   child: Text(
          //                     LocaleKeys.market_account_deliver_price.tr(),
          //                     style: GoogleFonts.getFont(
          //                       'Tajawal',
          //                       fontSize: 12.sp,
          //                       fontWeight: FontWeight.w600,
          //                       color: ksecondaryTextColor,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           SizedBox(
          //             width: 26.w,
          //           ),
          //           Container(
          //             height: 40.h,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   context.locale.toLanguageTag() == "en"
          //                       ? '1 To 7 Days'
          //                       : '  1  ' +
          //                           LocaleKeys.market_account_to.tr() +
          //                           '  7  ' +
          //                           LocaleKeys.days.tr(),
          //                   style: GoogleFonts.getFont(
          //                     'Tajawal',
          //                     fontSize: 12.sp,
          //                     fontWeight: FontWeight.w600,
          //                     color: kprimaryTextColor,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 6.h,
          //                 ),
          //                 Container(
          //                   width: 80.w,
          //                   child: Text(
          //                     LocaleKeys.market_account_delivery_time.tr(),
          //                     style: GoogleFonts.getFont(
          //                       'Tajawal',
          //                       fontSize: 12.sp,
          //                       fontWeight: FontWeight.w600,
          //                       color: ksecondaryTextColor,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
