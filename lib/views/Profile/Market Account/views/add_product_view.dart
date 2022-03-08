import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/section_shimmer.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/products_controller.dart';
import 'package:fishe_tender_fisher/models/products/image_model.dart';
import 'package:fishe_tender_fisher/models/products/categorie_model.dart';
import 'package:fishe_tender_fisher/models/products/product_model.dart';
import 'package:fishe_tender_fisher/models/products/section_model.dart';
import 'package:fishe_tender_fisher/models/products/service_model.dart';
import 'package:fishe_tender_fisher/models/products/unit_model.dart';
import 'package:fishe_tender_fisher/services/image_provider.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/logo_cover_model.dart';
import 'package:fishe_tender_fisher/common/section_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:fishe_tender_fisher/models/products/services_addition_model.dart';
import 'package:fishe_tender_fisher/models/products/units_addition_model.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);
  static final String routeName = '/add_product_view';

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  String details = "";
  var borderColor = kbordercolor;
  var borderColorGrid = kbordercolor;

  Section? _slectedSecion;
  Categorie? _selectedCategorie;
  Product? _selectedProduct;
  late List<Categorie> _categories = [];
  late List<Product> _products = [];
  late List<Section> _sections = [];
  bool _isPageLoading = true;
  List<Img> altImages = [];
  Img? selectedImage;
  int pagecategories = 1;
  int pageProducts = 1;
  var nextP;
  var nextC;

  TextEditingController _unitController = TextEditingController();
  TextEditingController _serviceController = TextEditingController();
  Unit? _selectedUnit;
  Service? _selectedService;
  List<Unit> _units = [];
  List<Service> _services = [];
  List<Unit> _selectedUnits = [];
  List<Service> _selectedServices = [];
  List<AddUnit> _finalSelectedUnits = [];
  List<AddService> _finalSelectedServices = [];
  var borderUnit = kbordercolor;
  var borderpriceunit = kbordercolor;
  var borderpriceService = kbordercolor;
  var borderservice = kbordercolor;
  var nextS;
  var pageServices = 1;
  var nextU;
  var pageUnits = 1;
  var height = 0.h;
  var height2 = 0.h;

  String replaceArabicNumbers(String input) {
    const arabic = ['٩', '٨', '٧', '٦', '٥', '٤', '٣', '٢', '١', '٠'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const rEnglish = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '0'];

    for (int i = 0; i < english.length; i++) {
      context.locale.toLanguageTag() == "en"
          ? input = input.replaceAll(arabic[i], english[i])
          : input = input.replaceAll(arabic[i], rEnglish[i]);
    }

    return input;
  }

  Future<void> fetchAllServices() async {
    do {
      await ProductsControlller.getService(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        pageServices,
      ).then((value) {
        if (mounted)
          setState(() {
            _services.addAll(value["data"]);
            nextS = value["next"];
          });
      });
      pageServices++;
    } while (nextS != null);
  }

  Future<void> fetchAllUnits() async {
    do {
      await ProductsControlller.getunits(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              pageUnits)
          .then((value) {
        if (mounted)
          setState(() {
            _units.addAll(value["data"]);
            nextU = value["next"];
          });
      });
      pageUnits++;
    } while (nextU != null);
  }

  @override
  void initState() {
    if (mounted)
      setState(() {
        _isPageLoading = true;
      });
    fetchAllServices();
    fetchAllUnits();
    Future.delayed(Duration.zero, () async {
      await ProductsControlller.getSectionList(
              Provider.of<UserProvider>(context, listen: false).user.token!)
          .then((value) {
        if (mounted)
          setState(() {
            _sections = value;
            _slectedSecion = value.first;
            _isPageLoading = false;
          });
      }).then((value) async {
        await ProductsControlller.getCategories(
          pageNumber: pagecategories,
          token: Provider.of<UserProvider>(context, listen: false).user.token!,
          sectionId: _slectedSecion!.id,
          bySection: true,
        ).then((value) {
          if (mounted)
            setState(() {
              _categories = value["data"];
              _selectedCategorie = _categories.first;
            });
        });
      }).then((value) async {
        do {
          await ProductsControlller.getProductsList(
            page: pageProducts,
            token:
                Provider.of<UserProvider>(context, listen: false).user.token!,
            categoryId: _selectedCategorie!.id,
          ).then((value) {
            if (value != null) if (mounted)
              setState(() {
                _products.addAll(value["data"]);
                nextP = value["next"];
              });
          });
          ++pageProducts;
        } while (nextP != null);
      });
    });
    super.initState();
  }

  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(
            context,
            changed,
          );
          return false;
        },
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarWidget(
                    title: LocaleKeys.market_account_ass_fish.tr(),
                    cangoback: true,
                    function: () {
                      Provider.of<ImgProvider>(context, listen: changed)
                          .clearImages();
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            child: TitleWidget(
                              title: LocaleKeys.section.tr(),
                              color: kprimaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            height: 90.h,
                            child: _sections.isNotEmpty
                                ? ListView.separated(
                                    itemCount: _sections.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Section _section = _sections[index];
                                      print(_section.id);
                                      return GestureDetector(
                                        onTap: () async {
                                          if (_section.isActive == '1') {
                                            if (mounted)
                                              setState(() {
                                                _isPageLoading = true;

                                                _selectedProduct = null;
                                                _selectedCategorie = null;
                                                _products.clear();
                                                _categories.clear();
                                                _slectedSecion = _section;
                                              });
                                          }
                                          await ProductsControlller
                                              .getCategories(
                                            pageNumber: 0,
                                            token: Provider.of<UserProvider>(
                                                    context,
                                                    listen: false)
                                                .user
                                                .token!,
                                            sectionId: _section.id,
                                            bySection: true,
                                          ).then((value) {
                                            if (mounted)
                                              setState(() {
                                                _isPageLoading = false;

                                                _categories = value["data"];
                                              });
                                          });
                                        },
                                        child: SectionItem(
                                          id: _section.id,
                                          name: _section.id == 1
                                              ? LocaleKeys.fishe_market.tr()
                                              : _section.id == 2
                                                  ? LocaleKeys.freezers.tr()
                                                  : _section.id == 3
                                                      ? LocaleKeys.fishe_resto
                                                          .tr()
                                                      : _section.id == 4
                                                          ? LocaleKeys.sushi
                                                              .tr()
                                                          : LocaleKeys.caviar
                                                              .tr(),
                                          imagePath: _section.id == 1
                                              ? 'assets/images/fishe_market.svg'
                                              : _section.id == 2
                                                  ? 'assets/images/freezers.png'
                                                  : _section.id == 3
                                                      ? 'assets/images/fishe_restorants.svg'
                                                      : _section.id == 4
                                                          ? 'assets/images/sushi.svg'
                                                          : 'assets/images/caviar.svg',
                                          isSelected: _slectedSecion == _section
                                              ? true
                                              : false,
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SectionShimmer();
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(width: 10.w);
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            child: TitleWidget(
                              title:
                                  LocaleKeys.market_account_fish_category.tr(),
                              color: kprimaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: kshadowcolor),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: DropdownButton<Categorie>(
                              onTap: () {
                                if (_slectedSecion == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      LocaleKeys.select_section.tr(),
                                    ),
                                    backgroundColor: kredcolor,
                                    duration: Duration(milliseconds: 800),
                                  ));
                                }
                              },
                              hint: Text(
                                LocaleKeys.select_category.tr(),
                                style: TextStyle(color: ksecondaryTextColor),
                              ),
                              value: _selectedCategorie,
                              underline: SizedBox(
                                height: 0,
                              ),
                              isExpanded: true,
                              iconSize: 15.sp,
                              icon: Icon(
                                FontAwesomeIcons.chevronDown,
                              ),
                              items: (_categories).map((Categorie categorie) {
                                return DropdownMenuItem<Categorie>(
                                  value: categorie,
                                  child: new Text(categorie.name),
                                );
                              }).toList(),
                              onChanged: (Categorie? newValue) async {
                                if (mounted)
                                  setState(() {
                                    nextP = null;
                                    _isPageLoading = true;
                                    pageProducts = 1;
                                    _selectedProduct = null;
                                    _products.clear();
                                    _selectedCategorie = newValue;
                                  });
                                do {
                                  await ProductsControlller.getProductsList(
                                    page: pageProducts,
                                    token: Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .token!,
                                    categoryId: _selectedCategorie!.id,
                                  ).then((value) {
                                    if (value != null) if (mounted)
                                      setState(() {
                                        _products.addAll(value["data"]);
                                        nextP = value["next"];
                                      });
                                  });
                                  ++pageProducts;
                                } while (nextP != null);
                                _isPageLoading = false;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            child: TitleWidget(
                              title: LocaleKeys.market_account_fish_name.tr(),
                              color: kprimaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: borderColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: DropdownButton<Product>(
                              hint: Text(
                                LocaleKeys.select_name.tr(),
                                style: TextStyle(color: ksecondaryTextColor),
                              ),
                              value: _selectedProduct,
                              underline: SizedBox(
                                height: 0,
                              ),
                              isExpanded: true,
                              iconSize: 15.sp,
                              icon: Icon(
                                FontAwesomeIcons.chevronDown,
                              ),
                              items: (_products).map((Product product) {
                                return DropdownMenuItem<Product>(
                                  value: product,
                                  child: new Text(product.name),
                                );
                              }).toList(),
                              onChanged: (Product? newValue) {
                                if (mounted)
                                  setState(() {
                                    _selectedProduct = newValue;
                                    details = newValue!.description;
                                  });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            child: TitleWidget(
                              title: LocaleKeys.put_image.tr(),
                              color: kprimaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_selectedProduct != null) {
                                if (mounted)
                                  setState(() {
                                    borderColorGrid = kbordercolor;
                                  });
                                showModalBottomSheet<Img>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return LogoAndCoverModel(
                                        pName: _selectedProduct!.name,
                                        isImage: true,
                                      );
                                    }).then((value) {
                                  if (value != null) {
                                    if (mounted)
                                      setState(() {
                                        selectedImage = value;
                                      });
                                  }
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 18.w),
                              height: 127.h,
                              decoration: BoxDecoration(
                                color: klightbleucolor,
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: borderColorGrid,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/icons/empty_file_icon.png',
                                      scale: 1.5,
                                    ),
                                  ),
                                  if (selectedImage != null &&
                                      Provider.of<ImgProvider>(context,
                                              listen: true)
                                          .isEmpty())
                                    Center(
                                      child: Container(
                                        width: 120.w,
                                        height: 127.h,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    selectedImage!.imageUrl,
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                color: Colors.black38,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (Provider.of<ImgProvider>(context,
                                          listen: true)
                                      .imageFile
                                      .isNotEmpty)
                                    Consumer<ImgProvider>(
                                      builder: (context, imageProvider, child) {
                                        return Center(
                                          child: Container(
                                            width: 120.w,
                                            height: 127.h,
                                            child: Stack(
                                              children: [
                                                if (Provider.of<ImgProvider>(
                                                        context,
                                                        listen: true)
                                                    .imageFile
                                                    .isNotEmpty)
                                                  Center(
                                                    child: Image.file(
                                                        imageProvider
                                                            .imageFile.first),
                                                  ),
                                                Center(
                                                  child: Container(
                                                    color: Colors.black38,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleWidget(
                                  title:
                                      LocaleKeys.market_account_fish_units.tr(),
                                  color: kprimaryColor,
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Container(
                                  height: 54.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                color: borderUnit),
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: DropdownButton<Unit>(
                                          hint: Text(
                                            LocaleKeys.market_account_fish_units
                                                .tr(),
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: ksecondaryTextColor),
                                          ),
                                          value: _selectedUnit,
                                          underline: Container(
                                            height: 0,
                                          ),
                                          isExpanded: true,
                                          iconSize: 15.sp,
                                          icon: Icon(
                                            FontAwesomeIcons.chevronDown,
                                          ),
                                          items: _units.map((Unit unit) {
                                            return DropdownMenuItem<Unit>(
                                              value: unit,
                                              child: new Text(
                                                unit.name,
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    overflow:
                                                        TextOverflow.clip),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (Unit? newValue) {
                                            if (mounted)
                                              setState(() {
                                                borderUnit = kbordercolor;
                                                _selectedUnit = newValue;
                                              });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 11.w,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        width: 110.w,
                                        height: 54.h,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                color: borderpriceunit),
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: TextField(
                                          autofocus: false,
                                          style: GoogleFonts.getFont(
                                            'Tajawal',
                                            fontSize: 16.sp,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: LocaleKeys.price.tr(),
                                            hintStyle: TextStyle(
                                                fontSize: 16.sp,
                                                color: ksecondaryTextColor),
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          controller: _unitController,
                                          keyboardType: TextInputType.text,
                                          // inputFormatters: [
                                          //   new FilteringTextInputFormatter
                                          //       .allow(RegExp("[0-9]"))
                                          // ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 11.w,
                                      ),
                                      Text(LocaleKeys.add.tr()),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          if (mounted)
                                            setState(() {
                                              if (_selectedUnit == null) {
                                                if (mounted)
                                                  setState(() {
                                                    borderUnit = kredcolor;
                                                  });
                                                return;
                                              }
                                              if (_selectedUnits
                                                  .contains(_selectedUnit)) {
                                                if (mounted)
                                                  setState(() {
                                                    borderUnit = kredcolor;
                                                  });
                                                return;
                                              }
                                              if (_unitController.text == "") {
                                                if (mounted)
                                                  setState(() {
                                                    borderpriceunit = kredcolor;
                                                  });
                                                return;
                                              }

                                              if (_selectedUnit != null &&
                                                  _unitController.text != "") {
                                                if (mounted)
                                                  setState(() {
                                                    borderUnit = kbordercolor;
                                                    borderpriceunit =
                                                        kbordercolor;
                                                  });
                                                _selectedUnits
                                                    .add(_selectedUnit!);
                                                _finalSelectedUnits.add(AddUnit(
                                                  id: _selectedUnit!.id,
                                                  price: _unitController.text
                                                          .contains(
                                                              RegExp("[0-9]"))
                                                      ? _unitController.text
                                                      : replaceArabicNumbers(
                                                          _unitController.text),
                                                ));
                                                _unitController.clear();
                                              }
                                              height = height + 20.h;
                                            });
                                        },
                                        child: Container(
                                          width: 31.w,
                                          height: 31.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                color: kprimaryColor),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: kprimaryColor,
                                            size: 25.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            height: height,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _selectedUnits.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedUnits[index].name,
                                      style: GoogleFonts.getFont('Tajawal',
                                          color: kprimaryTextColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _finalSelectedUnits[index].price !=
                                                  "0"
                                              ? '${_finalSelectedUnits[index].price}' +
                                                  " " +
                                                  LocaleKeys.rs.tr()
                                              : LocaleKeys.free.tr(),
                                          style: GoogleFonts.getFont('Tajawal',
                                              color: _finalSelectedUnits[index]
                                                          .price !=
                                                      "0"
                                                  ? ksecondaryTextColor
                                                  : kprimaryGreenColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 34.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (mounted)
                                              setState(() {
                                                _selectedUnits.removeAt(index);
                                                _finalSelectedUnits
                                                    .removeAt(index);
                                                height = height - 20.h;
                                              });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 15.sp,
                                            color: kredcolor,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 10.h,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleWidget(
                                  title: LocaleKeys.market_account_add_options
                                      .tr(),
                                  color: kprimaryColor,
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Container(
                                  height: 54.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              style: BorderStyle.solid,
                                              color: borderservice,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: DropdownButton<Service>(
                                          hint: Text(
                                            LocaleKeys.select_service.tr(),
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: ksecondaryTextColor),
                                          ),
                                          value: _selectedService,
                                          underline: Container(
                                            height: 0,
                                          ),
                                          isExpanded: true,
                                          iconSize: 15.sp,
                                          icon: Icon(
                                            FontAwesomeIcons.chevronDown,
                                          ),
                                          items:
                                              _services.map((Service service) {
                                            return DropdownMenuItem<Service>(
                                              value: service,
                                              child: new Text(
                                                service.name,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (Service? newValue) {
                                            if (mounted)
                                              setState(() {
                                                borderservice = kbordercolor;
                                                _selectedService = newValue;
                                              });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 11.w,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        width: 110.w,
                                        height: 54.h,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              style: BorderStyle.solid,
                                              color: borderpriceService,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: TextField(
                                          autofocus: false,
                                          style: GoogleFonts.getFont(
                                            'Tajawal',
                                            fontSize: 16.sp,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: LocaleKeys.price.tr(),
                                            hintStyle: TextStyle(
                                                color: ksecondaryTextColor),
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          controller: _serviceController,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.w,
                                      ),
                                      Text(LocaleKeys.add.tr()),
                                      SizedBox(width: 3.w),
                                      GestureDetector(
                                          onTap: () {
                                            if (mounted)
                                              setState(() {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (_selectedService == null) {
                                                  if (mounted)
                                                    setState(() {
                                                      borderservice = kredcolor;
                                                    });
                                                  return;
                                                }
                                                if (_selectedServices.contains(
                                                    _selectedService)) {
                                                  if (mounted)
                                                    setState(() {
                                                      borderservice = kredcolor;
                                                    });
                                                  return;
                                                }
                                                if (_serviceController.text ==
                                                    "") {
                                                  if (mounted)
                                                    setState(() {
                                                      borderpriceService =
                                                          kredcolor;
                                                    });
                                                  return;
                                                }

                                                borderpriceService =
                                                    kbordercolor;
                                                if (_selectedService != null &&
                                                    _serviceController.text !=
                                                        "") {
                                                  _selectedServices
                                                      .add(_selectedService!);
                                                  _finalSelectedServices
                                                      .add(AddService(
                                                    id: _selectedService!.id,
                                                    price: _serviceController
                                                            .text
                                                            .contains(
                                                                RegExp("[0-9]"))
                                                        ? _serviceController
                                                            .text
                                                        : replaceArabicNumbers(
                                                            _serviceController
                                                                .text),
                                                  ));
                                                  _serviceController.clear();

                                                  height2 = height2 + 30.h;
                                                }
                                              });
                                          },
                                          child: Container(
                                            width: 31.w,
                                            height: 31.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  color: kprimaryColor),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: kprimaryColor,
                                              size: 25.sp,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                AnimatedContainer(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  duration: Duration(milliseconds: 400),
                                  height: height2,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _selectedServices.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _selectedServices[index].name,
                                            style: GoogleFonts.getFont(
                                                'Tajawal',
                                                color: kprimaryTextColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                _finalSelectedServices[index]
                                                            .price !=
                                                        "0"
                                                    ? '${_finalSelectedServices[index].price}' +
                                                        " " +
                                                        LocaleKeys.rs.tr()
                                                    : LocaleKeys.free.tr(),
                                                style: GoogleFonts.getFont(
                                                    'Tajawal',
                                                    color: _finalSelectedServices[
                                                                    index]
                                                                .price !=
                                                            "0"
                                                        ? ksecondaryTextColor
                                                        : kprimaryGreenColor,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 34.w,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (mounted)
                                                    setState(() {
                                                      _selectedServices
                                                          .removeAt(index);
                                                      _finalSelectedServices
                                                          .removeAt(index);

                                                      height2 = height2 - 30.h;
                                                    });
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 15.sp,
                                                  color: kredcolor,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10.h,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!_isPageLoading)
                            GestureDetector(
                              onTap: () async {
                                if (mounted)
                                  setState(() {
                                    changed = true;
                                    borderColor = kbordercolor;
                                    borderColorGrid = kbordercolor;
                                    borderUnit = kbordercolor;
                                    borderpriceService = kbordercolor;
                                    borderUnit = kbordercolor;
                                    borderservice = kbordercolor;
                                    borderpriceunit = kbordercolor;
                                  });
                                if (_selectedProduct == null) {
                                  if (mounted)
                                    setState(() {
                                      borderColor = kredcolor;
                                    });

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      LocaleKeys.select_product.tr(),
                                    ),
                                    backgroundColor: kredcolor,
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                  return;
                                }
                                if (selectedImage == null &&
                                    Provider.of<ImgProvider>(context,
                                            listen: false)
                                        .imageFile
                                        .isEmpty) {
                                  if (mounted)
                                    setState(() {
                                      borderColorGrid = kredcolor;
                                    });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      LocaleKeys.select_images.tr(),
                                    ),
                                    backgroundColor: kredcolor,
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                  return;
                                }
                                if (_finalSelectedUnits.isEmpty) {
                                  if (mounted)
                                    setState(() {
                                      borderUnit = kredcolor;
                                    });

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      LocaleKeys.select_units.tr(),
                                    ),
                                    backgroundColor: kredcolor,
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                  return;
                                }

                                if (mounted)
                                  setState(() {
                                    _isPageLoading = true;
                                  });
                                print(Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .id);
                                await ProductsControlller.addFisherProduct(
                                  token: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user
                                      .token!,
                                  productId: _selectedProduct!.id.toString(),
                                  images: selectedImage == null
                                      ? []
                                      : [
                                          double.parse(selectedImage!.id)
                                              .toInt()
                                        ],
                                  units: _finalSelectedUnits,
                                  services: _finalSelectedServices,
                                  fileImages: Provider.of<ImgProvider>(context,
                                          listen: false)
                                      .imageFile,
                                ).then((value1) {
                                  Provider.of<ImgProvider>(context,
                                          listen: false)
                                      .clearImages();
                                  if (mounted)
                                    setState(() {
                                      _isPageLoading = false;
                                    });
                                  Provider.of<ImgProvider>(context,
                                          listen: false)
                                      .clearImages();
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    enableDrag: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return SnackabrDialog(
                                        status:
                                            value1 == 'Created' ? true : false,
                                        message: value1 == "Created"
                                            ? LocaleKeys.product_add_success
                                                .tr()
                                            : LocaleKeys.operation_field.tr(),
                                        onPopFunction: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ).then((value) {
                                    if (value1 == 'Created')
                                      Navigator.pop(context, true);
                                  });
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 23.w,
                                  vertical: 16.h,
                                ),
                                child: BottomButton(
                                  title: LocaleKeys.save.tr(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
            if (_isPageLoading)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GridImg {
  int id;
  String url;
  Function ontap;
  bool isFixed;
  GridImg({
    required this.id,
    required this.url,
    required this.ontap,
    required this.isFixed,
  });
}
