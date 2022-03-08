import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_count_model.dart';
import 'package:fishe_tender_fisher/services/order_count.dart';
import 'package:fishe_tender_fisher/services/recent_orders.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Order/components/order_item_shimmer_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/orders_item_model.dart';
import 'package:fishe_tender_fisher/views/Order/views/order_details_view.dart';
import 'package:fishe_tender_fisher/views/Order/views/order_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/wallet_view.dart';
import 'package:fishe_tender_fisher/views/Profile/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/number_input.dart';
import 'package:fishe_tender_fisher/views/offer/views/offers_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isShimmer = false;

  OrderCountModel orderCountModel = OrderCountModel(
    pending: "0",
    received: "0",
    prepared: "0",
    shipped: "0",
    accepted: "0",
    rejected: "0",
  );
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (mounted)
        await SharedPreferences.getInstance().then(
          (value0) async {
            await AuthController.getUser(value0.getString('token')!)
                .then((value) async {
              print("this is value id " + value.id!);
              if (value.id == "Unauthenticated") {
                Provider.of<UserProvider>(context, listen: false).clearUser();
                value0.clear();
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: false,
                  enableDrag: false,
                  isDismissible: false,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return SnackabrDialog(
                      duration: 3000,
                      status: true,
                      message: LocaleKeys.delete_successfull.tr(),
                      onPopFunction: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ).then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    NumberInput.routeName,
                    (Route<dynamic> route) => false,
                  );
                });
              }
              if (value0.containsKey("token"))
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).setUser(value);
            });
            if (mounted) if (value0.containsKey("token"))
              await OrderController.getOrdersList(
                Provider.of<UserProvider>(context, listen: false).user.token!,
                0,
              ).then((value) {
                if (mounted) if (value['data'].isEmpty) {
                  Provider.of<RecentOrders>(context, listen: false).clearAll();
                  return;
                }
                Provider.of<RecentOrders>(context, listen: false)
                    .replaceAll(value['data']);

                Provider.of<RecentOrders>(context, listen: false).addLast();
              });
            if (mounted) if (value0.containsKey("token"))
              await OrderController.getOrderCount(
                value0.getString('token')!,
              ).then((value) {
                if (mounted) if (Provider.of<CountProvider>(context,
                            listen: false)
                        .orderCountModel !=
                    value)
                  Provider.of<CountProvider>(context, listen: false).editdata(
                    value.pending,
                    value.received,
                    value.prepared,
                    value.shipped,
                    value.accepted,
                    value.rejected,
                  );
              });
          },
        );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentLocation =
        Provider.of<UserProvider>(context, listen: true).user.address ?? '';
    String walletalance =
        Provider.of<UserProvider>(context, listen: true).user.wallet ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.home_title.tr(),
              cangoback: false,
              rightbutton: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    MarketAccountScreen.routeName,
                  );
                },
                child: Container(
                  height: 36.h,

                  //width: 36.w,
                  margin: EdgeInsets.only(
                    bottom: 13.0.h,
                    left: 16.0.w,
                    top: 51.0.h,
                    right: 16.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys.quick_access.tr(),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontSize: context.locale.toLanguageTag() == "ar"
                              ? 16.sp
                              : 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        //overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kprimaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: CachedNetworkImage(
                            imageUrl: Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user.picUrl ??
                                "",
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              appbarheight: 100.h,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Container(
                      width: 350.w,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 3.h),
                            child: Icon(
                              Icons.location_on,
                              size: 14.sp,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                currentLocation,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      height: 80.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: kbordercolor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 24.h,
                                width: 24.w,
                                child: Icon(
                                  Icons.access_time_filled,
                                  color: kprimaryColor,
                                  size: 30.sp,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Container(
                                width: 210.w,
                                child: FittedBox(
                                  child: Text(
                                    LocaleKeys.waiting_approval.tr(),
                                    style: GoogleFonts.getFont('Cairo',
                                        fontSize:
                                            context.locale.toLanguageTag() ==
                                                    "ar"
                                                ? 18.sp
                                                : 16.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 60.w,
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                Provider.of<CountProvider>(context,
                                        listen: true)
                                    .orderCountModel
                                    .pending,
                                style: GoogleFonts.getFont(
                                  'Cairo',
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kprimaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(WalletView.routeName);
                            },
                            child: Container(
                              width: 176.w,
                              padding: context.locale.toLanguageTag() == 'en'
                                  ? EdgeInsets.only(left: 20.w)
                                  : EdgeInsets.only(right: 20.w),
                              margin: context.locale.toLanguageTag() == 'en'
                                  ? EdgeInsets.only(left: 14.w)
                                  : EdgeInsets.only(right: 14.w),
                              height: 100.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: kbordercolor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 24.h,
                                    width: 24.w,
                                    child: SizedBox(
                                      child: SvgPicture.asset(
                                        "assets/icons/Iconawesome-wallet.svg",
                                        color: kprimaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 65.h,
                                                  width: 85.w,
                                                  child: FittedBox(
                                                    child: Text(
                                                      walletalance,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.getFont(
                                                          'Cairo',
                                                          fontSize: walletalance
                                                                      .length <
                                                                  5
                                                              ? 30.sp
                                                              : walletalance
                                                                          .length >
                                                                      6
                                                                  ? 20.sp
                                                                  : 25.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              kprimaryTextColor),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 2.w),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 15.h),
                                                  child: Text(
                                                    LocaleKeys.rs.tr(),
                                                    style: GoogleFonts.getFont(
                                                        'Cairo',
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            ksecondaryTextColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                      Container(
                                        child: Text(
                                          LocaleKeys.wallet_wallet_balance.tr(),
                                          style: GoogleFonts.getFont('Cairo',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: kprimaryTextColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 176.w,
                            padding: EdgeInsets.symmetric(horizontal: 19.w),
                            margin: context.locale.toLanguageTag() == 'en'
                                ? EdgeInsets.only(right: 14.w)
                                : EdgeInsets.only(left: 14.w),
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: kprimaryGreenColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  child: Icon(
                                    Icons.check_outlined,
                                    color: kprimaryLightColor,
                                    size: 40.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.4.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 65.h,
                                      width: 85.w,
                                      child: FittedBox(
                                        child: Text(
                                          Provider.of<CountProvider>(context,
                                                  listen: true)
                                              .orderCountModel
                                              .accepted,
                                          style: GoogleFonts.getFont('Cairo',
                                              fontSize: 36.sp,
                                              fontWeight: FontWeight.w700,
                                              color: kprimaryLightColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        LocaleKeys.home_accepted_orders.tr(),
                                        style: GoogleFonts.getFont('Cairo',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: kprimaryLightColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 176.w,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            margin: context.locale.toLanguageTag() == 'en'
                                ? EdgeInsets.only(left: 14.w)
                                : EdgeInsets.only(right: 14.w),
                            height: 100.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: kbordercolor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  child: SizedBox(
                                    child: SvgPicture.asset(
                                      "assets/icons/Iconawesome-concierge-bell.svg",
                                      color: kprimaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.4.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 65.h,
                                      width: 85.w,
                                      child: FittedBox(
                                        child: Text(
                                          Provider.of<CountProvider>(context,
                                                  listen: true)
                                              .orderCountModel
                                              .prepared,
                                          style: GoogleFonts.getFont('Cairo',
                                              fontSize: 36.sp,
                                              fontWeight: FontWeight.w700,
                                              color: kprimaryTextColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        LocaleKeys.home_prepared_orders.tr(),
                                        style: GoogleFonts.getFont('Cairo',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: kprimaryTextColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 176.w,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            margin: context.locale.toLanguageTag() == 'en'
                                ? EdgeInsets.only(right: 14.w)
                                : EdgeInsets.only(left: 14.w),
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: kprimaryLightColor,
                              border: Border.all(color: kbordercolor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  child: SizedBox(
                                    child: SvgPicture.asset(
                                      "assets/icons/Iconawesome-shipping-fast.svg",
                                      color: kprimaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.4.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 65.h,
                                      width: 85.w,
                                      child: FittedBox(
                                        child: Text(
                                          Provider.of<CountProvider>(context,
                                                  listen: true)
                                              .orderCountModel
                                              .pending,
                                          style: GoogleFonts.getFont('Cairo',
                                              fontSize: 36.sp,
                                              fontWeight: FontWeight.w700,
                                              color: kprimaryTextColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        LocaleKeys.home_on_delivery.tr(),
                                        style: GoogleFonts.getFont('Cairo',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: kprimaryTextColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      height: 80.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: kredcolor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 24.h,
                                width: 24.w,
                                child: SizedBox(
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_rejected.svg",
                                    color: kprimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Container(
                                child: Text(
                                  LocaleKeys.home_rejected_orders.tr(),
                                  style: GoogleFonts.getFont(
                                    'Cairo',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: kredcolor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 65.h,
                            width: 85.w,
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                Provider.of<CountProvider>(context,
                                        listen: true)
                                    .orderCountModel
                                    .rejected,
                                style: GoogleFonts.getFont(
                                  'Cairo',
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kprimaryTextColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      alignment: context.locale.toLanguageTag() == 'en'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TitleWidget(
                        title: LocaleKeys.home_last_orders.tr(),
                        color: kprimaryColor,
                        textStyle: GoogleFonts.getFont('Tajawal',
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: !_isShimmer
                          ? RefreshIndicator(
                              onRefresh: () async {
                                Future.delayed(Duration.zero, () async {
                                  await OrderController.getOrdersList(
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user
                                              .token!,
                                          1)
                                      .then((value) {
                                    if (value["data"].isNotEmpty) if (mounted)
                                      setState(() {
                                        Provider.of<RecentOrders>(context,
                                                listen: false)
                                            .replaceAll(value["data"]);
                                        Provider.of<RecentOrders>(context,
                                                listen: false)
                                            .addLast();
                                      });
                                  });
                                });
                              },
                              child: AnimationLimiter(
                                child: Stack(
                                  children: [
                                    Provider.of<RecentOrders>(context,
                                                listen: true)
                                            .order2
                                            .isNotEmpty
                                        ? ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 14.h),
                                            itemCount:
                                                Provider.of<RecentOrders>(
                                                        context,
                                                        listen: true)
                                                    .order2
                                                    .length,
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(
                                                height: 10.h,
                                              );
                                            },
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Order2 _order =
                                                  Provider.of<RecentOrders>(
                                                          context,
                                                          listen: true)
                                                      .order2[index];
                                              if (_order.id == "")
                                                return SizedBox(
                                                  height: 100.h,
                                                );
                                              return AnimationConfiguration
                                                  .staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                    milliseconds: 600),
                                                child: SlideAnimation(
                                                  horizontalOffset: 390.0.w,
                                                  child: FadeInAnimation(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              kprimaryLightColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    kshadowcolor,
                                                                blurRadius: 5,
                                                                spreadRadius: 1,
                                                                offset: Offset(
                                                                    0.0, 3.0)),
                                                          ]),
                                                      child: OpenContainer(
                                                        closedColor:
                                                            kprimaryLightColor,
                                                        openColor:
                                                            kprimaryLightColor,
                                                        middleColor:
                                                            kprimaryLightColor,
                                                        closedElevation: 0,
                                                        transitionType:
                                                            ContainerTransitionType
                                                                .fadeThrough,
                                                        transitionDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                        closedBuilder:
                                                            (BuildContext _,
                                                                VoidCallback
                                                                    openContainer) {
                                                          return OrderItemModel(
                                                            subtotal:
                                                                _order.subtotal,
                                                            delivery:
                                                                _order.delivery,
                                                            deliveryBy: _order
                                                                .deliveryBy,
                                                            orderPrice:
                                                                _order.amount,
                                                            deliveryPrice:
                                                                _order.shipping,
                                                            date: _order.date,
                                                            orderNbr: _order.id,
                                                            location:
                                                                _order.address,
                                                            imagePath: _order
                                                                .user.picUrl,
                                                            state: _order.state,
                                                          );
                                                        },
                                                        openBuilder:
                                                            (BuildContext _,
                                                                VoidCallback
                                                                    __) {
                                                          return OrderDetailsView(
                                                            order: _order,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    //       );
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Text(LocaleKeys.no_data.tr(),
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 16.sp,
                                                    color: kprimaryTextColor,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  OrderItemShimmerModel(),
                                  OrderItemShimmerModel(),
                                  OrderItemShimmerModel(),
                                  OrderItemShimmerModel(),
                                  OrderItemShimmerModel(),
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
      bottomNavigationBar: Container(
        height: 70.h,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kprimaryColor,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 45.h,
                width: 45.w,
                child: ClipOval(
                  child: Material(
                    color: Colors.white30,
                    child: InkWell(
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      child: SvgPicture.asset(
                        "assets/icons/ic_home.svg",
                        fit: BoxFit.scaleDown,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 45.h,
                width: 45.w,
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(OfferView.routeName);
                      },
                      child: Icon(
                        Icons.local_offer_outlined,
                        color: kprimaryLightColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 45.h,
                width: 45.w,
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(OrderView.routeName);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/ic_orders.svg",
                        fit: BoxFit.scaleDown,
                        color: kprimaryLightColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 45.h,
                width: 45.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfilScreen.routeName);
                      },
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      child: SvgPicture.asset(
                        "assets/icons/ic_profile.svg",
                        fit: BoxFit.scaleDown,
                        color: kprimaryLightColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
