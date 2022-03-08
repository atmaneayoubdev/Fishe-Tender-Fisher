import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';

class TicketShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118.h,
      width: 355.w,
      padding: EdgeInsets.only(
        top: 19.h,
        right: 16.w,
        left: 16.w,
      ),
      margin: EdgeInsets.only(right: 17.w, left: 17.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
              style: BorderStyle.solid, width: 1, color: kbordercolor),
          color: kprimaryLightColor,
          boxShadow: [
            BoxShadow(
                color: kshadowcolor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0.0, 3.0)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: kbaseColor,
            highlightColor: kHighLightColor,
            child: Container(
              color: Colors.white,
              height: 30.h,
              width: 265.w,
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 12.h,
                        width: 50.w,
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 12.h,
                        width: 50.w,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 12.h,
                        width: 50.w,
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 12.h,
                        width: 50.w,
                      ),
                    ),
                  ],
                ),
                Shimmer.fromColors(
                  baseColor: kbaseColor,
                  highlightColor: kHighLightColor,
                  child: Container(
                    color: Colors.white,
                    height: 25.h,
                    width: 81.w,
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
