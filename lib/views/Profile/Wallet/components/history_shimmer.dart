import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';

class HistoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      padding: EdgeInsets.all(5),
      height: 106.h,
      width: 375.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: kprimaryLightColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
                color: kshadowcolor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0.0, 3.0)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 94.w,
            height: double.infinity,
            child: Shimmer.fromColors(
              baseColor: kbordercolor,
              highlightColor: Colors.grey.shade400,
              child: CircleAvatar(),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: kbordercolor,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    color: Colors.white,
                    height: 20.h,
                    width: 80.w,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Shimmer.fromColors(
                  baseColor: kbordercolor,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    color: Colors.white,
                    height: 12.h,
                    width: 80.w,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Shimmer.fromColors(
                  baseColor: kbordercolor,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    color: Colors.white,
                    height: 12.h,
                    width: 60.w,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: 250.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Shimmer.fromColors(
                        baseColor: kbordercolor,
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          color: Colors.white,
                          height: 12.h,
                          width: 60.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
