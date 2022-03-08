import 'package:animations/animations.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/discount_controller.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/models/discount/discount_list_item_model.dart';
import 'package:fishe_tender_fisher/models/products/categorie_model.dart';
import 'package:fishe_tender_fisher/models/products/fisher_products_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/category_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/delete_dialog_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_item.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_item_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/discount_model2.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/fiche_item_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/fiche_type_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/fish_market_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/market_card_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/add_product_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/edit_product_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/fishe_dtails2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MarketAccountScreen extends StatefulWidget {
  const MarketAccountScreen({Key? key}) : super(key: key);
  static final String routeName = '/market_account_screen';

  @override
  _MarketAccountScreenState createState() => _MarketAccountScreenState();
}

class _MarketAccountScreenState extends State<MarketAccountScreen> {
  ScrollController _scrollControllerProducts = new ScrollController();
  ScrollController _scrollControllerDiscounts = new ScrollController();
  ScrollController _scrollControllerCategories = new ScrollController();
  double _height = 36.h;
  double _bGheight = 220.h;
  double _cardHeight = 120.h;
  bool _isDiscountList = false;
  List<Discountlist> _discounts = [];
  List<FisherProducts> _fisherProducts = [];
  List<Categorie> _categories = [];
  Categorie? _selectedCategory;
  int pageNumberProducts = 1;
  int pageNumberDiscounts = 1;
  int pageNumberCategories = 1;
  bool _isLoadingProducts = false;
  bool _isLoadingDiscounts = false;
  bool _isLoadingCategories = false;
  var nextProducts;
  var nextCategories;
  var nextDiscounts;
  int categoryId = 0;
  bool isLarge = true;
  bool finalEmpty = false;
  bool _isShimmerProduct = true;
  bool _isShimmerDiscount = true;
  bool _isShimmerCategory = true;
  bool showEmptyDiscount = false;
  bool isAll = true;

  @override
  void dispose() {
    _scrollControllerCategories.dispose();
    _scrollControllerDiscounts.dispose();
    _scrollControllerProducts.dispose();

    super.dispose();
  }

  Future<void> productRefresh() async {
    if (mounted)
      setState(() {
        pageNumberProducts = 1;
        _fisherProducts.clear();
        _isShimmerProduct = true;
      });

    await ProductsControlller.getFisherProducts(
      isAll: isAll,
      token: Provider.of<UserProvider>(context, listen: false).user.token!,
      pageNumber: 1,
      categoryId: _selectedCategory!.id,
    ).then((fisherProducts) {
      if (mounted)
        setState(() {
          _fisherProducts = fisherProducts['data'];
          nextProducts = fisherProducts['next'];
          _isShimmerProduct = false;
        });
    });
  }

  Future<void> discountsRefresh() async {
    if (mounted)
      setState(() {
        pageNumberDiscounts = 1;
        _discounts.clear();
        _isShimmerDiscount = true;
      });

    await DiscountConroller.getDiscountList(
      Provider.of<UserProvider>(context, listen: false).user.token!,
      pageNumberDiscounts,
    ).then((value) {
      if (mounted)
        setState(() {
          _discounts = value["data"];
          nextDiscounts = value["next"];
          _isShimmerDiscount = false;
        });
    }).then((value) {});
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await DiscountConroller.getDiscountList(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        pageNumberDiscounts,
      ).then((value) {
        if (mounted)
          setState(() {
            _discounts = value["data"];
            nextDiscounts = value["next"];
            _isShimmerDiscount = false;
          });
      });

      await ProductsControlller.getCategories(
        bySection: false,
        fisherId: Provider.of<UserProvider>(context, listen: false).user.id!,
        token: Provider.of<UserProvider>(context, listen: false).user.token!,
        pageNumber: pageNumberCategories,
      ).then((categories) async {
        if (mounted)
          setState(() {
            if (categories['data'].isNotEmpty)
              _categories.add(
                Categorie(
                    id: -1,
                    name: LocaleKeys.show_all.tr(),
                    description: "",
                    iamageUrl: "assets/icons/plus.svg"),
              );
            _categories.addAll(categories['data']);

            if (_categories.isNotEmpty) {
              _selectedCategory = _categories.first;
            }
            nextCategories = categories['next'];
            _isShimmerCategory = false;
          });
        if (_selectedCategory != null) {
          await ProductsControlller.getFisherProducts(
            token:
                Provider.of<UserProvider>(context, listen: false).user.token!,
            isAll: isAll,
            pageNumber: pageNumberProducts,
            categoryId: _selectedCategory!.id,
          ).then((value) {
            if (mounted) if (mounted)
              setState(() {
                _fisherProducts = value['data'];
                nextProducts = value["next"];
                _isShimmerProduct = false;
              });
          });
        } else {
          _isShimmerProduct = false;
        }
      });
    });
    _scrollControllerCategories.addListener(() {
      if (_scrollControllerCategories.position.pixels >=
              _scrollControllerCategories.position.maxScrollExtent &&
          !_isLoadingCategories) {
        if (nextCategories != null) {
          Future.delayed(Duration.zero, () async {
            if (mounted)
              setState(() {
                _isLoadingCategories = true;
              });
            await ProductsControlller.getCategories(
                    bySection: false,
                    fisherId: Provider.of<UserProvider>(context, listen: false)
                        .user
                        .id!,
                    token: Provider.of<UserProvider>(context, listen: false)
                        .user
                        .token!,
                    pageNumber: ++pageNumberProducts)
                .then((categories) async {
              if (mounted)
                setState(() {
                  _categories.addAll(categories["data"]);

                  nextCategories = categories['next'];
                  _isLoadingCategories = false;
                });
            });
          });
        }
      }
    });
    _scrollControllerProducts.addListener(() {
      if (_scrollControllerProducts.position.pixels >=
              _scrollControllerProducts.position.maxScrollExtent &&
          !_isLoadingProducts) {
        if (nextProducts != null) {
          Future.delayed(Duration.zero, () async {
            if (mounted)
              setState(() {
                _isLoadingProducts = true;
              });
            await ProductsControlller.getFisherProducts(
              token:
                  Provider.of<UserProvider>(context, listen: false).user.token!,
              pageNumber: ++pageNumberProducts,
              categoryId: _selectedCategory!.id,
              isAll: isAll,
            ).then((fisherProucts) async {
              if (mounted)
                setState(() {
                  _fisherProducts.addAll(fisherProucts["data"]);
                  nextProducts = fisherProucts['next'];
                  _isLoadingProducts = false;
                });
            });
          });
        }
      }
      if (_scrollControllerProducts.offset >= 1 && _fisherProducts.length > 4) {
        if (mounted)
          setState(() {
            _height = 0;
            _bGheight = 100.h;
            _cardHeight = 63.h;
            isLarge = false;
          });
      }
      if (_scrollControllerProducts.offset <= 1) {
        if (mounted)
          setState(() {
            _height = 36.h;
            _bGheight = 257.h;
            _cardHeight = 120.h;
            isLarge = true;
          });
      }
    });
    _scrollControllerDiscounts.addListener(() {
      if (_scrollControllerDiscounts.position.pixels >=
              _scrollControllerDiscounts.position.maxScrollExtent &&
          !_isLoadingDiscounts) {
        if (nextDiscounts != null) {
          Future.delayed(Duration.zero, () async {
            if (mounted)
              setState(() {
                _isLoadingDiscounts = true;
              });
            await DiscountConroller.getDiscountList(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              ++pageNumberDiscounts,
            ).then((discounts) {
              if (mounted)
                setState(() {
                  _discounts.addAll(discounts["data"]);
                  nextDiscounts = discounts['next'];
                  _isLoadingDiscounts = false;
                });
            });
          });
        }
      }
      if (_scrollControllerDiscounts.offset >= 1 && _discounts.length > 4) {
        if (mounted)
          setState(() {
            _height = 0;
            _bGheight = 100.h;
            _cardHeight = 63.h;
          });
      }
      if (_scrollControllerDiscounts.offset <= 1) {
        if (mounted)
          setState(() {
            _height = 36.h;
            _bGheight = 257.h;
            _cardHeight = 120.h;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      body: Stack(children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: _bGheight,
          width: double.infinity,
          child: Image.asset(
            'assets/images/Bg_header.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 70.h, right: 16.w, left: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    height: _height,
                    width: 36.w,
                    duration: Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kprimaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: kshadowcolor,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0.0, 3.0)),
                      ],
                    ),
                    child: InkWell(
                      splashColor: kprimaryLightColor, // Splash color
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: _height != 0
                          ? Icon(
                              Icons.chevron_left,
                              size: 30.sp,
                              color: kprimaryLightColor,
                            )
                          : SizedBox(),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.bounceInOut,
                    height: _height,
                    child: TextButton(
                      onPressed: () {
                        if (Provider.of<UserProvider>(context, listen: false)
                                .user
                                .status ==
                            "2") {
                          Navigator.of(context)
                              .pushNamed(AddProductView.routeName)
                              .then((value) async {
                            if (value == true)
                              await ProductsControlller.getCategories(
                                bySection: false,
                                fisherId: Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user.id!,
                                token: Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user.token!,
                                pageNumber: pageNumberCategories,
                              ).then((categories) async {
                                if (mounted)
                                  setState(() {
                                    _isShimmerCategory = true;
                                    _categories.clear();
                                    if (categories['data'].isNotEmpty)
                                      _categories.add(
                                        Categorie(
                                          id: -1,
                                          name: LocaleKeys.show_all.tr(),
                                          description: "",
                                          iamageUrl: "assets/icons/plus.svg",
                                        ),
                                      );
                                    _categories.addAll(categories['data']);

                                    if (_categories.isNotEmpty) {
                                      _selectedCategory = _categories.first;
                                      if ((_discounts.any((element) =>
                                              element.product.categoryId ==
                                              _selectedCategory!.id
                                                  .toString())) ||
                                          _selectedCategory!.id == -1) {
                                        if (mounted)
                                          setState(() {
                                            showEmptyDiscount = false;
                                          });
                                      } else {
                                        if (mounted)
                                          setState(() {
                                            showEmptyDiscount = true;
                                          });
                                      }
                                      if (mounted)
                                        setState(
                                          () {
                                            _selectedCategory =
                                                _selectedCategory;
                                            pageNumberProducts = 1;
                                            _isShimmerProduct = true;
                                            _isShimmerCategory = false;
                                          },
                                        );
                                    }
                                    nextCategories = categories['next'];
                                  });
                                if (_selectedCategory != null) {
                                  await ProductsControlller.getFisherProducts(
                                    isAll: isAll,
                                    token: Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .token!,
                                    pageNumber: pageNumberProducts,
                                    categoryId: _selectedCategory!.id,
                                  ).then((fisherProducts) {
                                    if (mounted)
                                      setState(
                                        () {
                                          _fisherProducts =
                                              fisherProducts['data'];
                                          nextProducts = fisherProducts['next'];
                                          _isShimmerProduct = false;
                                        },
                                      );
                                  });
                                } else {
                                  _isShimmerProduct = false;
                                }
                              });
                          });
                        } else {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return SnackabrDialog(
                                status: false,
                                message: LocaleKeys.account_under_review.tr(),
                                onPopFunction: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(kprimaryLightColor),
                        alignment: Alignment.center,
                        elevation: MaterialStateProperty.all(1),
                        enableFeedback: true,
                        backgroundColor:
                            MaterialStateProperty.all(kprimaryColor),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 7.h,
                        )),
                        shadowColor:
                            MaterialStateProperty.all(kprimaryLightColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 400),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: kprimaryTextColor,
                              height: 1.5,
                            ),
                            child: Text(
                              LocaleKeys.market_account_ass_fish.tr(),
                              style: GoogleFonts.getFont(
                                'Tajawal',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: kprimaryLightColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            child: ClipOval(
                              child: FittedBox(
                                child: CircleAvatar(
                                  backgroundColor: kprimaryLightColor,
                                  child: Icon(
                                    FontAwesomeIcons.plus,
                                    color: kprimaryColor,
                                    size: 20.sp,
                                  ),
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
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: _height != 0 ? 40.h : 0),
            MarketCardView(
              height: _cardHeight,
            ),
            SizedBox(
              height: 13.h,
            ),
            Container(
              height: 60.h,
              margin: EdgeInsets.only(left: 8.w),
              child: !_isShimmerCategory
                  ? Stack(
                      children: [
                        _categories.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                controller: _scrollControllerCategories,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  Categorie categoty = _categories[index];

                                  return GestureDetector(
                                    onTap: () async {
                                      if (categoty.id == -1) {
                                        if (mounted)
                                          setState(() {
                                            pageNumberProducts = 1;
                                            pageNumberDiscounts = 1;
                                            isAll = true;
                                            _isShimmerProduct = true;
                                            _selectedCategory = categoty;
                                          });
                                        await ProductsControlller
                                            .getFisherProducts(
                                          token: Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .user
                                              .token!,
                                          isAll: isAll,
                                          pageNumber: pageNumberProducts,
                                          categoryId: _selectedCategory!.id,
                                        ).then((value) {
                                          if (mounted)
                                            setState(() {
                                              _fisherProducts = value['data'];
                                              nextProducts = value["next"];
                                              _isShimmerProduct = false;
                                            });
                                        });
                                        await DiscountConroller.getDiscountList(
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user
                                              .token!,
                                          pageNumberDiscounts,
                                        ).then((value) {
                                          if (mounted)
                                            setState(() {
                                              _discounts = value["data"];
                                              nextDiscounts = value["next"];
                                              _isShimmerDiscount = false;
                                            });
                                        });
                                      } else {
                                        if (mounted)
                                          setState(() {
                                            isAll = false;
                                          });
                                        if (_discounts.any((element) =>
                                            element.product.categoryId ==
                                            categoty.id.toString())) {
                                          if (mounted)
                                            setState(() {
                                              showEmptyDiscount = false;
                                            });
                                        } else {
                                          if (mounted)
                                            setState(() {
                                              showEmptyDiscount = true;
                                            });
                                        }
                                        if (mounted)
                                          setState(() {
                                            _selectedCategory = categoty;
                                            pageNumberProducts = 1;
                                            _isShimmerProduct = true;
                                          });

                                        await ProductsControlller
                                            .getFisherProducts(
                                          isAll: isAll,
                                          token: Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .user
                                              .token!,
                                          pageNumber: pageNumberProducts,
                                          categoryId: _selectedCategory!.id,
                                        ).then((value) {
                                          if (mounted)
                                            setState(() {
                                              _fisherProducts = value['data'];
                                              nextProducts = value["next"];
                                              _isShimmerProduct = false;
                                            });
                                        });
                                      }
                                    },
                                    child: FisheTypeModel(
                                      isShowAll:
                                          categoty.id == -1 ? true : false,
                                      image: categoty.iamageUrl,
                                      title: categoty.name,
                                      isSelected: _selectedCategory == null
                                          ? false
                                          : categoty == _selectedCategory
                                              ? true
                                              : false,
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 8.w,
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
                        if (_isLoadingCategories)
                          Positioned(
                            right: 10.h,
                            child: Container(
                              height: 60.h,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryShimmer(),
                          SizedBox(
                            width: 8.w,
                          ),
                          CategoryShimmer(),
                          SizedBox(
                            width: 8.w,
                          ),
                          CategoryShimmer(),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (mounted)
                            setState(() {
                              _isDiscountList = false;
                            });
                        },
                        child: Container(
                          height: 55.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                            color: _isDiscountList
                                ? kprimaryLightColor
                                : kprimaryColor,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                color: kprimaryColor,
                                width: _isDiscountList ? 1 : 0),
                            boxShadow: [
                              BoxShadow(
                                  color: kshadowcolor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0.0, 3.0)),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.my_products.tr(),
                              style: GoogleFonts.cairo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: _isDiscountList
                                    ? kprimaryColor
                                    : kprimaryLightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted)
                            setState(() {
                              _isDiscountList = true;
                            });
                        },
                        child: Container(
                          height: 55.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                            color: _isDiscountList
                                ? kprimaryColor
                                : kprimaryLightColor,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                color: kprimaryColor,
                                width: _isDiscountList ? 0 : 1),
                            boxShadow: [
                              BoxShadow(
                                  color: kshadowcolor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0.0, 3.0)),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.my_discounts.tr(),
                              style: GoogleFonts.cairo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: _isDiscountList
                                    ? kprimaryLightColor
                                    : kprimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Expanded(
                  child: !_isDiscountList
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: !_isShimmerProduct
                              ? Stack(
                                  children: [
                                    RefreshIndicator(
                                      onRefresh: productRefresh,
                                      child: _fisherProducts.isNotEmpty
                                          ? ListView.separated(
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              controller:
                                                  _scrollControllerProducts,
                                              itemCount: _fisherProducts.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                FisherProducts _product =
                                                    _fisherProducts[index];
                                                var val = _fisherProducts[index]
                                                    .discount
                                                    .value;

                                                return OpenContainer(
                                                  onClosed: (changed) {
                                                    if (changed != false) {
                                                      productRefresh();
                                                      discountsRefresh();
                                                    }
                                                  },
                                                  closedColor:
                                                      kprimaryLightColor,
                                                  openColor: kprimaryLightColor,
                                                  middleColor:
                                                      kprimaryLightColor,
                                                  closedElevation: 0,
                                                  transitionType:
                                                      ContainerTransitionType
                                                          .fadeThrough,
                                                  transitionDuration: Duration(
                                                      milliseconds: 500),
                                                  closedBuilder:
                                                      (BuildContext _,
                                                          VoidCallback
                                                              openContainer) {
                                                    return FisheItemModel(
                                                      deleteFunction: () {
                                                        showModal<bool>(
                                                          context: context,
                                                          configuration:
                                                              FadeScaleTransitionConfiguration(
                                                            transitionDuration:
                                                                Duration(
                                                              microseconds: 400,
                                                            ),
                                                            reverseTransitionDuration:
                                                                Duration(
                                                              microseconds: 400,
                                                            ),
                                                          ),
                                                          builder: (BuildContext
                                                              context) {
                                                            return DeleteDialogModel(
                                                              id: _product.id,
                                                              isDiscount: false,
                                                            );
                                                          },
                                                        ).then((value) {
                                                          if (value == true) {
                                                            productRefresh();
                                                          }
                                                        });
                                                      },
                                                      updateFunction: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditProductView(
                                                              id: _product.id,
                                                            ),
                                                          ),
                                                        ).then((value) async {
                                                          productRefresh();
                                                        });
                                                      },
                                                      discountFunction: () {
                                                        showModalBottomSheet<
                                                            bool>(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          enableDrag: true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          builder: (BuildContext
                                                              context) {
                                                            if (_product
                                                                    .discount
                                                                    .id ==
                                                                "null") {
                                                              return DiscountModel(
                                                                prouctId:
                                                                    _product.id,
                                                              );
                                                            } else {
                                                              return DiscountModel2(
                                                                value: _product
                                                                    .discount
                                                                    .value,
                                                                from: _product
                                                                    .discount
                                                                    .from,
                                                                to: _product
                                                                    .discount
                                                                    .to,
                                                                discountId:
                                                                    _product
                                                                        .discount
                                                                        .id,
                                                              );
                                                            }
                                                          },
                                                        ).then((value) async {
                                                          if (value ==
                                                              true) if (mounted) {
                                                            setState(() {
                                                              pageNumberDiscounts =
                                                                  1;
                                                              _discounts
                                                                  .clear();
                                                              _isShimmerDiscount =
                                                                  true;
                                                            });

                                                            await DiscountConroller
                                                                .getDiscountList(
                                                              Provider.of<UserProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .user
                                                                  .token!,
                                                              pageNumberDiscounts,
                                                            ).then((value) {
                                                              if (mounted)
                                                                setState(() {
                                                                  _discounts =
                                                                      value[
                                                                          "data"];
                                                                  nextDiscounts =
                                                                      value[
                                                                          "next"];
                                                                  _isShimmerDiscount =
                                                                      false;
                                                                });
                                                            }).then((value) {
                                                              productRefresh();
                                                              discountsRefresh();
                                                            });
                                                          }
                                                        });
                                                      },
                                                      discount: val == "null"
                                                          ? 0
                                                          : double.parse(val),
                                                      id: _product.id,
                                                      imageUrl: _product.images
                                                          .first.imageUrl,
                                                      name:
                                                          _product.product.name,
                                                      description: _product
                                                          .product.description,
                                                      price:
                                                          _product.lowestPrice,
                                                      visible:
                                                          _product.isActive,
                                                    );
                                                  },
                                                  openBuilder: (BuildContext _,
                                                      VoidCallback __) {
                                                    return FisheDetailsMarket(
                                                      picurl: _product.images
                                                          .first.imageUrl,
                                                      id: _product.id,
                                                      isActive:
                                                          _product.isActive,
                                                    );
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider();
                                              },
                                            )
                                          : Center(
                                              child: Text(
                                                LocaleKeys.no_data.tr(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 16.sp,
                                                    color: kprimaryTextColor,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                    ),
                                    if (_isLoadingProducts)
                                      Positioned(
                                        bottom: 20.h,
                                        child: Container(
                                          width: 390.w,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                      ),
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      FishMarketShimmer(),
                                      Divider(),
                                      FishMarketShimmer(),
                                      Divider(),
                                      FishMarketShimmer(),
                                      Divider(),
                                      FishMarketShimmer(),
                                    ],
                                  ),
                                ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: !_isShimmerDiscount
                              ? Stack(
                                  children: [
                                    RefreshIndicator(
                                      onRefresh: discountsRefresh,
                                      child: showEmptyDiscount
                                          ? ListView.builder(
                                              itemCount: 1,
                                              padding:
                                                  EdgeInsets.only(top: 150.h),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Center(
                                                  child: Text(
                                                    LocaleKeys.no_data.tr(),
                                                    style: GoogleFonts.tajawal(
                                                        fontSize: 16.sp,
                                                        color:
                                                            kprimaryTextColor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              },
                                            )
                                          : _discounts.isNotEmpty
                                              ? ListView.separated(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  controller:
                                                      _scrollControllerDiscounts,
                                                  itemCount: _discounts.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    Discountlist _discount =
                                                        _discounts[index];
                                                    print(_discount.id);

                                                    if (_selectedCategory !=
                                                        null) {
                                                      if (_discount.product
                                                                  .categoryId ==
                                                              _selectedCategory!
                                                                  .id
                                                                  .toString() ||
                                                          _selectedCategory!
                                                                  .id ==
                                                              -1)
                                                        return DiscountItem(
                                                          deleteDiscount: () {
                                                            showModal<bool>(
                                                              context: context,
                                                              configuration:
                                                                  FadeScaleTransitionConfiguration(
                                                                transitionDuration:
                                                                    Duration(
                                                                  microseconds:
                                                                      400,
                                                                ),
                                                                reverseTransitionDuration:
                                                                    Duration(
                                                                  microseconds:
                                                                      400,
                                                                ),
                                                              ),
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return DeleteDialogModel(
                                                                  id: _discount
                                                                      .id,
                                                                  isDiscount:
                                                                      true,
                                                                );
                                                              },
                                                            ).then(
                                                              (value) {
                                                                discountsRefresh();
                                                                productRefresh();
                                                              },
                                                            );
                                                          },
                                                          discountFunc: () {
                                                            showModalBottomSheet<
                                                                bool>(
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              enableDrag: true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return DiscountModel2(
                                                                  discountId: _discount
                                                                      .discount
                                                                      .id
                                                                      .toString(),
                                                                  value: _discount
                                                                      .discount
                                                                      .value,
                                                                  from: _discount
                                                                      .discount
                                                                      .from,
                                                                  to: _discount
                                                                      .discount
                                                                      .to,
                                                                );
                                                              },
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                discountsRefresh();
                                                                productRefresh();
                                                              }
                                                            });
                                                          },
                                                          discountetails:
                                                              _discount,
                                                        );
                                                    }
                                                    return SizedBox();
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    Discountlist _discount =
                                                        _discounts[index];
                                                    if (_selectedCategory !=
                                                        null) {
                                                      if (_discount.product
                                                                  .categoryId ==
                                                              _selectedCategory!
                                                                  .id
                                                                  .toString() ||
                                                          isAll)
                                                        return Divider();
                                                    }
                                                    return SizedBox();
                                                  },
                                                )
                                              : Center(
                                                  child: Text(
                                                    LocaleKeys.no_data.tr(),
                                                    style: GoogleFonts.tajawal(
                                                        fontSize: 16.sp,
                                                        color:
                                                            kprimaryTextColor,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                    ),
                                    if (_isLoadingProducts)
                                      Positioned(
                                        bottom: 20.h,
                                        child: Container(
                                          width: 390.w,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      DiscountItemShimmer(),
                                      Divider(),
                                      DiscountItemShimmer(),
                                      Divider(),
                                      DiscountItemShimmer(),
                                      Divider(),
                                      DiscountItemShimmer(),
                                    ],
                                  ),
                                ),
                        ),
                ),
              ],
            )),
          ],
        )
      ]),
    );
  }
}
