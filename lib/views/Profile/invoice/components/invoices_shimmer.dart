import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../constants.dart';

class InvoiceShimmer extends StatelessWidget {
  const InvoiceShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 18.w, right: 18.w),
      padding: context.locale.toLanguageTag() == 'en'
          ? EdgeInsets.only(top: 17.h, left: 18.w, bottom: 2, right: 86.w)
          : EdgeInsets.only(top: 17.h, left: 86.w, bottom: 2, right: 18.w),
      height: 118.h,
      width: 355.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: kprimaryLightColor,
        boxShadow: [
          BoxShadow(
              color: kshadowcolor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0.0, 3.0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: kbaseColor,
            highlightColor: kHighLightColor,
            child: Container(
              color: Colors.white,
              height: 30.h,
              width: 100.w,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
