import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FisheTypeModel extends StatefulWidget {
  const FisheTypeModel(
      {Key? key,
      required this.image,
      required this.title,
      required this.isSelected,
      required this.isShowAll})
      : super(key: key);
  final String image;
  final String title;
  final bool isSelected;
  final bool isShowAll;

  @override
  _FisheTypeModelState createState() => _FisheTypeModelState();
}

class _FisheTypeModelState extends State<FisheTypeModel> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 51.h,
        width: 131.w,
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
        decoration: BoxDecoration(
            color: widget.isSelected ? ksecondaryColor : kprimaryLightColor,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                  color: kshadowcolor,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(-1.0, 1.0)),
            ]),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 2.w,
              ),
              widget.isShowAll
                  ? ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: SvgPicture.asset(
                          widget.image,
                          height: 50.h,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
              SizedBox(
                width: 7.w,
              ),
              Flexible(
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.getFont(
                    'Tajawal',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected
                        ? kprimaryLightColor
                        : kprimaryTextColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
