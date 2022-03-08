import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderRejectModel extends StatefulWidget {
  const OrderRejectModel({Key? key, required this.order}) : super(key: key);
  final OrderGetDetail order;

  @override
  _OrderRejectModelState createState() => _OrderRejectModelState();
}

class _OrderRejectModelState extends State<OrderRejectModel> {
  TextEditingController _textEditingController = TextEditingController();
  bool isLoading = false;
  var borderColor = kbordercolor;
  @override
  void initState() {
    _textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  var val;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        color: kprimaryLightColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
      child: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(
                  title: LocaleKeys.order_reject_order.tr(),
                  color: kredcolor,
                ),
                SizedBox(
                  height: 7.h,
                ),
                Text(
                  LocaleKeys.order_reject_text.tr(),
                  style: GoogleFonts.getFont(
                    'Tajawal',
                    fontSize: 12.sp,
                    color: ksecondaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Expanded(
                  child: Container(
                    height: 120.56.h,
                    width: 361.65.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: borderColor,
                    )),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: TextField(
                      scrollPadding: EdgeInsets.zero,
                      controller: _textEditingController,
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        color: kprimaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: LocaleKeys.help_and_support_delete_hint.tr(),
                        hintStyle: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 13.sp,
                          color: ksecondaryTextColor,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 23.7.h,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_textEditingController.text.isEmpty) {
                      setState(() {
                        borderColor = kredcolor;
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await OrderController.cancelOrder(
                        token: Provider.of<UserProvider>(context, listen: false)
                            .user
                            .token!,
                        id: widget.order.id,
                        message: _textEditingController.text,
                      ).then((value) {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return SnackabrDialog(
                              status: true,
                              message: value == 'Created'
                                  ? LocaleKeys.request_sent_success.tr()
                                  : LocaleKeys.operation_field.tr(),
                              onPopFunction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        )
                            .then((value) => Navigator.pop(context))
                            .then((value) => Navigator.pop(context, true));
                      });
                    }
                  },
                  child: Container(
                    child: BottomButton(
                      title: LocaleKeys.order_send_cancel.tr(),
                      color: kprimaryLightColor,
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
