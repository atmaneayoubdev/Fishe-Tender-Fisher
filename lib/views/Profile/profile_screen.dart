import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_view.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/views/my_tickets_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/wallet_view.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/helpandsupport_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/views/invoice_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/settings/settings_screen.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);
  static final String routeName = '/third_screen';

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isLoading = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: 'v...',
    buildNumber: '',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted)
      setState(() {
        _packageInfo = info;
      });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              title: LocaleKeys.profile_title.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: !_isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: 26.3.h,
                                left: 23.w,
                                bottom: 16.7.h,
                                right: 23.w),
                            child: TitleWidget(
                                title: LocaleKeys.profile_account_settings.tr(),
                                color: kprimaryGreenColor)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MarketAccountScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.company_account.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(InvoiceScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.profile_invoices.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context).pushNamed(NotificationView.routeName);
                        //   },
                        //   child: Container(
                        //     margin:
                        //         EdgeInsets.only(left: 23.w, bottom: 22.7.h, right: 23.w),
                        //     child: Text(
                        //       LocaleKeys.profile_notifications.tr(),
                        //       style: GoogleFonts.getFont('Tajawal',
                        //           fontSize: 17.sp, fontWeight: FontWeight.w600),
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MyTicketsScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.profile_my_tickets.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(WalletView.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.profile_wallet.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Settingscreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.profile_settings.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(HelpAndSupportScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.profile_help_and_support.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            if (mounted)
                              setState(() {
                                _isLoading = true;
                              });
                            Future.delayed(Duration.zero, () async {
                              await SharedPreferences.getInstance()
                                  .then((value) async {
                                if (value.getString('token') != null) {
                                  var result = await AuthController.logOut(
                                      value.getString('token')!);
                                  if (result == 'success') {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .clearUser();
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return SnackabrDialog(
                                          status: true,
                                          message:
                                              LocaleKeys.operation_success.tr(),
                                          onPopFunction: () {
                                            //Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );

                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      NumberInput.routeName,
                                      (Route<dynamic> route) => false,
                                    );

                                    if (mounted)
                                      setState(() {
                                        _isLoading = false;
                                      });
                                  } else {
                                    if (mounted)
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return SnackabrDialog(
                                          status: false,
                                          message:
                                              LocaleKeys.operation_field.tr(),
                                          onPopFunction: () {
                                            //Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      NumberInput.routeName,
                                      (Route<dynamic> route) => false);
                                }
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 23.w, bottom: 22.7.h, right: 23.w),
                            child: Text(
                              LocaleKeys.profile_logout.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    if (await canLaunch(
                                        'https://www.snapchat.com/add/marshads')) {
                                      await launch(
                                        "https://www.snapchat.com/add/marshads",
                                      );
                                    } else {
                                      throw 'Could not launch ';
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/snapRounded.svg',
                                    height: 30.sp,
                                    width: 30.sp,
                                  )),
                              SizedBox(
                                width: 6.w,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (await canLaunch(
                                        'https://twitter.com/fishtendersa')) {
                                      await launch(
                                        "https://twitter.com/fishtendersa",
                                      );
                                    } else {
                                      throw 'Could not launch ';
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/tweetcircle.svg',
                                    height: 30.sp,
                                    width: 30.sp,
                                  )),
                              SizedBox(
                                width: 6.w,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (await canLaunch(
                                        'https://www.youtube.com/channel/UCfgA5zqP1PcpP2RWxThgFfA')) {
                                      await launch(
                                        "https://www.youtube.com/channel/UCfgA5zqP1PcpP2RWxThgFfA",
                                      );
                                    } else {
                                      throw 'Could not launch ';
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/youcircle.svg',
                                    height: 30.sp,
                                    width: 30.sp,
                                  )),
                              SizedBox(
                                width: 6.w,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (await canLaunch(
                                        'https://www.instagram.com/fishtender/')) {
                                      await launch(
                                        "https://www.instagram.com/fishtender/",
                                      );
                                    } else {
                                      throw 'Could not launch ';
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/instacircle.svg',
                                    height: 30.sp,
                                    width: 30.sp,
                                  )),
                              SizedBox(
                                width: 6.w,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (await canLaunch(
                                        'https://www.facebook.com/profile.php?id=100065703304530')) {
                                      await launch(
                                        "https://www.facebook.com/profile.php?id=100065703304530",
                                      );
                                    } else {
                                      throw 'Could not launch ';
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/face.svg',
                                    height: 30.sp,
                                    width: 30.sp,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'v' + _packageInfo.version,
                                style: GoogleFonts.tajawal(
                                  fontSize: 16.sp,
                                  color: ksecondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 18.5, right: 23.w),
                          height: 0.0.h,
                          width: 353.26.w,
                          child: Divider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                //alignment: Alignment.bottomLeft,
                                height: 49.47.h,
                                // width: 366.w,
                                margin: EdgeInsets.only(
                                    left: 23.w, top: 20.3.h, right: 23.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleKeys.fisheTender.tr(),
                                      style: GoogleFonts.getFont('Tajawal',
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryGreenColor),
                                    ),
                                    Text(
                                      LocaleKeys.hapy_ordering.tr(),
                                      style: GoogleFonts.getFont('Tajawal',
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
