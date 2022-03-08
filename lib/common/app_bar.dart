import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    required this.title,
    required this.cangoback,
    this.rightbutton,
    this.appbarheight,
    this.function,
  });
  final String title;
  final bool cangoback;
  final Widget? rightbutton;
  final double? appbarheight;
  final function;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: appbarheight == null ? 124.0.h : appbarheight,
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0.r),
          bottomRight: Radius.circular(15.0.r),
        ),
        boxShadow: [
          BoxShadow(
            color: kshadowcolor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            child: context.locale.toLanguageTag() == 'en'
                ? Image.asset(
                    'assets/images/appbar_background.png',
                  )
                : Image.asset(
                    'assets/images/appbar_background_ar.png',
                  ),
            alignment: context.locale.toLanguageTag() == 'en'
                ? Alignment.centerRight
                : Alignment.centerLeft,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (cangoback)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kprimaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: kshadowcolor,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0.0, 3.0)),
                        ],
                      ),
                      height: 36.h,
                      width: 36.w,
                      margin: EdgeInsets.only(
                          bottom: 20.0.h,
                          left: 16.0.w,
                          top: 72.0.h,
                          right: 10.w),
                      // Button color
                      child: InkWell(
                        splashColor: ksecondaryColor, // Splash color
                        onTap: () {
                          function();
                        },
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.chevron_left,
                              size: 30.sp,
                              color: kprimaryLightColor,
                            )),
                      ),
                    ),
                  Container(
                    margin: cangoback
                        ? EdgeInsets.only(
                            bottom: 15.16.h,
                            top: 51.4.h,
                          )
                        : EdgeInsets.only(
                            bottom: 15.16.h,
                            left: 21.w,
                            right: 21.w,
                            top: 51.4.h,
                          ),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: GoogleFonts.getFont('Tajawal',
                          fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (rightbutton != null) rightbutton!,
            ],
          )
        ],
      ),
    );
  }
}
