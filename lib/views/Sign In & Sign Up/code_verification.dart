import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';

import 'package:fishe_tender_fisher/services/order_count.dart';
import 'package:fishe_tender_fisher/services/recent_orders.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_details_view.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/number_input.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth_controller.dart';

class CodeVerification extends StatefulWidget {
  static final String routeName = '/code_verification_screen';

  final String phoneNumber;
  final CountryCode countrycode;

  const CodeVerification(
      {required this.phoneNumber, required this.countrycode});

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  var _phoneNumberController;
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  var _pinController;

  final _formKey = GlobalKey<FormState>();
  String _buttonTitle = LocaleKeys.Auth_verify_button.tr();
  String _appbarTitle = LocaleKeys.Auth_appbar_title2.tr();
  bool hasError = false;
  String currentText = "";
  bool _isverifying = false;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  int _start = 30;
  int _current = 30;
  bool canResend = false;
  int resendCount = 1;
  var borderColor = kbordercolor;
  var isVerifying = false;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if (_current != -1) if (mounted) if (mounted)
        setState(() {
          _current = _start - duration.elapsed.inSeconds;
        });
    });

    sub.onDone(() {
      if (_current != -1) if (mounted) if (mounted)
        setState(() {
          canResend = true;
        });
      print("Done");
      sub.cancel();
    });
  }

  void _authVerify() async {
    if (_formKey.currentState!.validate()) {
      if (mounted)
        setState(() {
          isVerifying = true;
        });

      Future.delayed(Duration.zero, () async {
        String result = await AuthController.verifyPhoneNumber(
            widget.countrycode.dialCode! + widget.phoneNumber,
            _pinController.text);

        if (result != '' && result != "error") {
          setState(() {
            isVerifying = false;
          });
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return SnackabrDialog(
                status: true,
                message: LocaleKeys.operation_success.tr(),
                onPopFunction: () async {
                  if (result == "3") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarketDetailsView(
                                fromNumberInput: true,
                              )),
                    );
                  } else {
                    await SharedPreferences.getInstance().then((value1) async {
                      if (value1.containsKey('token')) {
                        await AuthController.getUser(value1.getString('token')!)
                            .then((value) async {
                          Provider.of<UserProvider>(context, listen: false)
                              .setUser(value);
                          Provider.of<UserProvider>(context, listen: false)
                              .user
                              .token = value1.getString('token');
                          await OrderController.getOrdersList(
                            Provider.of<UserProvider>(context, listen: false)
                                .user
                                .token!,
                            0,
                          ).then((value) {
                            Provider.of<RecentOrders>(context, listen: false)
                                .replaceAll(value["data"]);
                            if (value['data'].isNotEmpty)
                              Provider.of<RecentOrders>(context, listen: false)
                                  .addLast();
                          });
                          await OrderController.getOrderCount(
                            value1.getString('token')!,
                          ).then((value) {
                            Provider.of<CountProvider>(context, listen: false)
                                .editdata(
                                    value.pending,
                                    value.received,
                                    value.prepared,
                                    value.shipped,
                                    value.accepted,
                                    value.rejected);
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName,
                              (Route<dynamic> route) => false);
                        });
                      }
                    });
                  }
                },
              );
            },
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        } else {
          setState(() {
            isVerifying = false;
          });
          _pinController.clear();
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
                  if (mounted) Navigator.pop(context);
                },
              );
            },
          );
        }
      });

      if (mounted)
        setState(() {
          _isverifying = false;
        });
    }
  }

  @override
  void initState() {
    startTimer();
    _pinController = new TextEditingController();
    _phoneNumberController = new TextEditingController();
    _phoneNumberController.text = widget.phoneNumber;
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  Future<bool> _willPopScopeCall() async {
    _current = -1;
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
                    cangoback: false,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Container(
                    height: 50.48.h,
                    margin: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                    child: Text(
                      LocaleKeys.Auth_body_text.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 16.sp,
                        color: kprimaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 29.5.h,
                  ),
                  Container(
                    height: 24.0.h,
                    alignment: context.locale.toLanguageTag() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    margin: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                    child: Text(
                      LocaleKeys.Auth_phone_number.tr(),
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 18.sp,
                          color: kprimaryTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: 16.0.w,
                      right: 16.0.w,
                    ),
                    height: 54.0.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: kbordercolor),
                      //color: Colors.green,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          //width: 81.44.w,
                          child: CountryCodePicker(
                            padding: EdgeInsets.all(0.0),
                            enabled: false,
                            flagWidth: 27.92.w,
                            hideSearch: true,
                            initialSelection: widget.countrycode.name,
                            favorite: ['+966', 'SA'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            hideMainText: true,
                            textStyle: TextStyle(
                              fontSize: 14.0.sp,
                              color: ksecondaryTextColor,
                              fontFamily: 'Tajawal',
                            ),
                            showDropDownButton: false,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //margin: EdgeInsets.only(left: 0.8.w),
                            child: TextFormField(
                              enabled: false,
                              maxLength: 10,
                              showCursor: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorStyle:
                                    TextStyle(height: double.minPositive),
                                counter: null,
                                counterStyle: TextStyle(
                                    height: double.minPositive,
                                    color: Colors.transparent),
                                counterText: null,
                              ),
                              controller: _phoneNumberController,
                              cursorColor: kprimaryTextColor,
                              keyboardType: Platform.isIOS
                                  ? TextInputType.text
                                  : TextInputType.number,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.getFont(
                                'Cairo',
                                fontSize: 16.sp,
                                color: kprimaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mounted)
                              setState(() {
                                _current = -1;
                              });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NumberInput(),
                              ),
                            );
                          },
                          child: Container(
                            margin: context.locale.toLanguageTag() == 'en'
                                ? EdgeInsets.only(left: 36.w, right: 16.w)
                                : EdgeInsets.only(right: 36.w, left: 16.w),
                            decoration: BoxDecoration(
                              color: kprimaryColor,
                              shape: BoxShape.circle,
                            ),
                            width: 28.w,
                            height: 28.h,
                            child: Icon(
                              Icons.edit,
                              size: 15.sp,
                              color: kprimaryLightColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 37.6.h,
                  ),
                  Container(
                    alignment: context.locale.toLanguageTag() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    margin: EdgeInsets.only(left: 16.0.w, right: 16.w),
                    height: 24.0.h,
                    child: Text(
                      LocaleKeys.Auth_verification_code.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 18.sp,
                        color: kprimaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
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
                            controller: _pinController,
                            keyboardType: Platform.isIOS
                                ? TextInputType.text
                                : TextInputType.number,
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
                            onChanged: (value) {},
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 269.6.h,
                  ),
                  if (!isVerifying)
                    Container(
                        margin: EdgeInsets.only(left: 19.0.w, right: 19.0.w),
                        child: GestureDetector(
                          child: BottomButton(title: _buttonTitle),
                          onTap: () {
                            if (_pinController.text == "") return;
                            _authVerify();
                          },
                        )),
                  // if (isVerifying)
                  //   Container(
                  //       height: 56.0.h,
                  //       margin: EdgeInsets.only(left: 19.0.w, right: 19.0.w),
                  //       child: Center(
                  //         child: CircularProgressIndicator(),
                  //       )),
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
                                      if (mounted)
                                        setState(() {
                                          canResend = false;
                                          resendCount++;
                                          _current = 30;
                                          startTimer();
                                        });
                                      Future.delayed(
                                          const Duration(milliseconds: 1400),
                                          () async {
                                        await AuthController
                                            .sendSmsVerification(
                                          widget.countrycode.dialCode! +
                                              widget.phoneNumber,
                                        ).then((value0) {
                                          // if(mounted)setState(() {
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
                                                status: false,
                                                message: value0
                                                        .containsKey('success')
                                                    ? LocaleKeys.Auth_resending
                                                            .tr() +
                                                        "${widget.phoneNumber}"
                                                    : LocaleKeys.operation_field
                                                        .tr(),
                                                onPopFunction: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          ).then((value) {
                                            // showModalBottomSheet<void>(
                                            //   context: context,
                                            //   isScrollControlled: true,
                                            //   enableDrag: true,
                                            //   backgroundColor:
                                            //       Colors.transparent,
                                            //   builder: (BuildContext context) {
                                            //     return SnackabrDialog(
                                            //       status: value0.containsKey(
                                            //               'success')
                                            //           ? true
                                            //           : false,
                                            //       message: value0.containsKey(
                                            //               'success')
                                            //           ? value0["data"][0]
                                            //               .toString()
                                            //           : LocaleKeys
                                            //               .operation_field
                                            //               .tr(),
                                            //       onPopFunction: () {
                                            //         Navigator.pop(context);
                                            //       },
                                            //     );
                                            //   },
                                            // );
                                          });
                                        });
                                      });
                                      if (mounted)
                                        setState(() {
                                          _pinController.clear();
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
                              LocaleKeys.try_later.tr(),
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
            if (isVerifying)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
