import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FisheItemModel extends StatefulWidget {
  const FisheItemModel({
    required this.deleteFunction,
    required this.imageUrl,
    required this.price,
    required this.name,
    required this.description,
    required this.id,
    required this.visible,
    required this.discount,
    required this.discountFunction,
    required this.updateFunction,
  });
  final String imageUrl;
  final String price;
  final String name;
  final String description;
  final int id;
  final String visible;
  final double discount;
  final discountFunction;
  final updateFunction;
  final deleteFunction;

  @override
  _FisheItemModelState createState() => _FisheItemModelState();
}

class _FisheItemModelState extends State<FisheItemModel> {
  String _currentstate = "1";
  @override
  void initState() {
    super.initState();
    if (mounted)
      setState(() {
        _currentstate = widget.visible;
        print(_currentstate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.38.h,
      width: 358.w,
      decoration: BoxDecoration(
        color: kprimaryLightColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //width: 109.69.w,
            //height: 96.45.h,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Hero(
              tag: "img" + widget.id.toString(),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          // Image.network(widget.imageUrl)),
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
                        widget.name,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: kprimaryTextColor,
                        ),
                      ),
                      if (widget.discount != 0)
                        Container(
                          //padding: EdgeInsets.all(3),
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
                          //width: 50.w,
                          height: 20.h,
                          child: Container(
                            margin: EdgeInsets.all(3),
                            child: Center(
                              child: Text(
                                widget.discount.toString() + " %",
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryLightColor,
                                  //height: 1.5,
                                ),
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
                  //width: 239.23.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 190.w,
                        child: Text(
                          widget.description,
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: ksecondaryTextColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _currentstate == "1"
                            ? LocaleKeys.visible.tr() + " "
                            : LocaleKeys.hiden.tr() + " ",
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: _currentstate == "1"
                              ? kprimaryGreenColor
                              : ksecondaryTextColor,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
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
                          SizedBox(width: 5.w),
                          if (widget.discount == 0)
                            Text(
                              widget.price,
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryTextColor,
                              ),
                            ),
                          if (widget.discount != 0)
                            Text(
                              (double.parse(widget.price) -
                                      ((double.parse(widget.price) *
                                              widget.discount) /
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
                          if (widget.discount != 0)
                            SizedBox(
                              width: 3.w,
                            ),
                          if (widget.discount != 0)
                            Text(
                              '(${widget.price})',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryTextColor,
                                height: 1,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.discountFunction();
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
                              child: Container(
                                padding: EdgeInsets.all(2),
                                height: 23.h,
                                width: 23.w,
                                child: SvgPicture.asset(
                                  'assets/icons/ic_discount.svg',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ProductsControlller.updateActiveStatus(
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user.token!,
                                widget.id,
                                _currentstate == "1" ? "0" : "1",
                              ).then((value) {
                                if (mounted)
                                  setState(() {
                                    _currentstate = value;
                                  });
                              });
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
                              child: _currentstate == "1"
                                  ? Icon(
                                      Icons.visibility,
                                      color: kprimaryTextColor,
                                      size: 15.sp,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: kprimaryTextColor,
                                      size: 15.sp,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.updateFunction();
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
                            onTap: widget.deleteFunction,
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
