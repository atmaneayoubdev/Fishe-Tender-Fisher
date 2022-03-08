import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants.dart';

class FaqFilterItem extends StatefulWidget {
  const FaqFilterItem({Key? key, required this.name, required this.isSelected})
      : super(key: key);
  final String name;
  final bool isSelected;

  @override
  _FaqFilterItemState createState() => _FaqFilterItemState();
}

class _FaqFilterItemState extends State<FaqFilterItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      margin: EdgeInsets.only(left: 12.w, bottom: 14.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 54.h,
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              width: 134.w,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                color: widget.isSelected ? kprimaryColor : kprimaryLightColor,
                border:
                    Border.all(style: BorderStyle.solid, color: kshadowcolor),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  widget.name,
                  style: GoogleFonts.getFont(
                    'Tajawal',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: widget.isSelected
                        ? kprimaryLightColor
                        : kprimaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
