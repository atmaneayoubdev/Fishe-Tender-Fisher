import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/models/discount/discount_list_item_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_model2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscountItem extends StatefulWidget {
  const DiscountItem({
    required this.deleteDiscount,
    required this.discountetails,
    required this.discountFunc,
  });
  final Discountlist discountetails;
  final deleteDiscount;
  final discountFunc;

  @override
  _DiscountItemState createState() => _DiscountItemState();
}

class _DiscountItemState extends State<DiscountItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.38.h,
      width: 358.w,
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.discountetails.images.first.imageUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: 8.5.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //width: 239.23.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.discountetails.product.name,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kredcolor,
                          borderRadius: context.locale.toLanguageTag() == "ar"
                              ? BorderRadius.only(
                                  topRight: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  bottomLeft: Radius.circular(20.r),
                                ),
                        ),
                        width: 40.w,
                        height: 20.h,
                        child: Center(
                          child: Text(
                            widget.discountetails.discount.value + " %",
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryLightColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  // width: 239.23.w,
                  child: Text(
                    widget.discountetails.product.description,
                    style: GoogleFonts.getFont(
                      'Tajawal',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: ksecondaryTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  //width: 239.23.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 15.h,
                            width: 15.w,
                            child: SvgPicture.asset(
                              'assets/icons/price.svg',
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            (double.parse(widget.discountetails.lowestPrice) -
                                    ((double.parse(widget
                                                .discountetails.lowestPrice) *
                                            double.parse(widget.discountetails
                                                .discount.value)) /
                                        100))
                                .toStringAsFixed(2),
                            //'${widget.discountetails.lowestPrice}',
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryTextColor,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '(${widget.discountetails.lowestPrice})',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryTextColor,
                              height: 1,
                              decoration: TextDecoration.lineThrough,
                            ),
                            // style: GoogleFonts.getFont(
                            //   'Tajawal',
                            //   fontSize: 12.sp,
                            //   fontWeight: FontWeight.w600,
                            //   color: kprimaryTextColor,
                            //   height: 1,
                            //   decoration: TextDecoration.lineThrough,
                            // ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.discountFunc();
                            },
                            child: Container(
                              height: 23.h,
                              width: 23.w,
                              decoration: BoxDecoration(
                                color: kprimaryLightColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: kshadowcolor,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(0.0, 3.0)),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                color: kprimaryTextColor,
                                size: 15.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: widget.deleteDiscount,
                            child: Container(
                              height: 23.h,
                              width: 23.w,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 243, 242, 1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: kshadowcolor,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(0.0, 3.0)),
                                ],
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Color.fromRGBO(252, 146, 135, 1),
                                size: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
