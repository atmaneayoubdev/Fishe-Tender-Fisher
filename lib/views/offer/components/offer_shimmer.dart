import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

class OfferShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 200.h,
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        decoration: BoxDecoration(
          color: kprimaryLightColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: kshadowcolor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0.0, 3.0)),
          ],
        ),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: kbaseColor,
              highlightColor: kHighLightColor,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                height: 130.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 15.h,
                          width: 100.w,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 15.h,
                          width: 30.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 15.h,
                          width: 50.w,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: kbaseColor,
                        highlightColor: kHighLightColor,
                        child: Container(
                          color: Colors.white,
                          height: 15.h,
                          width: 80.w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
