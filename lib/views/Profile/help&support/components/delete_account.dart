import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:fishe_tender_fisher/controllers/help_support_controller.dart';
import 'package:fishe_tender_fisher/models/FAQ/subject_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  TextEditingController _controller = TextEditingController();
  String languagedropdownValue = LocaleKeys.help_and_support_suggestions.tr();
  bool _isLoading = false;
  var borderColor0 = kbordercolor;
  var borderColor1 = kbordercolor;

  Future<void> senFunc() async {
    if (_controller.text == "") {
      if (mounted)
        setState(() {
          borderColor1 = kredcolor;
        });
      return;
    } else
      borderColor1 = kbordercolor;

    if (_controller.text != "") {
      if (mounted)
        setState(() {
          _isLoading = true;
          borderColor0 = kbordercolor;
          borderColor1 = kbordercolor;
        });
      await AuthController.deleteAcoount(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        _controller.text,
      ).then((responseData) {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
        showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SnackabrDialog(
              status: responseData.containsKey('success') ? true : false,
              message: responseData.containsKey('success')
                  ? LocaleKeys.operation_success.tr()
                  : responseData["error"]["message"] ==
                          "You already have a delete request pending!"
                      ? LocaleKeys.pending_delete.tr()
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(vertical: 0.h),
      content: Container(
          height: 350.h,
          width: 355.w,
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 18.h,
                              left: 16.w,
                              right: 16.w,
                            ),
                            child: Text(
                              LocaleKeys.help_and_support_delete_account.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kprimaryColor,
                            ),
                            height: 32.h,
                            width: 32.w,
                            alignment: Alignment.center,
                            margin: context.locale.toLanguageTag() == 'en'
                                ? EdgeInsets.only(top: 18.h, right: 16.w)
                                : EdgeInsets.only(top: 18.h, left: 16.w),
                            // Button color
                            child: InkWell(
                              splashColor: ksecondaryColor, // Splash color
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                  child: Icon(
                                Icons.close,
                                size: 20.sp,
                                color: kprimaryLightColor,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: context.locale.toLanguageTag() == 'en'
                          ? EdgeInsets.only(top: 7.h, left: 16.w)
                          : EdgeInsets.only(top: 7.h, right: 16.w),
                      child: Text(
                        LocaleKeys.help_and_support_complaint_title3.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 150.h,
                      width: 319.w,
                      margin: EdgeInsets.only(
                        right: 18.w,
                        left: 18.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid, color: borderColor1),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextField(
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText:
                              LocaleKeys.help_and_support_delete_hint.tr(),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (String v) {
                          senFunc();
                        },
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                      margin: EdgeInsets.only(
                        left: 13.0.w,
                        right: 14.0.w,
                        bottom: 18.h,
                        top: 16.h,
                      ),
                      child: GestureDetector(
                        child: BottomButton(
                          title: LocaleKeys.submit.tr(),
                        ),
                        onTap: () async {
                          senFunc();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          )),
    );
  }
}
