import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/models/orders/order_details_model.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Order/components/service_widget.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/components/unit_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class FisheDetailsView extends StatefulWidget {
  final OrdereDtails ordereDtails;
  final String date;

  const FisheDetailsView(
      {Key? key, required this.ordereDtails, required this.date})
      : super(key: key);
  @override
  _FisheDetailsViewState createState() => _FisheDetailsViewState();
}

class _FisheDetailsViewState extends State<FisheDetailsView> {
  //List<Unit> _units = [];

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   await ProductsControlller.getunits(
    //     Provider.of<UserProvider>(context, listen: false).user.token!,
    //   ).then((value) {
    //     setState(() {
    //       _units = value;
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              title: LocaleKeys.product_details.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: widget.ordereDtails.imageUrl,
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
                    height: 20.h,
                  ),
                  Center(
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: UnitWidget(
                        price: widget.ordereDtails.price,
                        name: widget.ordereDtails.unit,
                        isSelected: true,
                      ),
                      // ListView.separated(
                      //   shrinkWrap: true,
                      //   scrollDirection: Axis.horizontal,
                      //   itemCount: _units.length,
                      //   separatorBuilder: (BuildContext context, int index) {
                      //     return SizedBox(width: 15.w);
                      //   },
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return UnitWidget(
                      //       price: widget.ordereDtails.price,
                      //       name: _units[index].name,
                      //       isSelected:
                      //           widget.ordereDtails.unit == _units[index].name
                      //               ? true
                      //               : false,
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.ordereDtails.productName,
                          style: GoogleFonts.tajawal(
                            fontSize: 23.sp,
                            color: kprimaryTextColor,
                          ),
                        ),
                        Container(
                          height: 15.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.clock,
                                color: kprimaryTextColor,
                                size: 16.sp,
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                widget.date,
                                style: GoogleFonts.tajawal(
                                  fontSize: 18.sp,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.w),
                  //   child: Align(
                  //     alignment: context.locale.toLanguageTag() == 'en'
                  //         ? Alignment.centerLeft
                  //         : Alignment.centerRight,
                  //     child: Text(
                  //       LocaleKeys.services.tr(),
                  //       style: GoogleFonts.tajawal(
                  //         fontSize: 20.sp,
                  //         color: kprimaryTextColor,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Align(
                      alignment: context.locale.toLanguageTag() == ("en")
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: TitleWidget(
                          title: LocaleKeys.services.tr(),
                          color: kprimaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 0),
                      child: widget.ordereDtails.services.isNotEmpty
                          ? ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: widget.ordereDtails.services.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 10.h,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return ServiceWidgetOrder(
                                  name:
                                      widget.ordereDtails.services[index].name,
                                  price: widget.ordereDtails.services[index]
                                      .servicePrice,
                                );
                              },
                            )
                          : Center(
                              child: Text(LocaleKeys.no_data.tr(),
                                  style: GoogleFonts.tajawal(
                                      fontSize: 15.sp,
                                      color: kprimaryTextColor,
                                      fontWeight: FontWeight.normal))),
                    ),
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
