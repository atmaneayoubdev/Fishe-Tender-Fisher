import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants.dart';

class FilterShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kbaseColor,
      highlightColor: kHighLightColor,
      child: Container(
        height: 54.h,
        width: 134.w,
        decoration: BoxDecoration(
          color: kprimaryLightColor,
          border: Border.all(style: BorderStyle.solid, color: kshadowcolor),
          borderRadius: BorderRadius.circular(5.r),
        ),
        margin: EdgeInsets.only(left: 12.w, bottom: 14.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
