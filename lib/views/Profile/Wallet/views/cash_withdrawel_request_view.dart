import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/wallet_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/cash_withdrawal_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CashWithdrawalView extends StatefulWidget {
  CashWithdrawalView({Key? key}) : super(key: key);
  static final String routeName = '/wallet_amount';

  @override
  _CashWithdrawalViewState createState() => _CashWithdrawalViewState();
}

class _CashWithdrawalViewState extends State<CashWithdrawalView> {
  TextEditingController _controllerAmount = TextEditingController();
  var borderColor = kbordercolor;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                AppBarWidget(
                  title: LocaleKeys.wallet_cwr.tr(),
                  cangoback: true,
                  function: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    LocaleKeys.wallet_cwr_body_text.tr(),
                    style: GoogleFonts.getFont(
                      'Tajawal',
                      fontSize: 12.sp,
                      color: ksecondaryTextColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Container(
                  height: 67.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  margin: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 25.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controllerAmount,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '${LocaleKeys.wallet_amount_to_w.tr()}',
                    ),
                    style: GoogleFonts.getFont(
                      'Tajawal',
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_controllerAmount.text == "") {
                          setState(() {
                            borderColor = kredcolor;
                          });
                          return;
                        }
                        if (double.parse(_controllerAmount.text) >
                            double.parse(Provider.of<UserProvider>(context,
                                    listen: false)
                                .user
                                .wallet!)) {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return SnackabrDialog(
                                status: false,
                                message: LocaleKeys.amount_exceeded.tr(),
                                onPopFunction: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                          return;
                        }
                        setState(() {
                          isLoading = true;
                          borderColor = kbordercolor;
                        });
                        await WalletController.withdrawalAuth(
                          token:
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .token!,
                          amount: _controllerAmount.text,
                          message: "hello",
                        ).then((value) {
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
                                    value.containsKey('success') ? true : false,
                                message: value.containsKey('success')
                                    ? LocaleKeys.operation_success.tr()
                                    : value.containsKey('errors') &&
                                            value["errors"]
                                                .containsKey("amount")
                                        ? LocaleKeys.less_amount.tr()
                                        : LocaleKeys.operation_field.tr(),
                                onPopFunction: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ).then((value1) {
                            if (value.containsKey('success'))
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CashVerificationView(
                                    amount: _controllerAmount.text,
                                    message: 'hello from fisher',
                                  ),
                                ),
                              );
                          });
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: BottomButton(
                            title: LocaleKeys.onboarding_next.tr()),
                      ),
                    ),
                  ],
                ))
              ],
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
