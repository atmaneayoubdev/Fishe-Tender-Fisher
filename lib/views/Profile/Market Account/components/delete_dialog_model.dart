import 'dart:ui';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/discount_controller.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeleteDialogModel extends StatefulWidget {
  const DeleteDialogModel(
      {Key? key, required this.id, required this.isDiscount})
      : super(key: key);
  final int id;
  final bool isDiscount;

  @override
  State<DeleteDialogModel> createState() => _DeleteDialogModelState();
}

class _DeleteDialogModelState extends State<DeleteDialogModel> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 222.h,
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
                    title: LocaleKeys.delete_discount.tr(),
                    color: kprimaryColor,
                  ),
                  SizedBox(
                    height: 21.h,
                  ),
                  Text(
                    LocaleKeys.market_account_delete_text.tr(),
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
                    LocaleKeys.market_account_delete_body_text.tr(),
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
                          GestureDetector(
                            onTap: () async {
                              if (!widget.isDiscount) {
                                if (mounted)
                                  setState(() {
                                    isLoading = true;
                                  });
                                await ProductsControlller.deleteFisherProduct(
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user
                                            .token!,
                                        widget.id)
                                    .then((value) {
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
                                        status: true,
                                        message: LocaleKeys
                                            .market_account_delete_message
                                            .tr(),
                                        onPopFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ).then((value) {
                                    Navigator.pop(context, true);
                                  });
                                });
                              } else {
                                if (mounted)
                                  setState(() {
                                    isLoading = true;
                                  });
                                await DiscountConroller.deleteDiscount(
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user
                                            .token!,
                                        widget.id)
                                    .then((value) {
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
                                        status: value == 'OK' ? true : false,
                                        message: value == "OK"
                                            ? LocaleKeys.operation_success
                                                .tr()
                                                .tr()
                                            : LocaleKeys.operation_field.tr(),
                                        onPopFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ).then((value) {
                                    Navigator.pop(context, true);
                                  });
                                });
                              }
                            },
                            child: Container(
                              width: 159.w,
                              child: BottomButton(
                                title: LocaleKeys.yes.tr(),
                              ),
                            ),
                          ),
                          Container(
                            width: 159.w,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context, false);
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
    );
  }
}
