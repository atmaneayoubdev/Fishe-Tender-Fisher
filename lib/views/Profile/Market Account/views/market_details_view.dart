import 'dart:io';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:file_picker/file_picker.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/succes_dialog.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:fishe_tender_fisher/models/auth/user_model.dart';
import 'package:fishe_tender_fisher/models/auth/logo_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/delivery_places_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/location_bottom_sheet_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/components/logo_cover_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MarketDetailsView extends StatefulWidget {
  static final String routeName = '/market_details_view';
  final bool? fromNumberInput;

  const MarketDetailsView({Key? key, this.fromNumberInput}) : super(key: key);

  @override
  _MarketDetailsViewState createState() => _MarketDetailsViewState();
}

class _MarketDetailsViewState extends State<MarketDetailsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: '_DetailsscaffoldKey');
  loc.Location location = loc.Location();

  TextEditingController _controllerEn = TextEditingController();
  TextEditingController _controllerAr = TextEditingController();
  TextEditingController _controllerPhoneNumber = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerRegisterNumber = TextEditingController();
  TextEditingController _controllerBankName = TextEditingController();
  TextEditingController _controllerIban = TextEditingController();
  TextEditingController _controllerLocation = TextEditingController();
  TextEditingController _controllerLatitude = TextEditingController();
  TextEditingController _controllerLongitude = TextEditingController();
  TextEditingController _controllerCity = TextEditingController();

  final _formKey = GlobalKey<FormState>(debugLabel: '_DetailFormKey');
  Logo logo = Logo(id: 0, name: '', description: '', type: '', imageUrl: '');
  var from;
  var to;
  List<Map<String, num>> cities = [];
  File? pdfFile;
  bool? _canUpdate;
  String _pdfPath = "";
  bool _isLoading = true;

  var borderColorEn = kbordercolor;
  var borderColorAr = kbordercolor;
  var borderColorEmail = kbordercolor;
  var borderColorBank = kbordercolor;
  var borderColorIban = kbordercolor;
  var borderColorRegister = kbordercolor;
  var borderColorCertificate = kbordercolor;
  var borderColorLocation = kbordercolor;
  var borderColorLogo = kbordercolor;

  User user = User(
    token: '',
    id: "",
    name: '',
    email: '',
    phone: '',
    picUrl: '',
    commercialRegistrationRumber: '',
    iban: '',
    bankName: '',
    commercialRegistrationUrl: '',
    city: '',
    address: '',
    startWorkTime: '',
    endWorkTime: '',
    latitude: '',
    longitude: '',
    status: '0',
    code: '',
    deliveryPrice: '',
    isPromoted: '',
    lowestPrice: "",
    nameAr: '',
    rate: "",
  );

  @override
  void initState() {
    _canUpdate = true;
    Future.delayed(Duration.zero, () async {
      await SharedPreferences.getInstance().then((value) async {
        var token = value.getString('token');
        await AuthController.getUser(token!).then((value) {
          if (mounted)
            setState(
              () {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(value);
                user = value;

                if (mounted)
                  setState(() {
                    _isLoading = false;
                  });
              },
            );
        });
      });
      _controllerPhoneNumber.text = user.phone ?? "";
      _controllerAr.text = user.nameAr ?? '';
      _controllerEmail.text = user.email ?? '';
      _controllerEn.text = user.name ?? '';
      _controllerRegisterNumber.text = user.commercialRegistrationRumber ?? '';
      _controllerIban.text = user.iban ?? '';
      _controllerBankName.text = user.bankName ?? "";
      logo.imageUrl = user.picUrl ?? "";
      _pdfPath = user.commercialRegistrationUrl ?? "";
      _controllerLocation.text = user.address ?? "";
      _controllerLatitude.text = user.latitude ?? "";
      _controllerLongitude.text = user.longitude ?? "";
      _controllerCity.text = user.city ?? "";
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerPhoneNumber.dispose();
    _controllerAr.dispose();
    _controllerEmail.dispose();
    _controllerEn.dispose();
    _controllerRegisterNumber.dispose();
    _controllerIban.dispose();
    _controllerBankName.dispose();
    _controllerLocation.dispose();
    super.dispose();
  }

  bool alt = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: () async {
          if (widget.fromNumberInput!) {
            return false;
          } else {
            return true;
          }
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWidget(
                title: LocaleKeys.company_account.tr(),
                cangoback: widget.fromNumberInput! ? false : true,
                function: () {
                  Navigator.pop(context);
                },
              ),
              if (_isLoading)
                Expanded(
                  child: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              if (!_isLoading)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    LocaleKeys.market_account_market_details
                                        .tr(),
                                    style: GoogleFonts.getFont(
                                      'Tajawal',
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kprimaryTextColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: LocaleKeys.wallet_state.tr() +
                                              " :",
                                          style: GoogleFonts.getFont(
                                            'Tajawal',
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ksecondaryTextColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: user.status == "2"
                                              ? LocaleKeys.active.tr()
                                              : LocaleKeys.inactive.tr(),
                                          style: GoogleFonts.getFont(
                                            'Tajawal',
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: user.status == "2"
                                                ? kprimaryGreenColor
                                                : kredcolor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              child: Text(
                                LocaleKeys.market_account_details_body_text
                                    .tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ksecondaryTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 23.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${LocaleKeys.market_account_company_name.tr()} (en)',
                                      style: GoogleFonts.getFont(
                                        'Tajawal',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: kprimaryTextColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Container(
                                      width: 175.w,
                                      height: 54.h,
                                      // padding: EdgeInsets.symmetric(
                                      //   horizontal: 10.w,
                                      //   vertical: 16.h,
                                      // ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border:
                                            Border.all(color: borderColorEn),
                                      ),
                                      child: TextFormField(
                                        maxLines: 1,
                                        //expands: true,
                                        enabled: _canUpdate,
                                        textDirection: TextDirection.ltr,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 16.h,
                                          ),
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              height: double.minPositive),
                                          errorStyle: TextStyle(
                                              height: double.minPositive),
                                          counter: null,
                                          counterStyle: TextStyle(
                                              height: double.minPositive,
                                              color: Colors.transparent),
                                          counterText: null,
                                        ),
                                        controller: _controllerEn,
                                        cursorColor: kprimaryTextColor,
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 16.sp,
                                          color: kprimaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        validator: (v) {
                                          if (v!.length < 3 && v.isEmpty) {
                                            if (mounted)
                                              setState(() {
                                                borderColorEn = kredcolor;
                                              });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                v.isEmpty
                                                    ? LocaleKeys
                                                        .company_name_req
                                                        .tr()
                                                    : LocaleKeys
                                                        .wrong_campany_name
                                                        .tr(),
                                              ),
                                              backgroundColor: kredcolor,
                                              duration:
                                                  Duration(milliseconds: 800),
                                            ));
                                            // showModalBottomSheet<void>(
                                            //   context: context,
                                            //   isScrollControlled: true,
                                            //   enableDrag: true,
                                            //   backgroundColor: Colors.transparent,
                                            //   builder: (BuildContext context) {
                                            //     return SnackabrDialog(
                                            //       icon: Icons.cancel_rounded,
                                            //       message: v.isEmpty
                                            //           ? LocaleKeys
                                            //               .company_name_req
                                            //               .tr()
                                            //           : LocaleKeys
                                            //               .wrong_campany_name
                                            //               .tr(),
                                            //       onPopFunction: () {
                                            //         Navigator.of(context).pop();
                                            //       },
                                            //     );
                                            //   },
                                            // );
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${LocaleKeys.market_account_company_name.tr()} (ar)',
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: kprimaryTextColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.h,
                                      ),
                                      Container(
                                        width: 175.w,
                                        height: 54.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 16.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border:
                                              Border.all(color: borderColorAr),
                                        ),
                                        child: TextFormField(
                                          enabled: _canUpdate,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                height: double.minPositive),
                                            errorStyle: TextStyle(
                                                height: double.minPositive),
                                            counter: null,
                                            counterStyle: TextStyle(
                                                height: double.minPositive,
                                                color: Colors.transparent),
                                            counterText: null,
                                          ),
                                          controller: _controllerAr,
                                          cursorColor: kprimaryTextColor,
                                          style: GoogleFonts.getFont(
                                            'Tajawal',
                                            fontSize: 16.sp,
                                            color: kprimaryTextColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          validator: (v) {
                                            if (v!.length < 3 && v.isEmpty) {
                                              if (mounted)
                                                setState(() {
                                                  borderColorAr = kredcolor;
                                                });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  v.isEmpty
                                                      ? LocaleKeys
                                                          .company_name_req
                                                          .tr()
                                                      : LocaleKeys
                                                          .wrong_campany_name
                                                          .tr(),
                                                ),
                                                backgroundColor: kredcolor,
                                                duration:
                                                    Duration(milliseconds: 800),
                                              ));
                                              // showModalBottomSheet<void>(
                                              //   context: context,
                                              //   isScrollControlled: true,
                                              //   enableDrag: true,
                                              //   backgroundColor:
                                              //       Colors.transparent,
                                              //   builder: (BuildContext context) {
                                              //     return SnackabrDialog(
                                              //       icon: Icons.cancel_rounded,
                                              //       message: v.isEmpty
                                              //           ? LocaleKeys
                                              //               .company_name_req
                                              //               .tr()
                                              //           : LocaleKeys
                                              //               .wrong_campany_name
                                              //               .tr(),
                                              //       onPopFunction: () {
                                              //         Navigator.of(context).pop();
                                              //       },
                                              //     );
                                              //   },
                                              // );
                                              return '';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              child: Text(
                                LocaleKeys.market_account_phone_number.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 54.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: kbordercolor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    user.phone!,
                                    textDirection: TextDirection.ltr,
                                    style: GoogleFonts.getFont(
                                      'Tajawal',
                                      fontSize: 16.sp,
                                      color: kprimaryTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.5.h,
                            ),
                            Container(
                              child: Text(
                                LocaleKeys.market_account_email.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 54.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: borderColorEmail),
                              ),
                              child: TextFormField(
                                enabled: _canUpdate,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 16.h,
                                  ),
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(height: double.minPositive),
                                  errorStyle:
                                      TextStyle(height: double.minPositive),
                                  counter: null,
                                  counterStyle: TextStyle(
                                      height: double.minPositive,
                                      color: Colors.transparent),
                                  counterText: null,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: _controllerEmail,
                                cursorColor: kprimaryTextColor,
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 16.sp,
                                  color: kprimaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                validator: (v) {
                                  if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                  ).hasMatch(v!)) {
                                    if (mounted)
                                      setState(() {
                                        borderColorEmail = kredcolor;
                                      });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        v.isEmpty
                                            ? LocaleKeys.email_req.tr()
                                            : LocaleKeys.wrong_email.tr(),
                                      ),
                                      backgroundColor: kredcolor,
                                      duration: Duration(milliseconds: 800),
                                    ));
                                    // showModalBottomSheet<void>(
                                    //   context: context,
                                    //   isScrollControlled: true,
                                    //   enableDrag: true,
                                    //   backgroundColor: Colors.transparent,
                                    //   builder: (BuildContext context) {
                                    //     return SnackabrDialog(
                                    //       icon: Icons.cancel_rounded,
                                    //       message: v.isEmpty
                                    //           ? LocaleKeys.email_req.tr()
                                    //           : LocaleKeys.wrong_email.tr(),
                                    //       onPopFunction: () {
                                    //         Navigator.of(context).pop();
                                    //       },
                                    //     );
                                    //   },
                                    // );
                                    return '';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.5.h,
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.bank_name.tr(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " (${LocaleKeys.optional.tr()})",
                                        style: TextStyle(
                                          color: kredcolor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                              ),
                              //  Text(
                              //   LocaleKeys.bank_name.tr() +
                              //       "(${LocaleKeys.optional.tr()})",
                              //   style: GoogleFonts.getFont(
                              //     'Tajawal',
                              //     fontSize: 18.sp,
                              //     fontWeight: FontWeight.w600,
                              //     color: kprimaryTextColor,
                              //   ),
                              // ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 54.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: borderColorBank),
                              ),
                              child: TextFormField(
                                enabled: _canUpdate,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 16.h,
                                  ),
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(height: double.minPositive),
                                  errorStyle:
                                      TextStyle(height: double.minPositive),
                                  counter: null,
                                  counterStyle: TextStyle(
                                      height: double.minPositive,
                                      color: Colors.transparent),
                                  counterText: null,
                                ),
                                keyboardType: TextInputType.text,
                                controller: _controllerBankName,
                                cursorColor: kprimaryTextColor,
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 16.sp,
                                  color: kprimaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                validator: (v) {
                                  if (v!.isNotEmpty) {
                                    if (v.length < 4) {
                                      if (mounted)
                                        setState(() {
                                          borderColorBank = kredcolor;
                                        });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            LocaleKeys.wrong_bankname.tr()),
                                        backgroundColor: kredcolor,
                                        duration: Duration(milliseconds: 800),
                                      ));

                                      return '';
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.5.h,
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.iban.tr(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " (${LocaleKeys.optional.tr()})",
                                        style: TextStyle(
                                          color: kredcolor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]),
                              ),
                              //  Text(
                              //   LocaleKeys.iban.tr() +
                              //       "(${LocaleKeys.optional.tr()})",
                              //   style: GoogleFonts.getFont(
                              //     'Tajawal',
                              //     fontSize: 18.sp,
                              //     fontWeight: FontWeight.w600,
                              //     color: kprimaryTextColor,
                              //   ),
                              // ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 54.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: borderColorIban),
                              ),
                              child: TextFormField(
                                // textAlign: context.locale.toLanguageTag() == "en"
                                //     ? TextAlign.start
                                //     : TextAlign.end,
                                textDirection: TextDirection.ltr,
                                enabled: _canUpdate,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 16.h,
                                  ),
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(height: double.minPositive),
                                  errorStyle:
                                      TextStyle(height: double.minPositive),
                                  counter: null,
                                  counterStyle: TextStyle(
                                      height: double.minPositive,
                                      color: Colors.transparent),
                                  counterText: null,
                                ),
                                keyboardType: Platform.isIOS
                                    ? TextInputType.text
                                    : TextInputType.number,
                                controller: _controllerIban,
                                cursorColor: kprimaryTextColor,
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 16.sp,
                                  color: kprimaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                validator: (v) {
                                  if (v!.isNotEmpty) {
                                    if (v.length < 4) {
                                      if (mounted)
                                        setState(() {
                                          borderColorIban = kredcolor;
                                        });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text(LocaleKeys.wrong_iban.tr()),
                                        backgroundColor: kredcolor,
                                        duration: Duration(milliseconds: 800),
                                      ));

                                      return '';
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.5.h,
                            ),
                            Container(
                              child: Text(
                                LocaleKeys.market_account_register_number.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 54.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: borderColorRegister),
                              ),
                              child: TextFormField(
                                textDirection: TextDirection.ltr,
                                enabled: _canUpdate,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 16.h,
                                  ),
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(height: double.minPositive),
                                  errorStyle:
                                      TextStyle(height: double.minPositive),
                                  counter: null,
                                  counterStyle: TextStyle(
                                      height: double.minPositive,
                                      color: Colors.transparent),
                                  counterText: null,
                                ),
                                keyboardType: TextInputType.text,
                                controller: _controllerRegisterNumber,
                                cursorColor: kprimaryTextColor,
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 16.sp,
                                  color: kprimaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    if (mounted)
                                      setState(() {
                                        borderColorRegister = kredcolor;
                                      });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        LocaleKeys.regestration_number_req.tr(),
                                      ),
                                      backgroundColor: kredcolor,
                                      duration: Duration(milliseconds: 800),
                                    ));

                                    return '';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    LocaleKeys
                                        .market_account_register_certificate
                                        .tr(),
                                    style: GoogleFonts.getFont(
                                      'Tajawal',
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: kprimaryTextColor,
                                    ),
                                  ),
                                ),
                                if (!widget.fromNumberInput!)
                                  GestureDetector(
                                    onTap: () {
                                      _pdfPath != ""
                                          ? UrlLauncher.launch(_pdfPath)
                                          : showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: false,
                                              enableDrag: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (BuildContext context) {
                                                return SnackabrDialog(
                                                  status: false,
                                                  message:
                                                      LocaleKeys.no_file.tr(),
                                                  onPopFunction: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            );
                                    },
                                    child: Container(
                                      child: Text(
                                        LocaleKeys.visualize_ceritificate.tr(),
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 14.sp,
                                          color: kprimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_canUpdate!) {
                                  await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  ).then((value) {
                                    if (value != null) {
                                      if (mounted)
                                        setState(() {
                                          pdfFile =
                                              File(value.files.single.path!);
                                          _pdfPath = value.files.single.path!;
                                          print('selecter pdf path' +
                                              pdfFile!.path);
                                        });
                                    } else {}
                                  });
                                }
                              },
                              child: _pdfPath == ""
                                  ? Container(
                                      width: double.infinity,
                                      height: 97.h,
                                      decoration: BoxDecoration(
                                        color: klightbleucolor,
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border: Border.all(
                                            color: borderColorCertificate),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icons/empty_file_icon.png',
                                          scale: 1.5,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 355.w,
                                      height: 97.h,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              border: Border.all(
                                                color: kbordercolor,
                                              ),
                                            ),
                                            child: Container(
                                              child: PDFView(
                                                fitPolicy: FitPolicy.BOTH,
                                                pageFling: false,
                                                gestureRecognizers: null,
                                                fitEachPage: false,
                                                filePath: _pdfPath,
                                                enableSwipe: false,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              border: Border.all(
                                                  color: kbordercolor),
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.6),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/icons/edit_logo.png',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 12.5.h,
                            ),
                            Container(
                              child: Text(
                                LocaleKeys.market_account_location.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 54.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                //vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: borderColorLocation),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  if (_canUpdate!) {
                                    await location.getLocation().then((value) {
                                      showModalBottomSheet<Map>(
                                        context: context,
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        isDismissible: false,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return LocationModel(
                                            initpos: LatLng(value.latitude!,
                                                value.longitude!),
                                          );
                                        },
                                      ).then((value) {
                                        if (value != null) {
                                          // _controllerLocation.clear();
                                          // _controllerLatitude.clear();
                                          // _controllerLongitude.clear();
                                          // _controllerCity.clear();
                                          setState(() {
                                            _controllerCity.text =
                                                value['city'];
                                            _controllerLatitude.text =
                                                value['lat'];
                                            _controllerLongitude.text =
                                                value['lon'];
                                            _controllerLocation.text =
                                                value['address'];
                                            print(value);
                                          });
                                        }
                                      });
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 310.w,
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 16.h,
                                          ),
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            height: double.minPositive,
                                          ),
                                          errorStyle: TextStyle(
                                            height: double.minPositive,
                                          ),
                                          counter: null,
                                          counterStyle: TextStyle(
                                            height: double.minPositive,
                                            color: Colors.transparent,
                                          ),
                                          counterText: null,
                                        ),
                                        keyboardType: TextInputType.text,
                                        controller: _controllerLocation,
                                        cursorColor: kprimaryTextColor,
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 16.sp,
                                          color: kprimaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: kprimaryTextColor,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.5.h,
                            ),
                            Container(
                              child: Text(
                                LocaleKeys.market_account_logo_cover.tr(),
                                style: GoogleFonts.getFont(
                                  'Tajawal',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                                width: 80.w,
                                height: 80.h,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border: Border.all(color: kbordercolor),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icons/empty_file_icon.png',
                                            scale: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_canUpdate!) {
                                          showModalBottomSheet<Logo>(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: true,
                                            builder: (BuildContext context) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: LogoAndCoverModel(
                                                    pName: "",
                                                    isImage: false,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then((value0) async {
                                            if (value0 == null) {
                                              await AuthController.getUser(
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .token!)
                                                  .then((value) {
                                                if (mounted)
                                                  setState(
                                                    () {
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .setUser(value);
                                                      user = value;
                                                    },
                                                  );
                                              });
                                            } else {
                                              await AuthController
                                                  .updateUserLogo(
                                                token:
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .token!,
                                                isAdding: false,
                                                logo: value0,
                                              ).then((value) async {
                                                await AuthController.getUser(
                                                        Provider.of<UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .user
                                                            .token!)
                                                    .then((value) {
                                                  if (mounted)
                                                    setState(
                                                      () {
                                                        Provider.of<UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .setUser(value);
                                                        user = value;
                                                      },
                                                    );
                                                });
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: user.picUrl == ""
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                    color: user.picUrl == ''
                                                        ? kbordercolor
                                                        : Colors.transparent),
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.6),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/icons/edit_logo.png'),
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: user.picUrl!,
                                              fit: BoxFit.fill,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 21.h,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  if (mounted)
                                    setState(() {
                                      borderColorEn = kbordercolor;
                                      borderColorAr = kbordercolor;
                                      borderColorEmail = kbordercolor;
                                      borderColorBank = kbordercolor;
                                      borderColorIban = kbordercolor;
                                      borderColorRegister = kbordercolor;
                                      borderColorCertificate = kbordercolor;
                                      borderColorLocation = kbordercolor;
                                      borderColorLogo = kbordercolor;
                                    });
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate() &&
                                      _controllerLocation.text.isNotEmpty &&
                                      _controllerLocation.text != "") {
                                    if (pdfFile != null ||
                                        user.commercialRegistrationUrl != "") {
                                      FocusScope.of(context).unfocus();
                                      showModalBottomSheet<
                                          Map<dynamic, dynamic>>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: DeliveryPlacesModel(
                                                startWorkTime:
                                                    user.startWorkTime!,
                                                endWorkTie: user.endWorkTime!,
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) {
                                        if (value != null) {
                                          if (mounted)
                                            setState(() {
                                              cities = value['cities'];
                                              from = value['from'];
                                              to = value['to'];
                                              alt = value['state'];
                                            });
                                        }
                                      }).then((value) async {
                                        if (alt != true) {
                                          print(
                                              'cancling ....................');
                                          return;
                                        }
                                        if (mounted)
                                          setState(() {
                                            _isLoading = true;
                                          });

                                        await SharedPreferences.getInstance()
                                            .then((value) async {
                                          if (pdfFile != null)
                                            await AuthController
                                                .updateCommercialRegister(
                                              value.getString('token')!,
                                              pdfFile,
                                            );

                                          //if()
                                          // await UserController.updateFisherCities(
                                          //   'token',
                                          //   cities,
                                          // ).then((value) {
                                          //   print(value);
                                          // });

                                          String update =
                                              await AuthController.updateUser(
                                            token: value.getString('token')!,
                                            name: _controllerEn.text,
                                            nameAr: _controllerAr.text,
                                            email: _controllerEmail.text,
                                            phoneNumber:
                                                _controllerPhoneNumber.text,
                                            iban: _controllerIban.text,
                                            regestrNumber:
                                                _controllerRegisterNumber.text,
                                            adresse: _controllerLocation.text,
                                            city: _controllerCity.text,
                                            latitude: _controllerLatitude.text,
                                            longitude:
                                                _controllerLongitude.text,
                                            endWorkTime: to,
                                            startWorkTime: from,
                                            bankName: _controllerBankName.text,
                                          );
                                          if (update == 'success') {
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user
                                                    .bankName =
                                                _controllerBankName.text;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .name = _controllerEn.text;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .nameAr = _controllerAr.text;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .email = _controllerEmail.text;
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user
                                                    .phone =
                                                _controllerPhoneNumber.text;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .iban = _controllerIban.text;
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user
                                                    .commercialRegistrationRumber =
                                                _controllerRegisterNumber.text;
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user
                                                    .address =
                                                _controllerLocation.text;
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user
                                                    .latitude =
                                                _controllerLatitude.text;
                                            Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user
                                                    .longitude =
                                                _controllerLongitude.text;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .city = _controllerCity.text;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .startWorkTime = from;
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user
                                                .startWorkTime = to;
                                            if (widget.fromNumberInput ==
                                                true) {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      HomeScreen.routeName,
                                                      (Route<dynamic> route) =>
                                                          false);
                                            } else {
                                              showModal(
                                                context: context,
                                                configuration:
                                                    FadeScaleTransitionConfiguration(
                                                  transitionDuration: Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  reverseTransitionDuration:
                                                      Duration(
                                                    milliseconds: 400,
                                                  ),
                                                ),
                                                builder:
                                                    (BuildContext context) {
                                                  return SuccesDialog(
                                                    title: LocaleKeys
                                                        .account_updated_seccess
                                                        .tr(),
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            showModalBottomSheet<
                                                Map<dynamic, dynamic>>(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                    child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: SnackabrDialog(
                                                    status: false,
                                                    message: LocaleKeys
                                                        .operation_field,
                                                    onPopFunction: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ));
                                              },
                                            );
                                          }
                                        });
                                        if (mounted)
                                          setState(() {
                                            _isLoading = false;
                                          });
                                      });
                                    } else {
                                      if (mounted)
                                        setState(() {
                                          borderColorCertificate = kredcolor;
                                        });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          LocaleKeys.regester_certificate_req
                                              .tr(),
                                        ),
                                        backgroundColor: kredcolor,
                                        duration: Duration(milliseconds: 800),
                                      ));
                                      // showModalBottomSheet<void>(
                                      //   context: context,
                                      //   isScrollControlled: false,
                                      //   backgroundColor: Colors.transparent,
                                      //   builder: (BuildContext context) {
                                      //     return SnackabrDialog(
                                      //         icon: Icons.cancel_rounded,
                                      //         message: LocaleKeys
                                      //             .regester_certificate_req
                                      //             .tr(),
                                      //         onPopFunction: () {
                                      //           Navigator.pop(context);
                                      //         });
                                      //   },
                                      // );
                                    }
                                  } else {
                                    if (_controllerLocation.text.isEmpty ||
                                        _controllerLocation.text == "") {
                                      if (mounted)
                                        setState(() {
                                          borderColorLocation = kredcolor;
                                        });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          LocaleKeys.select_location_please
                                              .tr(),
                                        ),
                                        backgroundColor: kredcolor,
                                        duration: Duration(milliseconds: 800),
                                      ));

                                      // showModalBottomSheet<void>(
                                      //   context: context,
                                      //   isScrollControlled: false,
                                      //   enableDrag: false,
                                      //   backgroundColor: Colors.transparent,
                                      //   builder: (BuildContext context) {
                                      //     return SnackabrDialog(
                                      //         icon: Icons.cancel_rounded,
                                      //         message: LocaleKeys
                                      //             .select_location_please
                                      //             .tr(),
                                      //         onPopFunction: () {
                                      //           Navigator.pop(context);
                                      //         });
                                      //   },
                                      // );
                                    }
                                  }
                                },
                                child: BottomButton(
                                  title: LocaleKeys.cont.tr(),
                                )),
                            SizedBox(
                              height: 21.h,
                            ),
                          ],
                        ),
                      ),
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
