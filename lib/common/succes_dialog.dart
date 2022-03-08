import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccesDialog extends StatelessWidget {
  const SuccesDialog({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 403.h,
        width: 345.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 38.7.h,
            ),
            Container(
              height: 192.3.h,
              width: 254.14.w,
              child: Image.asset(
                "assets/images/success.png",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 18.w),
              child: Text(
                title,
                style: GoogleFonts.getFont(
                  'Tajawal',
                  fontSize: 16.sp,
                  color: kprimaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName, (Route<dynamic> route) => false);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
                    child: BottomButton(
                      title: LocaleKeys.go_home.tr(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
