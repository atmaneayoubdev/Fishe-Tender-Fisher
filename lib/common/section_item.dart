import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'package:easy_localization/easy_localization.dart' as loc;

class SectionItem extends StatefulWidget {
  final String imagePath;
  final bool isSelected;
  final String isActive;
  final String name;
  final int id;

  const SectionItem({
    Key? key,
    required this.id,
    required this.imagePath,
    required this.name,
    required this.isSelected,
    required this.isActive,
  }) : super(key: key);
  @override
  _SectionItemState createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.id == 1
                  ? kprimaryColor
                  : widget.id == 3 || widget.id == 4 || widget.id == 5
                      ? Colors.amber
                      : Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(5.r),
            ),
            padding: widget.id == 3 ? EdgeInsets.all(5) : EdgeInsets.all(0),
            child: Align(
              //width: MediaQuery.of(context).size.width,
              // height: 100,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(5.r),
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage(
              //       widget.imagePath,
              //     ),
              //   ),
              // ),
              alignment: widget.id == 3
                  ? Alignment.bottomRight
                  : widget.id == 2
                      ? Alignment.bottomCenter
                      : Alignment.topRight,
              child: widget.id != 2
                  ? SvgPicture.asset(
                      widget.imagePath,
                      fit: BoxFit.fill,
                      height: widget.id == 1
                          ? 90.h
                          : widget.id == 3
                              ? 45.h
                              : 60.h,
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Align(
            alignment: widget.id == 2 || widget.id == 3
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(7),
              child: Row(
                mainAxisAlignment: widget.id == 2 || widget.id == 3
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Text(
                    widget.name,
                    //textAlign: TextAlign.end,
                    style: GoogleFonts.tajawal(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.id == 1 ? Colors.amber : kprimaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isSelected)
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Icon(
                Icons.check_circle,
                color: kprimaryGreenColor,
                size: 20.sp,
              ),
            ),
          if (widget.isActive == "2")
            Container(
              // height: 95.h,
              // width: 140.w,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Colors.black54,
              ),
              child: Center(
                child: Text(
                  LocaleKeys.coming_soon.tr() + "...",
                  style: GoogleFonts.tajawal(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    color: kprimaryLightColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
