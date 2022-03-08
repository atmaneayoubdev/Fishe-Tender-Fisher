import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constants.dart';

class TransactionShimmer extends StatelessWidget {
  const TransactionShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 9.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Shimmer.fromColors(
              baseColor: kbordercolor,
              highlightColor: Colors.grey.shade400,
              child: Container(
                height: 20.h,
                width: 62.w,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Shimmer.fromColors(
              baseColor: kbordercolor,
              highlightColor: Colors.grey.shade400,
              child: Container(
                height: 20.h,
                width: 62.w,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Shimmer.fromColors(
              baseColor: kbordercolor,
              highlightColor: Colors.grey.shade400,
              child: Container(
                height: 20.h,
                width: 62.w,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Shimmer.fromColors(
              baseColor: kbordercolor,
              highlightColor: Colors.grey.shade400,
              child: Container(
                height: 20.h,
                width: 62.w,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
