import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_user_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:fishe_tender_fisher/views/Order/components/order_item_shimmer_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/orders_item_model.dart';
import 'package:fishe_tender_fisher/views/Profile/profile_screen.dart';
import 'package:animations/animations.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/number_input.dart';
import 'package:fishe_tender_fisher/views/offer/views/offers_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:easy_localization/easy_localization.dart';

import 'order_details_view.dart';

class OrderView extends StatefulWidget {
  static final String routeName = '/order_view';

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  ScrollController _scrollController = ScrollController();
  List<Order2> order2 = [];
  var next;
  bool _isLoading = false;
  int pageNumber = 1;
  bool _isShimmer = true;

  @override
  void initState() {
    super.initState();
    if (mounted)
      setState(() {
        _isShimmer = true;
      });
    Future.delayed(Duration.zero, () async {
      await OrderController.getOrdersList(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        pageNumber,
      ).then((value) async {
        if (value["data"] == "Unauthenticated") {
          await SharedPreferences.getInstance().then((value) {
            value.clear();
          });
          Provider.of<UserProvider>(context, listen: false).clearUser();
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
        if (mounted)
          setState(() {
            _isShimmer = false;
            order2 = value["data"];
            next = value["next"];
            if (value["data"].isNotEmpty)
              order2.add(
                Order2(
                    pendingFisherCancelRequest: "",
                    pendingUserCancelRequest: "",
                    subtotal: "",
                    latitude: "",
                    longitude: "",
                    address: "",
                    id: "",
                    amount: "",
                    tax: "",
                    date: "",
                    shipping: "",
                    state: "",
                    payementMethod: "",
                    user: OrderUser(
                        id: -1,
                        name: "",
                        email: "",
                        phone: "",
                        ordersCount: "0",
                        orderTotal: "0",
                        picUrl: "",
                        locations: []),
                    delivery: "",
                    deliveryBy: ""),
              );
          });
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        if (next != null) {
          Future.delayed(Duration.zero, () async {
            if (mounted)
              setState(() {
                _isLoading = true;
              });
            await OrderController.getOrdersList(
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        .token!,
                    ++pageNumber)
                .then((value) {
              if (mounted)
                setState(() {
                  order2.removeLast();
                  order2.addAll(value["data"]);
                  order2.add(Order2(
                      pendingFisherCancelRequest: "",
                      pendingUserCancelRequest: "",
                      subtotal: "",
                      latitude: "",
                      longitude: "",
                      id: "",
                      address: "",
                      amount: "",
                      tax: "",
                      date: "",
                      shipping: "",
                      state: "",
                      payementMethod: "",
                      user: OrderUser(
                          id: -1,
                          name: "",
                          email: "",
                          phone: "",
                          ordersCount: "0",
                          orderTotal: "0",
                          picUrl: "",
                          locations: []),
                      delivery: "",
                      deliveryBy: ""));
                  next = value["next"];
                  print(next);
                  _isLoading = false;
                });
            });
          });
        }
      }
    });
  }

  Future<void> orderRefresh() async {
    if (mounted)
      setState(() {
        pageNumber = 1;
      });

    if (mounted)
      setState(() {
        _isShimmer = true;
        order2.clear();
      });
    await OrderController.getOrdersList(
      Provider.of<UserProvider>(context, listen: false).user.token!,
      pageNumber,
    ).then((value) {
      if (mounted)
        setState(() {
          order2 = value["data"];
          order2.add(
            Order2(
                pendingFisherCancelRequest: "",
                pendingUserCancelRequest: "",
                subtotal: "",
                latitude: "",
                longitude: "",
                id: "",
                address: "",
                amount: "",
                tax: "",
                date: "",
                shipping: "",
                state: "",
                payementMethod: "",
                user: OrderUser(
                  id: -1,
                  name: "",
                  email: "",
                  phone: "",
                  ordersCount: "0",
                  orderTotal: "0",
                  picUrl: "",
                  locations: [],
                ),
                delivery: "",
                deliveryBy: ""),
          );
          next = value["next"];
          print(next);
          _isShimmer = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.order_orders.tr(),
              cangoback: false,
            ),
            Expanded(
              child: !_isShimmer
                  ? RefreshIndicator(
                      onRefresh: () async {
                        orderRefresh();
                      },
                      child: AnimationLimiter(
                        child: Stack(
                          children: [
                            order2.isNotEmpty
                                ? ListView.separated(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: _scrollController,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 14.h),
                                    itemCount: order2.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 7.h,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Order2 _order = order2[index];
                                      if (_order.id == "")
                                        return SizedBox(height: 100.h);
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 600),
                                        child: SlideAnimation(
                                          horizontalOffset: 390.0.w,
                                          child: FadeInAnimation(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: kprimaryLightColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: kshadowcolor,
                                                        blurRadius: 5,
                                                        spreadRadius: 1,
                                                        offset:
                                                            Offset(0.0, 3.0)),
                                                  ]),
                                              child: _order.pendingFisherCancelRequest ==
                                                          "1" ||
                                                      _order.pendingUserCancelRequest ==
                                                          "1"
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet<
                                                            void>(
                                                          context: context,
                                                          isScrollControlled:
                                                              false,
                                                          enableDrag: false,
                                                          isDismissible: false,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          builder: (BuildContext
                                                              context) {
                                                            return SnackabrDialog(
                                                              duration: 1500,
                                                              status: false,
                                                              message: LocaleKeys
                                                                  .under_review
                                                                  .tr(),
                                                              onPopFunction:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: OrderItemModel(
                                                        subtotal:
                                                            _order.subtotal,
                                                        delivery:
                                                            _order.delivery,
                                                        deliveryBy:
                                                            _order.deliveryBy,
                                                        orderPrice:
                                                            _order.amount,
                                                        deliveryPrice:
                                                            _order.shipping,
                                                        date: _order.date,
                                                        orderNbr: _order.id,
                                                        location:
                                                            _order.address,
                                                        imagePath:
                                                            _order.user.picUrl,
                                                        state: _order.state,
                                                      ),
                                                    )
                                                  : OpenContainer(
                                                      onClosed:
                                                          (changed) async {
                                                        if (changed == true)
                                                          orderRefresh();
                                                      },
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
                                                          deliveryBy:
                                                              _order.deliveryBy,
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
                                                              VoidCallback __) {
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
                                            fontWeight: FontWeight.normal)),
                                  ),
                            if (_isLoading)
                              Positioned(
                                bottom: 100.h,
                                child: Container(
                                  width: 390.w,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          OrderItemShimmerModel(),
                          OrderItemShimmerModel(),
                          OrderItemShimmerModel(),
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
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .popAndPushNamed(HomeScreen.routeName);
                      },
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      child: SvgPicture.asset(
                        "assets/icons/ic_home.svg",
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
                    color: Colors.white30,
                    child: InkWell(
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      child: SvgPicture.asset(
                        "assets/icons/ic_orders.svg",
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfilScreen.routeName);
                      },
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
