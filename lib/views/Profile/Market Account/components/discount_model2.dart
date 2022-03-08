import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/discount_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DiscountModel2 extends StatefulWidget {
  const DiscountModel2({
    Key? key,
    required this.value,
    required this.from,
    required this.to,
    required this.discountId,
  }) : super(key: key);
  final String discountId;
  final String value;
  final String from;
  final String to;
  @override
  _DiscountModel2State createState() => _DiscountModel2State();
}

class _DiscountModel2State extends State<DiscountModel2> {
  double value = 0;
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDatesTo = DateTime.now();
  var color = kprimaryColor;
  var isLoading = false;

  var borderColorFrom = kbordercolor;
  var borderColorTo = kbordercolor;
  @override
  void initState() {
    super.initState();
    value = double.parse(widget.value);
    selectedDateFrom = DateTime.parse(widget.from);
    selectedDatesTo = DateTime.parse(widget.to);
  }

  _selectDateFrom(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom.isBefore(DateTime.now())
          ? DateTime.now()
          : selectedDateFrom,
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
      initialDate: selectedDatesTo,
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
                    value: value,
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
                    onChanged: (dynamic newValue) {
                      setState(() {
                        value = newValue;
                      });
                    },
                  ),
                  //  Slider.adaptive(
                  //   thumbColor: color,
                  //   value: value,
                  //   min: 0,
                  //   max: 100,
                  //   label: "${value.toInt()} %",
                  //   divisions: 100,
                  //   activeColor: kprimaryColor,
                  //   inactiveColor: kprimaryColor,
                  //   onChanged: (newRating) {
                  //     if (mounted)
                  //       setState(() {
                  //         color = kprimaryColor;
                  //         value = newRating;
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
                            print("click to");
                            _selectDateFrom(context);
                          },
                          child: Container(
                            height: 54.h,
                            width: 171.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: borderColorTo,
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
                                  color: borderColorFrom,
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
                    if (value.toInt() == 0) {
                      setState(() {
                        color = kredcolor;
                      });
                      return;
                    }
                    // if (selectedDateFrom.isBefore(DateTime.now())) {
                    //   setState(() {
                    //     borderColorTo = kredcolor;
                    //   });
                    //   return;
                    // }
                    if (selectedDateFrom.isBefore(selectedDatesTo)) {
                      if (mounted)
                        setState(() {
                          isLoading = true;
                        });
                      await DiscountConroller.editDiscount(
                        token: Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).user.token!,
                        from:
                            "${selectedDateFrom.year}-${selectedDateFrom.month}-${selectedDateFrom.day}",
                        to: "${selectedDatesTo.year}-${selectedDatesTo.month}-${selectedDatesTo.day}",
                        discountId: widget.discountId,
                        value: value.toString(),
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
                              status: value == 'Created' ? true : false,
                              message: value == 'Created'
                                  ? LocaleKeys.order_update_message.tr()
                                  : LocaleKeys.operation_field.tr(),
                              onPopFunction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ).then(
                          (value) => Navigator.pop(context, true),
                        );
                      });
                    } else {
                      if (mounted)
                        setState(() {
                          borderColorTo = kredcolor;
                          borderColorFrom = kredcolor;
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
            ),
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
