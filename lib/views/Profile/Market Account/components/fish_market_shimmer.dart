import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants.dart';

class FishMarketShimmer extends StatelessWidget {
  const FishMarketShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.38.h,
      width: 358.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: kbaseColor,
            highlightColor: kHighLightColor,
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
              width: 109.69.w,
              height: 96.45.h,
            ),
          ),
          SizedBox(
            width: 8.5.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
                height: 5.h,
              ),
              Shimmer.fromColors(
                baseColor: kbaseColor,
                highlightColor: kHighLightColor,
                child: Container(
                  color: Colors.white,
                  height: 15.h,
                  width: 150.w,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                width: 239.23.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: kbaseColor,
                          highlightColor: kHighLightColor,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            height: 23.h,
                            width: 23.w,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Shimmer.fromColors(
                          baseColor: kbaseColor,
                          highlightColor: kHighLightColor,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            height: 23.h,
                            width: 23.w,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Shimmer.fromColors(
                          baseColor: kbaseColor,
                          highlightColor: kHighLightColor,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            height: 23.h,
                            width: 23.w,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Shimmer.fromColors(
                          baseColor: kbaseColor,
                          highlightColor: kHighLightColor,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            height: 23.h,
                            width: 23.w,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
