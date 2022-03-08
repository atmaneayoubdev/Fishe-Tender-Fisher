import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeliveyChoice extends StatefulWidget {
  const DeliveyChoice(
      {Key? key, required this.order, required this.deliveryPrice})
      : super(key: key);
  final OrderGetDetail order;
  final String deliveryPrice;

  @override
  State<DeliveyChoice> createState() => _DeliveyChoiceState();
}

class _DeliveyChoiceState extends State<DeliveyChoice> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Future.delayed(Duration.zero, () {
          Navigator.pop(context);
        });
        return true;
      },
      child: AlertDialog(
        scrollable: false,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Container(
          height: 200.h,
          width: 345.w,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 21.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleWidget(
                      title: LocaleKeys.delivery_title.tr(),
                      color: kredcolor,
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    Text(
                      LocaleKeys.delivery_body_text.tr(),
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
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await OrderController.setDeliveryBy(
                                    token: Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .token!,
                                    orderId: widget.order.id,
                                    state: "1",
                                  ).then((value) async {
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
                                              value == "Created" ? true : false,
                                          message: value == "Created"
                                              ? LocaleKeys.operation_success
                                                  .tr()
                                              : LocaleKeys.operation_field.tr(),
                                          onPopFunction: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ).then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                child: BottomButton(
                                  title: LocaleKeys.yes.tr(),
                                ),
                              ),
                            ),
                            Container(
                              width: 159.w,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await OrderController.setDeliveryBy(
                                    token: Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .token!,
                                    orderId: widget.order.id,
                                    state: "2",
                                  ).then((value) async {
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
                                              value == "Created" ? true : false,
                                          message: value == "Created"
                                              ? LocaleKeys.operation_success
                                                  .tr()
                                              : LocaleKeys.operation_field.tr(),
                                          onPopFunction: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ).then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
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
              if (isLoading)
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
