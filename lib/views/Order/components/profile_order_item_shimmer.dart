import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class ProfileOrderItemShimmer extends StatelessWidget {
  const ProfileOrderItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 119.h,
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: kbaseColor,
            highlightColor: kHighLightColor,
            child: Container(
              color: Colors.white,
              width: 100.w,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 20.h,
                        width: 100.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 20.h,
                        width: 80.w,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 20.h,
                        width: 80.w,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 20.h,
                        width: 80.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
