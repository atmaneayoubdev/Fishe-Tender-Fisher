import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/views/Order/components/reject_order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelOrderModel extends StatelessWidget {
  const CancelOrderModel({Key? key, required this.order}) : super(key: key);
  final OrderGetDetail order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 222.h,
        width: 345.w,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 21.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(
              title: LocaleKeys.order_cancel_order.tr(),
              color: kredcolor,
            ),
            SizedBox(
              height: 21.h,
            ),
            Text(
              LocaleKeys.order_cancel_text.tr(),
              style: GoogleFonts.getFont(
                'Tajawal',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: kprimaryTextColor,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              LocaleKeys.order_cancel_body_text.tr(),
              style: GoogleFonts.getFont(
                'Tajawal',
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                color: ksecondaryTextColor,
              ),
            ),
            Expanded(
              child: Container(
                width: 325.w,
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 159.w,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          showModalBottomSheet<Map<dynamic, dynamic>>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: OrderRejectModel(
                                  order: order,
                                ),
                              ));
                            },
                          );
                        },
                        child: BottomButton(
                          title: LocaleKeys.yes.tr(),
                        ),
                      ),
                    ),
                    Container(
                      width: 159.w,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: BottomButton(
                          title: LocaleKeys.no.tr(),
                          bgcolor: kprimaryLightColor,
                          bordercolor: kprimaryColor,
                          color: kprimaryColor,
                        ),
                      ),
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
