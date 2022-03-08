import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/discount_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:syncfusion_flutter_sliders/sliders.dart';

class DiscountModel extends StatefulWidget {
  const DiscountModel({Key? key, required this.prouctId}) : super(key: key);
  final int prouctId;

  @override
  _DiscountModelState createState() => _DiscountModelState();
}

class _DiscountModelState extends State<DiscountModel> {
  double val = 0;
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDatesTo = DateTime.now();
  var borderColor = kbordercolor;
  bool isLoading = false;
  var color = kprimaryColor;

  _selectDateFrom(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDateFrom) {
      if (mounted)
        setState(() {
          selectedDateFrom = selected;
        });
    }
  }

  _selectDateTo(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDatesTo) {
      if (mounted)
        setState(() {
          selectedDatesTo = selected;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        color: kprimaryLightColor,
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(
                  title: LocaleKeys.offer_discount_discount.tr(),
                  color: kprimaryColor,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  LocaleKeys.offer_discount_discount_per.tr(),
                  style: GoogleFonts.getFont(
                    'Tajawal',
                    fontSize: 16.sp,
                    color: ksecondaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Container(
                  height: 52.31.h,
                  width: 351.w,
                  child: SfSlider(
                    min: 0.0,
                    max: 100.0,
                    labelPlacement: LabelPlacement.onTicks,
                    value: val,
                    interval: 20,
                    showTicks: false,
                    showLabels: false,
                    enableTooltip: true,
                    tooltipTextFormatterCallback:
                        (dynamic actualValue, String formattedText) {
                      double val = actualValue;
                      return val.toStringAsFixed(0);
                    },
                    minorTicksPerInterval: 1,
                    onChanged: (dynamic value) {
                      setState(() {
                        val = value;
                      });
                    },
                  ),
                  //  Slider.adaptive(
                  //   thumbColor: color,
                  //   value: val,
                  //   min: 0,
                  //   max: 100,
                  //   label: "${val.toInt()} %",
                  //   divisions: 100,
                  //   activeColor: kprimaryColor,
                  //   inactiveColor: kprimaryColor,
                  //   onChanged: (newRating) {
                  //     if (mounted)
                  //       setState(() {
                  //         color = kprimaryColor;
                  //         val = newRating;
                  //       });
                  //   },
                  // ),
                ),
                SizedBox(
                  height: 9.h,
                ),
                Row(
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
                        GestureDetector(
                          onTap: () {
                            _selectDateFrom(context);
                          },
                          child: Container(
                            height: 54.h,
                            width: 171.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: borderColor,
                                )),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 14.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${selectedDateFrom.year}-${selectedDateFrom.month}-${selectedDateFrom.day}",
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
                        GestureDetector(
                          onTap: () {
                            _selectDateTo(context);
                          },
                          child: Container(
                            height: 54.h,
                            width: 171.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: borderColor,
                                )),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 14.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${selectedDatesTo.year}-${selectedDatesTo.month}-${selectedDatesTo.day}",
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
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (val.toInt() == 0) {
                      setState(() {
                        color = kredcolor;
                      });

                      return;
                    }
                    if (selectedDateFrom.isBefore(selectedDatesTo)) {
                      if (mounted)
                        setState(() {
                          isLoading = true;
                        });
                      await DiscountConroller.postDiscount(
                        token: Provider.of<UserProvider>(context, listen: false)
                            .user
                            .token!,
                        from:
                            "${selectedDateFrom.year}-${selectedDateFrom.month}-${selectedDateFrom.day}",
                        to: "${selectedDatesTo.year}-${selectedDatesTo.month}-${selectedDatesTo.day}",
                        produtId: widget.prouctId,
                        value: val.toInt(),
                      ).then((value) {
                        if (mounted)
                          setState(() {
                            isLoading = false;
                          });
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return SnackabrDialog(
                              status:
                                  value.containsKey("success") ? true : false,
                              message: value.containsKey("success")
                                  ? LocaleKeys.discount_addition.tr()
                                  : value["errors"]
                                          .containsKey("fisher_product_id")
                                      ? LocaleKeys.pending_discount.tr()
                                      : LocaleKeys.operation_field.tr(),
                              onPopFunction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ).then((value) => Navigator.pop(context, true));
                      });
                    } else {
                      if (mounted)
                        setState(() {
                          borderColor = kredcolor;
                        });
                    }
                  },
                  child: Container(
                    child: BottomButton(title: LocaleKeys.save.tr()),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
//
//
//
//
//
//
//
//
  }
}
