import 'dart:async';
import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/succes_dialog.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/wallet_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

class CashVerificationView extends StatefulWidget {
  static final String routeName = '/Cash_Verification_View';
  final String amount;
  final String message;

  const CashVerificationView(
      {Key? key, required this.amount, required this.message})
      : super(key: key);

  @override
  _CashVerificationViewState createState() => _CashVerificationViewState();
}

class _CashVerificationViewState extends State<CashVerificationView> {
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController _controlerPin = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _buttonTitle = LocaleKeys.Auth_verify_button.tr();
  String _appbarTitle = LocaleKeys.Auth_appbar_title2.tr();
  bool hasError = false;
  String currentText = '';
  int _start = 30;
  int _current = 30;
  bool canResend = false;
  int resendCount = 1;
  bool iVerifying = false;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if (_current != -1)
        setState(() {
          _current = _start - duration.elapsed.inSeconds;
        });
    });

    sub.onDone(() {
      if (_current != -1)
        setState(() {
          canResend = true;
        });
      print("Done");
      sub.cancel();
    });
  }

  Future<void> _authVerify() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        iVerifying = true;
      });
      await WalletController.postWithdrawal(
        token: Provider.of<UserProvider>(context, listen: false).user.token!,
        amount: widget.amount,
        message: widget.message,
        code: _controlerPin.text,
      ).then((value) {
        if (value == 'Created') {
          setState(() {
            _current = -1;
            iVerifying = false;
          });
          showModal(
            context: context,
            configuration: FadeScaleTransitionConfiguration(
              transitionDuration: Duration(
                milliseconds: 400,
              ),
              reverseTransitionDuration: Duration(
                milliseconds: 400,
              ),
            ),
            builder: (BuildContext context) {
              return SuccesDialog(
                title: LocaleKeys.offer_discount_succes_dialog_text.tr(),
              );
            },
          ).then((value) => Navigator.pop(context));
        } else {
          setState(() {
            iVerifying = false;
          });
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return SnackabrDialog(
                status: false,
                message: LocaleKeys.operation_field.tr(),
                onPopFunction: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        }
      });
    }
  }

  @override
  void initState() {
    startTimer();

    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  Future<bool> _willPopScopeCall() async {
    setState(() {
      _current = -1;
    });
    return true; // return true to exit app or return false to cancel exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScopeCall,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppBarWidget(
                    title: _appbarTitle,
                    cangoback: true,
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    alignment: context.locale.toLanguageTag() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    margin: EdgeInsets.only(left: 16.0.w, right: 16.w),
                    height: 24.0.h,
                    child: Text(
                      LocaleKeys.wallet_enter_code.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 24.sp,
                        color: kprimaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    height: 50.48.h,
                    margin: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                    child: Text(
                      LocaleKeys.wallet_verification_text.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        color: ksecondaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: context.locale.toLanguageTag() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                        margin: EdgeInsets.only(left: 16.0.w, right: 16.w),
                        height: 49.43.h,
                        width: 326.44.w,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: PinCodeTextField(
                            enablePinAutofill: true,
                            autovalidateMode: AutovalidateMode.disabled,
                            appContext: context,
                            length: 5,
                            textStyle: TextStyle(fontSize: 18.sp),
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            cursorColor: Colors.black,
                            animationDuration: Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: _controlerPin,
                            keyboardType: TextInputType.number,
                            showCursor: false,
                            pastedTextStyle: TextStyle(
                              color: ksecondaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (v) {
                              if (v!.length < 5) {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return SnackabrDialog(
                                      status: false,
                                      message: LocaleKeys.Auth_false_pin.tr(),
                                      onPopFunction: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                                return '';
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              disabledColor: kbordercolor,
                              inactiveFillColor: Colors.white,
                              inactiveColor: kbordercolor,
                              selectedFillColor: kprimaryColor,
                              selectedColor: kbordercolor,
                              activeColor: kbordercolor,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 49.43.h,
                              fieldWidth: 49.43.w,
                              activeFillColor: hasError
                                  ? Colors.blue.shade100
                                  : Colors.white,
                            ),
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              return true;
                            },
                          ),
                        )),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 19.0.w, right: 19.0.w),
                    child: GestureDetector(
                      child: BottomButton(title: _buttonTitle),
                      onTap: _authVerify,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 31.0.h,
                    child: resendCount < 3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  LocaleKeys.Auth_get_the_code.tr(),
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    fontSize: 14.sp,
                                    color: kprimaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.7.w),
                              Container(
                                width: 75.0.w,
                                decoration: BoxDecoration(
                                  color: kprimaryLightColor,
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: canResend
                                        ? kprimaryColor
                                        : ksecondaryTextColor,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    if (canResend) {
                                      setState(() {
                                        canResend = false;
                                        resendCount++;
                                        _current = 30;
                                        startTimer();
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 1400),
                                          () async {
                                        await WalletController.withdrawalAuth(
                                          token: Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .user
                                              .token!,
                                          amount: widget.amount,
                                          message: "hello",
                                        ).then((value0) {
                                          // setState(() {
                                          //   isLoading = false;
                                          // });
                                          print(value0);
                                          showModalBottomSheet<void>(
                                            context: context,
                                            isScrollControlled: true,
                                            enableDrag: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context) {
                                              return SnackabrDialog(
                                                status: value0
                                                        .containsKey('success')
                                                    ? true
                                                    : false,
                                                message: value0
                                                        .containsKey('success')
                                                    ? value0["data"][0]
                                                        .toString()
                                                    : LocaleKeys.operation_field
                                                        .tr(),
                                                onPopFunction: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          );
                                        });
                                      });
                                      setState(() {
                                        _controlerPin.clear();
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(2.w),
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: canResend
                                        ? Text(
                                            LocaleKeys.Auth_resend_code.tr(),
                                            style: GoogleFonts.getFont(
                                              'Tajawal',
                                              color: ksecondaryTextColor,
                                              fontSize: 13.sp,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            _current != 0 ? "$_current" : "",
                                            style: GoogleFonts.tajawal(
                                                fontSize: 20.sp,
                                                color: kprimaryColor),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            child: Text(
                              "Try later please",
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 14.sp,
                                color: kredcolor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 24.3.h,
                  ),
                ],
              ),
            ),
            if (iVerifying)
              Container(
                color: Colors.black45,
                child: Center(child: CircularProgressIndicator()),
              )
          ],
        ),
      ),
    );
  }
}
