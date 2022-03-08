import 'dart:io';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/section_shimmer.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/controllers/offers_controller.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/models/products/section_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/common/section_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

class OfferBottomSheet extends StatefulWidget {
  const OfferBottomSheet({Key? key, required this.addOffer}) : super(key: key);
  final bool addOffer;

  @override
  _OfferBottomSheetState createState() => _OfferBottomSheetState();
}

class _OfferBottomSheetState extends State<OfferBottomSheet> {
  var borderColor = kbordercolor;
  var borderColor0 = kbordercolor;
  bool isLoading = false;
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDatesTo = DateTime.now();
  ImagePicker _picker = new ImagePicker();
  Section? _slectedSecion;
  var imageFile;
  String? imagepath = "";
  String promotionPrice = "";
  String slidingPrice = "";
  List<Section> _sections = [];

  Future getImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imagepath = pickedFile.path;
        borderColor0 = kbordercolor;
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    Future.delayed(Duration.zero, () async {
      await ProductsControlller.getSectionList(
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).user.token!,
      ).then((section) async {
        await OffersController.getSlidingPrice(
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).user.token!,
        ).then((sliding) async {
          await OffersController.getPromotionPrice(
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).user.token!,
          ).then((fixed) {
            if (mounted) {
              if (fixed != null)
                setState(() {
                  _sections = section;
                  slidingPrice = sliding;
                  promotionPrice = fixed;
                });
            }
          });
        });
      });
    });
    super.initState();
  }

  bool _isFixed = false;
  var height = 540.h;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        color: kprimaryLightColor,
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TitleWidget(
                    title: LocaleKeys.offer_discount_advertising.tr(),
                    color: kprimaryColor,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  margin: context.locale.toLanguageTag() == 'en'
                      ? EdgeInsets.only(left: 10.w)
                      : EdgeInsets.only(right: 0.w),
                  height: 90.h,
                  width: double.infinity,
                  child: _sections.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0),
                          shrinkWrap: true,
                          itemCount: _sections.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            Section _section = _sections[index];
                            return GestureDetector(
                              onTap: () {
                                if (_section.isActive == '1') {
                                  setState(() {
                                    _slectedSecion = _section;
                                  });
                                }
                              },
                              child: SectionItem(
                                id: _section.id,
                                name: _section.id == 1
                                    ? LocaleKeys.fishe_market.tr()
                                    : _section.id == 2
                                        ? LocaleKeys.freezers.tr()
                                        : _section.id == 3
                                            ? LocaleKeys.fishe_resto.tr()
                                            : _section.id == 4
                                                ? LocaleKeys.sushi.tr()
                                                : LocaleKeys.caviar.tr(),
                                imagePath: _section.id == 1
                                    ? 'assets/images/fishe_market.svg'
                                    : _section.id == 2
                                        ? 'assets/images/freezers.png'
                                        : _section.id == 3
                                            ? 'assets/images/fishe_restorants.svg'
                                            : _section.id == 4
                                                ? 'assets/images/sushi.svg'
                                                : 'assets/images/caviar.svg',
                                isSelected:
                                    _slectedSecion == _section ? true : false,
                                isActive: _section.isActive,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10.w);
                          },
                        )
                      : ListView.separated(
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return SectionShimmer();
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10.w);
                          },
                        ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 19.w),
                  child: Text(
                    LocaleKeys.ad_type.tr(),
                    style: GoogleFonts.getFont(
                      'Tajawal',
                      fontSize: 16.sp,
                      color: ksecondaryTextColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFixed = false;
                            height = 540.h;
                          });
                        },
                        child: Container(
                          height: 55.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                            color:
                                _isFixed ? kprimaryLightColor : kprimaryColor,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                color: kprimaryColor, width: _isFixed ? 1 : 0),
                            boxShadow: [
                              BoxShadow(
                                  color: kshadowcolor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0.0, 3.0)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  LocaleKeys.slide_ad.tr(),
                                  style: GoogleFonts.cairo(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      color: !_isFixed
                                          ? kprimaryLightColor
                                          : kprimaryTextColor),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "($slidingPrice) ",
                                        style: GoogleFonts.getFont(
                                          'Cairo',
                                          fontSize: 17.sp,
                                          color: !_isFixed
                                              ? Colors.amber
                                              : kprimaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: LocaleKeys.rs.tr(),
                                        style: GoogleFonts.getFont(
                                          'Cairo',
                                          fontSize: 17.sp,
                                          color: !_isFixed
                                              ? Colors.amber
                                              : kprimaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFixed = true;
                            height = 380.h;
                          });
                        },
                        child: Container(
                          height: 55.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                            color:
                                _isFixed ? kprimaryColor : kprimaryLightColor,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                color: kprimaryColor, width: _isFixed ? 0 : 1),
                            boxShadow: [
                              BoxShadow(
                                  color: kshadowcolor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0.0, 3.0)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  LocaleKeys.fixed_ad.tr(),
                                  style: GoogleFonts.cairo(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _isFixed
                                        ? kprimaryLightColor
                                        : kprimaryTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Container(
                                // alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "($promotionPrice) ",
                                        style: GoogleFonts.getFont(
                                          'Cairo',
                                          fontSize: 17.sp,
                                          color: _isFixed
                                              ? Colors.amber
                                              : kprimaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: LocaleKeys.rs.tr(),
                                        style: GoogleFonts.getFont(
                                          'Cairo',
                                          fontSize: 17.sp,
                                          color: _isFixed
                                              ? Colors.amber
                                              : kprimaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      if (!_isFixed)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 19.w),
                          child: Text(
                            LocaleKeys.put_image.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 16.sp,
                              color: ksecondaryTextColor,
                            ),
                          ),
                        ),
                      if (!_isFixed)
                        SizedBox(
                          height: 8.h,
                        ),
                      if (!_isFixed)
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            margin: EdgeInsets.symmetric(horizontal: 19.w),
                            width: double.infinity,
                            height: 97.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: klightbleucolor,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: borderColor0),
                            ),
                            child: imagepath == ''
                                ? Center(
                                    child: Image.asset(
                                      'assets/icons/empty_file_icon.png',
                                      scale: 1.5,
                                    ),
                                  )
                                : Image.file(imageFile),
                          ),
                        ),
                      if (!_isFixed)
                        SizedBox(
                          height: 20.h,
                        ),
                    ],
                  ),
                ),
                widget.addOffer
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            borderColor0 = kbordercolor;
                          });
                          if (_slectedSecion == null) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return SnackabrDialog(
                                  status: false,
                                  message: LocaleKeys.select_section.tr(),
                                  onPopFunction: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                            return;
                          }

                          if (imageFile == null && !_isFixed) {
                            setState(() {
                              borderColor0 = kredcolor;
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          await OffersController.addOffer(
                            token: Provider.of<UserProvider>(context,
                                    listen: false)
                                .user
                                .token!,
                            file: _isFixed ? null : imageFile,
                            categoryId: _slectedSecion!.id.toString(),
                            type: _isFixed ? "1" : "2",
                          ).then((value0) {
                            setState(() {
                              isLoading = false;
                            });
                            print(value0);

                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: false,
                              enableDrag: false,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return SnackabrDialog(
                                  status: value0 == "success" ? true : false,
                                  message: value0 == "success"
                                      ? LocaleKeys
                                          .offer_discount_succes_dialog_text
                                          .tr()
                                      : LocaleKeys.operation_field.tr(),
                                  onPopFunction: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 19.w),
                          child: BottomButton(
                            title: LocaleKeys.send.tr(),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
