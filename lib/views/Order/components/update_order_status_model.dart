import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderStatusModel extends StatefulWidget {
  const OrderStatusModel({Key? key, required this.order}) : super(key: key);
  final OrderGetDetail order;

  @override
  _OrderStatusModelState createState() => _OrderStatusModelState();
}

class _OrderStatusModelState extends State<OrderStatusModel> {
  var val;
  var isLoading = false;
  @override
  void initState() {
    val = widget.order.state;
    print(
      'this is the current stat : ' + val.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
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
                  title: LocaleKeys.update_order_status.tr(),
                  color: kprimaryColor,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 21.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 18.h,
                        width: 18.w,
                        child: Radio(
                          value: 2,
                          groupValue: val,
                          onChanged: (value) {
                            if (val < value)
                              setState(() {
                                val = value;
                              });
                          },
                          activeColor: kprimaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        LocaleKeys.accepted.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ksecondaryTextColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 21.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 18.h,
                        width: 18.w,
                        child: Radio(
                          value: 3,
                          groupValue: val,
                          onChanged: (value) {
                            if (val < value)
                              setState(() {
                                val = value;
                              });
                          },
                          activeColor: kprimaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        LocaleKeys.prepered.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ksecondaryTextColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 21.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 18.h,
                        width: 18.w,
                        child: Radio(
                          value: 4,
                          groupValue: val,
                          onChanged: (value) {
                            if (val < value)
                              setState(() {
                                val = value;
                              });
                          },
                          activeColor: kprimaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        LocaleKeys.order_delivery.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ksecondaryTextColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                if (widget.order.deliveryBy == "1")
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 21.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: 18.w,
                          child: Radio(
                            value: 2,
                            groupValue: val,
                            onChanged: (value) {
                              if (val < value)
                                setState(() {
                                  val = value;
                                });
                            },
                            activeColor: kprimaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          LocaleKeys.order_received.tr(),
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    OrderController.updateOrderState(
                      Provider.of<UserProvider>(context, listen: false)
                          .user
                          .token!,
                      widget.order.id,
                      val,
                    ).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      if (value == 'Created') {
                        Navigator.of(context).pop();
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return SnackabrDialog(
                              status: true,
                              message:
                                  LocaleKeys.order_state_update_success.tr(),
                              onPopFunction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      }
                    });
                  },
                  child: Container(
                    child: BottomButton(title: LocaleKeys.order_update.tr()),
                  ),
                )
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
  }
}
