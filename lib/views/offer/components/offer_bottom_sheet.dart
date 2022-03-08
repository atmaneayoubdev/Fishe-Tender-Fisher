import 'package:fishe_tender_fisher/common/section_shimmer.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/models/products/section_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/common/section_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class OfferBottomSheet2 extends StatefulWidget {
  const OfferBottomSheet2(
      {Key? key,
      required this.section,
      required this.imageUrl,
      required this.from,
      required this.to,
      required this.amount})
      : super(key: key);
  final Section section;
  final String imageUrl;
  final String from;
  final String to;
  final String amount;
  @override
  _OfferBottomSheet2State createState() => _OfferBottomSheet2State();
}

class _OfferBottomSheet2State extends State<OfferBottomSheet2> {
  late List<Section> _sections = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await ProductsControlller.getSectionList(
              Provider.of<UserProvider>(context, listen: false).user.token!)
          .then((value) {
        setState(() {
          _sections = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 530.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        color: kprimaryLightColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: TitleWidget(
              title: LocaleKeys.offer_discount_advertising.tr(),
              color: kprimaryColor,
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          Container(
            padding: context.locale.toLanguageTag() == 'en'
                ? EdgeInsets.only(left: 10.w)
                : EdgeInsets.only(left: 10.w),
            height: 90.h,
            child: _sections.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(right: 10.w),
                    itemCount: _sections.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      Section _section = _sections[index];

                      return SectionItem(
                        id: _section.id,
                        name: _section.id == 1
                            ? LocaleKeys.fishe_market.tr().tr()
                            : _section.id == 2
                                ? LocaleKeys.freezers.tr()
                                : _section.id == 3
                                    ? LocaleKeys.fishe_resto.tr()
                                    : _section.id == 4
                                        ? LocaleKeys.sushi.tr()
                                        : LocaleKeys.caviar.tr(),
                        imagePath: _section.id == 1
                            ? 'assets/images/fisheMarket.png'
                            : _section.id == 2
                                ? 'assets/images/Freezers.png'
                                : _section.id == 3
                                    ? 'assets/images/fishe_restaurants.png'
                                    : _section.id == 4
                                        ? 'assets/images/sushi.png'
                                        : 'assets/images/caviar.png',
                        isSelected:
                            widget.section.id == _section.id ? true : false,
                        isActive: _section.isActive,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 10.w);
                    },
                  )
                : ListView.separated(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return SectionShimmer();
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 10.w);
                    },
                  ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 19.w),
            child: Text(
              LocaleKeys.offer_discount_advertising_picture.tr(),
              style: GoogleFonts.getFont(
                'Tajawal',
                fontSize: 16.sp,
                color: ksecondaryTextColor,
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 19.w),
            width: double.infinity,
            height: 97.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: klightbleucolor,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: kbordercolor),
            ),
            child: Image.network(widget.imageUrl),
          ),
          SizedBox(
            height: 41.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.market_account_from.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        color: ksecondaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      height: 54.h,
                      width: 171.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: kbordercolor,
                          )),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.from,
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 16.sp,
                                color: kprimaryTextColor,
                              ),
                            ),
                            Icon(
                              Icons.date_range,
                              size: 16.sp,
                              color: ksecondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.market_account_to.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        color: ksecondaryTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      height: 54.h,
                      width: 171.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: kbordercolor,
                          )),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.to,
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 16.sp,
                                color: kprimaryTextColor,
                              ),
                            ),
                            Icon(
                              Icons.date_range,
                              size: 16.sp,
                              color: ksecondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 21.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17.w),
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${LocaleKeys.offer_discount_Amount.tr()} : ',
                    style: GoogleFonts.getFont(
                      'Cairo',
                      fontSize: 24.sp,
                      color: kprimaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: widget.amount,
                    style: GoogleFonts.getFont(
                      'Cairo',
                      fontSize: 24.sp,
                      color: kprimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: LocaleKeys.rs.tr(),
                    style: GoogleFonts.getFont(
                      'Cairo',
                      fontSize: 24.sp,
                      color: kprimaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
