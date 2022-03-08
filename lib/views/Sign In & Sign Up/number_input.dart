import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/code_verification.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class NumberInput extends StatefulWidget {
  static final String routeName = '/number_input';

  @override
  _NumberInputState createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  var _numberController0;
  final _formKey = GlobalKey<FormState>();
  String _buttonTitle = LocaleKeys.Auth_continue_button.tr();
  String _appbarTitle = LocaleKeys.Auth_appbar_title1.tr();
  CountryCode _countryCode = CountryCode(name: 'SA');
  bool isLoading = false;

  @override
  void initState() {
    _numberController0 = new TextEditingController();
    _countryCode = CountryCode(name: 'SA', dialCode: "+966");
    super.initState();
  }

  Future<void> _authVerify() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      if (mounted)
        setState(() {
          isLoading = true;
        });
      print('validation success');
      print(_countryCode.dialCode);
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SnackabrDialog(
            status: true,
            message: LocaleKeys.Auth_sending.tr(),
            onPopFunction: () {
              Navigator.of(context).pop();
            },
          );
        },
      ).then((value) async {
        String phone = _numberController0.text;
        String finalPhone = phone.startsWith("0") ? phone.substring(1) : phone;

        await AuthController.sendSmsVerification(
          _countryCode.dialCode! + finalPhone,
        ).then((value0) {
          if (mounted)
            setState(() {
              isLoading = false;
            });
          print(value0);
          if (value0.containsKey('success')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CodeVerification(
                  countrycode: _countryCode,
                  phoneNumber: finalPhone,
                ),
              ),
            );
            // showModalBottomSheet<void>(
            //   context: context,
            //   isScrollControlled: true,
            //   enableDrag: true,
            //   backgroundColor: Colors.transparent,
            //   builder: (BuildContext context) {
            //     return SnackabrDialog(
            //       status: value0.containsKey('success') ? true : false,
            //       message: value0.containsKey('success')
            //           ? value0["data"][0].toString()
            //           : LocaleKeys.operation_field.tr(),
            //       onPopFunction: () {
            //         Navigator.pop(context);
            //       },
            //     );
            //   },
            // ).then((value) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => CodeVerification(
            //         countrycode: _countryCode,
            //         phoneNumber: finalPhone,
            //       ),
            //     ),
            //   );
            // });
          } else {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: false,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return SnackabrDialog(
                  status: true,
                  message: LocaleKeys.operation_field.tr(),
                  onPopFunction: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Form(
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
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: CountryCodePicker(
                            padding: EdgeInsets.all(0.0),
                            flagWidth: 27.92.w,
                            onChanged: (CountryCode code) {
                              if (mounted)
                                setState(() {
                                  _countryCode = code;
                                });
                            },
                            dialogSize: Size(300.w, 500.h),
                            hideSearch: true,
                            initialSelection: _countryCode.name,
                            favorite: ['+966', 'SA'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            hideMainText: false,
                            textStyle: TextStyle(
                              fontSize: 14.0.sp,
                              color: ksecondaryTextColor,
                              fontFamily: 'Tajawal',
                            ),
                            showDropDownButton: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 18.8.w),
                      child: TextFormField(
                        maxLength: 9,
                        showCursor: false,
                        controller: _numberController0,
                        cursorColor: kprimaryTextColor,
                        keyboardType: Platform.isIOS
                            ? TextInputType.text
                            : TextInputType.number,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.Auth_phone_number.tr(),
                          hintStyle: TextStyle(height: double.minPositive),
                          border: InputBorder.none,
                          errorStyle: TextStyle(height: double.minPositive),
                          counter: null,
                          counterStyle: TextStyle(
                              height: double.minPositive,
                              color: Colors.transparent),
                          counterText: null,
                        ),
                        style: GoogleFonts.getFont(
                          'Cairo',
                          fontSize: 16.sp,
                          color: kprimaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 9) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return SnackabrDialog(
                                  status: false,
                                  message: LocaleKeys.wrong_phone.tr(),
                                  onPopFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 435.0.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 19.0.w, right: 19.0.w),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      child: BottomButton(title: _buttonTitle),
                      onTap: _authVerify,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
