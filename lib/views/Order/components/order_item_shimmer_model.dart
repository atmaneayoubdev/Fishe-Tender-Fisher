import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class OrderItemShimmerModel extends StatelessWidget {
  const OrderItemShimmerModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          height: 100.h,
          width: 375.w,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Shimmer.fromColors(
                baseColor: kbaseColor,
                highlightColor: kHighLightColor,
                child: Container(
                  width: 94.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: kprimaryLightColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
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
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 20.h,
                        width: 100.w,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Shimmer.fromColors(
                      baseColor: kbaseColor,
                      highlightColor: kHighLightColor,
                      child: Container(
                        color: Colors.white,
                        height: 15.h,
                        width: 100.w,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: 250.w,
                      child: Row(
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
                              width: 100.w,
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
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
        ),
        SizedBox(
          height: 18.h,
        ),
      ],
    );
  }
}
