import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/models/discount/discount_model.dart';
import 'package:fishe_tender_fisher/models/products/categorie_model.dart';
import 'package:fishe_tender_fisher/models/products/details_service_model.dart';
import 'package:fishe_tender_fisher/models/products/fisher_product_detail_model.dart';
import 'package:fishe_tender_fisher/models/products/product_2_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/delete_dialog_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_model2.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/unit_widget2.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/edit_product_view.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/components/servic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class FisheDetailsMarket extends StatefulWidget {
  final int id;
  final String isActive;
  final String picurl;

  const FisheDetailsMarket(
      {Key? key,
      required this.id,
      required this.isActive,
      required this.picurl})
      : super(key: key);
  @override
  _FisheDetailsMarketState createState() => _FisheDetailsMarketState();
}

class _FisheDetailsMarketState extends State<FisheDetailsMarket> {
  List<DetailsService> _services = [];
  String _currentstate = '1';
  var dateTime;

  bool isPageLoading = false;
  FisherProductsDetails _fisherProductsDetails = FisherProductsDetails(
      discount:
          Discount(content: "", from: "", id: "", name: "", to: "", value: ""),
      createdAt: "",
      id: 0,
      productId: 0,
      product: Product2(
          id: 0,
          name: '',
          description: '',
          categoryId: 0,
          category: Categorie(id: 0, name: '', description: '', iamageUrl: '')),
      services: [],
      units: [],
      images: []);

  @override
  void initState() {
    if (mounted)
      setState(() {
        _currentstate = widget.isActive;
        isPageLoading = true;
      });
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ProductsControlller.getFisherProductDetails(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              widget.id)
          .then((value) {
        if (value != null) {
          if (mounted)
            setState(() {
              _fisherProductsDetails = value;
              _services = value.services;
              dateTime = DateTime.parse(value.createdAt);
              isPageLoading = false;
            });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarWidget(
                  title: LocaleKeys.product_details.tr(),
                  cangoback: true,
                  function: () {
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 250.h,
                          width: double.infinity,
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: ClipRRect(
                            //borderRadius: BorderRadius.circular(10.r),
                            child: Hero(
                              tag: "img" + widget.id.toString(),
                              child: CachedNetworkImage(
                                imageUrl: widget.picurl,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _fisherProductsDetails.units.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(width: 15.w);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return UnitWidget2(
                                  discount:
                                      _fisherProductsDetails.discount.id == ""
                                          ? ""
                                          : _fisherProductsDetails
                                              .discount.value
                                              .toString(),
                                  price: _fisherProductsDetails
                                      .units[index].price
                                      .toString(),
                                  name:
                                      _fisherProductsDetails.units[index].name,
                                  isSelected: true,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _fisherProductsDetails.product.name,
                                style: GoogleFonts.cairo(
                                    fontSize: 22.sp,
                                    color: kprimaryTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                //height: 15.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.clock,
                                      color: kprimaryTextColor,
                                      size: 16.sp,
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Center(
                                      child: Text(
                                        !isPageLoading
                                            ? "${dateTime.year} - ${dateTime.month} - ${dateTime.day}"
                                            : "",
                                        style: GoogleFonts.tajawal(
                                          fontSize: 18.sp,
                                          color: kprimaryTextColor,
                                          height: 1.3,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  _fisherProductsDetails.product.description,
                                  style: GoogleFonts.cairo(
                                      fontSize: 16.sp,
                                      color: ksecondaryTextColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Align(
                            alignment: context.locale.toLanguageTag() == 'en'
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              LocaleKeys.services.tr(),
                              style: GoogleFonts.tajawal(
                                fontSize: 20.sp,
                                color: kprimaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 190.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 0),
                            child: _services.isNotEmpty
                                ? ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: _services.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 10.h,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ServiceWidget(
                                        discount: _fisherProductsDetails
                                                    .discount.id ==
                                                ""
                                            ? ""
                                            : _fisherProductsDetails
                                                .discount.value
                                                .toString(),
                                        name: _services[index].name,
                                        price: _services[index].price,
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      LocaleKeys.no_data.tr(),
                                      style: GoogleFonts.tajawal(
                                          fontSize: 16.sp,
                                          color: kprimaryTextColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100.h,
                color: Colors.transparent,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              print(_fisherProductsDetails.discount.id);
                              if (_fisherProductsDetails.discount.id == "" ||
                                  _fisherProductsDetails.discount.id ==
                                      "null" ||
                                  _fisherProductsDetails.discount.id == null) {
                                return DiscountModel(
                                  prouctId: widget.id,
                                );
                              } else {
                                return DiscountModel2(
                                  value: _fisherProductsDetails.discount.value,
                                  from: _fisherProductsDetails.discount.from,
                                  to: _fisherProductsDetails.discount.to,
                                  discountId:
                                      _fisherProductsDetails.discount.id,
                                );
                              }
                            },
                          ).then((value) async {
                            if (value == true) {
                              await ProductsControlller.getFisherProductDetails(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user
                                          .token!,
                                      widget.id)
                                  .then((value) {
                                if (value != null) {
                                  if (mounted)
                                    setState(() {
                                      _fisherProductsDetails = value;
                                      _services = value.services;
                                      dateTime =
                                          DateTime.parse(value.createdAt);
                                      isPageLoading = false;
                                    });
                                }
                              });
                            }
                          });
                        },
                        child: Container(
                          height: 50.h,
                          width: 50.w,
                          padding: EdgeInsets.all(5),
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
                          child: SvgPicture.asset(
                            'assets/icons/ic_discount.svg',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
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
                          height: 50.h,
                          width: 50.w,
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
                                  size: 30.sp,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: kprimaryTextColor,
                                  size: 30.sp,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductView(
                                id: widget.id,
                              ),
                            ),
                          ).then(
                            (value) async => {
                              Navigator.pop(context),
                              // await ProductsControlller.getFisherProductDetails(
                              //   Provider.of<UserProvider>(
                              //     context,
                              //     listen: false,
                              //   ).user.token!,
                              //   widget.id,
                              // ).then((value) {
                              //   if (value != null) {
                              //     if (mounted)
                              //       setState(() {
                              //         _fisherProductsDetails = value;
                              //         _services = value.services;
                              //         dateTime =
                              //             DateTime.parse(value.createdAt);
                              //         isPageLoading = false;
                              //       });
                              //   }
                              // }),
                            },
                          );
                        },
                        child: Container(
                          height: 50.h,
                          width: 50.w,
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
                            size: 30.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModal(
                            context: context,
                            configuration: FadeScaleTransitionConfiguration(
                              transitionDuration: Duration(
                                microseconds: 400,
                              ),
                              reverseTransitionDuration: Duration(
                                microseconds: 400,
                              ),
                            ),
                            builder: (BuildContext context) {
                              return DeleteDialogModel(
                                id: widget.id,
                                isDiscount: false,
                              );
                            },
                          ).then((value) {
                            Navigator.pop(context, true);
                          });
                        },
                        child: Container(
                          height: 50.h,
                          width: 50.w,
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
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isPageLoading)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
