import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class SectionShimmer extends StatefulWidget {
  @override
  _SectionShimmerState createState() => _SectionShimmerState();
}

class _SectionShimmerState extends State<SectionShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kbaseColor,
      highlightColor: kHighLightColor,
      child: Container(
        height: 95.h,
        width: 140.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
      ),
    );
  }
}
