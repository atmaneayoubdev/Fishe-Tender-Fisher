import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UnitWidget2 extends StatefulWidget {
  const UnitWidget2({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.price,
    this.discount,
  }) : super(key: key);
  final String name;
  final String price;
  final bool isSelected;
  final String? discount;

  @override
  _UnitWidget2State createState() => _UnitWidget2State();
}

class _UnitWidget2State extends State<UnitWidget2> {
  double newPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
      height: 50.h,
      //width: widget.isSelected ? 100.w : 50.w,
      decoration: BoxDecoration(
        color: widget.isSelected ? kprimaryColor : kprimaryLightColor,
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: kshadowcolor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: GoogleFonts.tajawal(
                fontSize: 18.sp,
                color: kprimaryLightColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 5.w,
          ),
          if (widget.discount != "")
            Container(
              child: Text(
                ((double.parse(widget.price)) -
                        (((double.parse(widget.price)) *
                                (double.parse(widget.discount!))) /
                            100))
                    .toStringAsFixed(2),
                style: GoogleFonts.tajawal(
                  fontSize: 15.sp,
                  color: Colors.amber,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Container(
            child: Text(
              widget.discount != ""
                  ? widget.price == "0"
                      ? "(${LocaleKeys.free.tr()})"
                      : "(${widget.price})"
                  : widget.price == "0"
                      ? LocaleKeys.free.tr()
                      : widget.price,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: widget.discount == "" ? 15.sp : 10.sp,
                color: Colors.amber,
                decoration: widget.discount != ""
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                height: 1.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
