import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({Key? key}) : super(key: key);
  static final String routeName = '/settings_screen';

  @override
  _SettingscreenState createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  final GlobalKey categoryKey = new GlobalKey();
  String notdropdownValue = LocaleKeys.Settings_notifications_off.tr();
  //bool _isnotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              title: LocaleKeys.Settings_title.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 20.h, bottom: 8.h, left: 18.w, right: 18.w),
              child: Text(
                LocaleKeys.Settings_language.tr(),
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 18.sp,
                    color: kprimaryTextColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 54.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              width: 355.w,
              margin: EdgeInsets.only(bottom: 15.h, left: 18.w, right: 18.w),
              decoration: BoxDecoration(
                  border:
                      Border.all(style: BorderStyle.solid, color: kshadowcolor),
                  borderRadius: BorderRadius.circular(5.r)),
              child: DropdownButton<String>(
                value: context.locale.toLanguageTag() == 'en'
                    ? 'English'
                    : 'العربية',
                underline: Container(
                  height: 0,
                ),
                isExpanded: true,
                iconSize: 15.sp,
                icon: Icon(
                  FontAwesomeIcons.chevronDown,
                ),
                items: <String>['English', 'العربية'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue == 'English') {
                      setState(() {
                        context.setLocale(Locale('en'));
                        notdropdownValue = 'OFF';
                      });
                    } else {
                      setState(() {
                        context.setLocale(Locale('ar'));
                        notdropdownValue = 'إلغاء';
                      });
                    }
                  });
                },
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(
            //       top: 20.h, bottom: 8.h, left: 18.w, right: 18.w),
            //   child: Text(
            //     LocaleKeys.Settings_notifications.tr(),
            //     style: GoogleFonts.getFont('Tajawal',
            //         fontSize: 18.sp,
            //         color: kprimaryTextColor,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            // Container(
            //   height: 54.h,
            //   padding: EdgeInsets.symmetric(horizontal: 18.w),
            //   width: 355.w,
            //   margin: EdgeInsets.only(bottom: 8.h, left: 18.w, right: 18.w),
            //   decoration: BoxDecoration(
            //       border:
            //           Border.all(style: BorderStyle.solid, color: kshadowcolor),
            //       borderRadius: BorderRadius.circular(5.r)),
            //   child: DropdownButton<String>(
            //     key: categoryKey,
            //     value: _isnotifications
            //         ? LocaleKeys.Settings_notifications_on.tr()
            //         : LocaleKeys.Settings_notifications_off.tr(),
            //     underline: Container(
            //       height: 0,
            //     ),
            //     isExpanded: true,
            //     iconSize: 15.sp,
            //     icon: Icon(
            //       FontAwesomeIcons.chevronDown,
            //     ),
            //     items: <String>[
            //       LocaleKeys.Settings_notifications_on.tr(),
            //       LocaleKeys.Settings_notifications_off.tr()
            //     ].map((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: new Text(value),
            //       );
            //     }).toList(),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         notdropdownValue = newValue!;
            //         _isnotifications = !_isnotifications;
            //       });
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
