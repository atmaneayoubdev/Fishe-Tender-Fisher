import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: kbaseColor,
        highlightColor: kHighLightColor,
        child: Container(
          height: 50.h,
          width: 131.w,
          decoration: BoxDecoration(
            color: kprimaryLightColor,
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
      ),
    );
  }
}
