import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class PopUpSheet extends StatefulWidget {
  const PopUpSheet(
      {Key? key,
      required this.title1,
      required this.text1,
      required this.title2,
      required this.title3,
      required this.hint,
      required this.function})
      : super(key: key);
  final String title1;
  final String text1;
  final String title2;
  final String title3;
  final String hint;
  final Function function;

  @override
  _PopUpSheetState createState() => _PopUpSheetState();
}

class _PopUpSheetState extends State<PopUpSheet> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 0.h),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 448.h,
        width: 355.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: context.locale.toLanguageTag() == 'en'
                        ? EdgeInsets.only(top: 18.h, left: 16.w)
                        : EdgeInsets.only(top: 18.h, right: 16.w),
                    child: Text(
                      widget.title1,
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 19.sp, fontWeight: FontWeight.bold),
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
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 18.w, right: 18.w, top: 11.h),
              child: Text(
                widget.text1,
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 18.w, top: 7.h, right: 18.w),
              child: Text(
                widget.title2,
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 54.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              margin: EdgeInsets.only(left: 18.w, right: 18.w, top: 7.h),
              decoration: BoxDecoration(
                  border:
                      Border.all(style: BorderStyle.solid, color: kshadowcolor),
                  borderRadius: BorderRadius.circular(5.r)),
              child: TextField(
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 16.sp, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  counter: null,
                  counterStyle: TextStyle(
                      height: double.minPositive, color: Colors.transparent),
                  counterText: null,
                ),
                keyboardType: TextInputType.phone,
                maxLines: null,
                maxLength: 10,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 18.w, left: 18.w, top: 7.h),
              child: Text(
                widget.title3,
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 131.h,
              width: 319.w,
              margin: EdgeInsets.only(
                top: 10.h,
                right: 18.w,
                left: 18.w,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                  border:
                      Border.all(style: BorderStyle.solid, color: kshadowcolor),
                  borderRadius: BorderRadius.circular(5.r)),
              child: TextField(
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 18.sp, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
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
                onTap: () {
                  widget.function();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
