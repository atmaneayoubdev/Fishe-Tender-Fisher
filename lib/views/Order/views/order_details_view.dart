import 'dart:async';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/fishe_details.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Order/components/cancel_order_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/delivery_choice.dart';
import 'package:fishe_tender_fisher/views/Order/components/order_item_shimmer_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/order_products_item_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/orders_item_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/profile_order_item_shimmer.dart';
import 'package:fishe_tender_fisher/views/Order/components/received_order.dart';
import 'package:fishe_tender_fisher/views/Order/views/order_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class OrderDetailsView extends StatefulWidget {
  static final String routeName = '/orderDetails_view';
  final Order2 order;

  const OrderDetailsView({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsViewState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  OrderGetDetail _orderGetDetails = OrderGetDetail(
    id: "",
    amount: '',
    tax: '',
    date: '',
    shipping: '',
    state: "",
    payementMethod: '',
    couponValue: "",
    subTotal: "",
    address: "",
    delivery: "",
    deliveryBy: "",
    note: "",
    rate: "",
    secondaryName: "",
    secondaryPhone: "",
    orderDetails: [],
  );
  var isLoading = false;
  var isChosingDelivery = false;
  bool changed = false;

  Future<void> refreshOrder() async {
    await OrderController.getOrderDetails(
      Provider.of<UserProvider>(context, listen: false).user.token!,
      widget.order.id,
    ).then((value) {
      if (mounted)
        setState(() {
          _orderGetDetails = value;
          isLoading = false;
        });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      refreshOrder().then((value) {
        if (_orderGetDetails.deliveryBy == "" ||
            _orderGetDetails.deliveryBy == "null") if (_orderGetDetails.state ==
                "2" &&
            _orderGetDetails.delivery == "1") {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return DeliveyChoice(
                  order: _orderGetDetails,
                  deliveryPrice: _orderGetDetails.shipping,
                );
              }).then((value) {
            setState(() {
              changed = true;
            });
            refreshOrder();
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, changed);
          return false;
        },
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  AppBarWidget(
                    title: LocaleKeys.order_order_details.tr(),
                    cangoback: true,
                    function: () {
                      Navigator.pop(context, changed);
                    },
                    rightbutton: Container(
                      margin: EdgeInsets.only(
                        bottom: 13.0.h,
                        left: 16.0.w,
                        top: 70.0.h,
                        right: 16.w,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderProfileView(
                                      picUrl: widget.order.user.picUrl,
                                      email: widget.order.user.email,
                                      name: widget.order.user.name,
                                      phone: widget.order.user.phone,
                                      totalPrice: widget.order.user.orderTotal
                                          .toString(),
                                      totalorders: widget.order.user.ordersCount
                                          .toString(),
                                      order: widget.order,
                                    )),
                          );
                        },
                        child: Row(
                          children: [
                            Text(LocaleKeys.client_details.tr(),
                                style: GoogleFonts.tajawal(
                                    fontSize: 14.sp,
                                    color: kprimaryTextColor,
                                    height: 2)),
                            SizedBox(
                              width: 5.w,
                            ),
                            Container(
                              height: 36.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kprimaryColor)),
                              child: ClipOval(
                                child: Hero(
                                  tag: "img" + widget.order.user.picUrl,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.order.user.picUrl,
                                    fit: BoxFit.contain,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _orderGetDetails.orderDetails.isNotEmpty
                              ? OrderItemModel(
                                  subtotal: _orderGetDetails.subTotal,
                                  delivery: _orderGetDetails.delivery,
                                  deliveryBy: _orderGetDetails.deliveryBy,
                                  orderPrice: _orderGetDetails.amount,
                                  deliveryPrice: _orderGetDetails.shipping,
                                  date: _orderGetDetails.date,
                                  orderNbr: _orderGetDetails.id,
                                  location: _orderGetDetails.address,
                                  imagePath: _orderGetDetails
                                      .orderDetails.first.imageUrl,
                                  state: _orderGetDetails.state,
                                )
                              : ProfileOrderItemShimmer(),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.products.tr(),
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kprimaryTextColor,
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     if (int.parse(_orderGetDetails.state) >= 4) {
                                //       return;
                                //     } else {
                                //       showModalBottomSheet<void>(
                                //         context: context,
                                //         isScrollControlled: true,
                                //         backgroundColor: Colors.transparent,
                                //         builder: (BuildContext context) {
                                //           return OrderStatusModel(
                                //             order: _orderGetDetails,
                                //           );
                                //         },
                                //       ).then((value) async {
                                //         await OrderController.getOrderDetails(
                                //           Provider.of<UserProvider>(context,
                                //                   listen: false)
                                //               .user
                                //               .token!,
                                //           widget.order.id,
                                //         ).then((value) {
                                //           if (mounted)
                                //             if(mounted) setState(() {
                                //               _orderGetDetails = value;
                                //             });
                                //         });
                                //       });
                                //     }
                                //   },
                                //   child: Container(
                                //     alignment: Alignment.center,
                                //     width: 130.28.w,
                                //     height: 31.h,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(5.r),
                                //         border: Border.all(
                                //           color: kbordercolor,
                                //         )),
                                //     child: Text(
                                //       LocaleKeys.order_change.tr(),
                                //       style: GoogleFonts.getFont(
                                //         'Tajawal',
                                //         fontSize: 12.sp,
                                //         fontWeight: FontWeight.w600,
                                //         color: kprimaryTextColor,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {},
                              child: _orderGetDetails.orderDetails.isNotEmpty
                                  ? ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          _orderGetDetails.orderDetails.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Divider();
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          child: SlideAnimation(
                                            horizontalOffset: 390.0.w,
                                            child: FadeInAnimation(
                                              child: OpenContainer(
                                                closedColor: kprimaryLightColor,
                                                openColor: kprimaryLightColor,
                                                middleColor: kprimaryLightColor,
                                                closedElevation: 0,
                                                transitionType:
                                                    ContainerTransitionType
                                                        .fadeThrough,
                                                transitionDuration:
                                                    Duration(milliseconds: 500),
                                                closedBuilder: (BuildContext _,
                                                    VoidCallback
                                                        openContainer) {
                                                  return ProductsItemModel(
                                                    total: _orderGetDetails
                                                        .orderDetails[index]
                                                        .total,
                                                    totalServie:
                                                        _orderGetDetails
                                                            .orderDetails[index]
                                                            .serviceTotal,
                                                    imagePath: _orderGetDetails
                                                        .orderDetails[index]
                                                        .imageUrl,
                                                    price: _orderGetDetails
                                                        .orderDetails[index]
                                                        .price,
                                                    quantity: _orderGetDetails
                                                            .orderDetails[index]
                                                            .qty
                                                            .toString() +
                                                        "  " +
                                                        _orderGetDetails
                                                            .orderDetails[index]
                                                            .unit,
                                                    title: _orderGetDetails
                                                        .orderDetails[index]
                                                        .productName,
                                                  );
                                                },
                                                openBuilder: (BuildContext _,
                                                    VoidCallback __) {
                                                  return FisheDetailsView(
                                                    ordereDtails:
                                                        _orderGetDetails
                                                                .orderDetails[
                                                            index],
                                                    date: _orderGetDetails.date,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Wrap(
                                      direction: Axis.horizontal,
                                      children: [
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
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (_orderGetDetails.state == "2")
                                  GestureDetector(
                                    onTap: () async {
                                      if (mounted)
                                        setState(() {
                                          changed = true;
                                          isLoading = true;
                                        });
                                      await OrderController.updateOrderState(
                                        Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        ).user.token!,
                                        _orderGetDetails.id,
                                        "3",
                                      ).then((value) async {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          isScrollControlled: true,
                                          enableDrag: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return SnackabrDialog(
                                              status: true,
                                              message: LocaleKeys.order_prepered
                                                  .tr(),
                                              onPopFunction: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                        refreshOrder();
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 166.95.w,
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        color: kprimaryColor,
                                      ),
                                      child: Text(
                                        LocaleKeys.order_prepered.tr(),
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryLightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_orderGetDetails.state == "3")
                                  GestureDetector(
                                    onTap: () async {
                                      if (mounted)
                                        setState(() {
                                          changed = true;
                                          isLoading = true;
                                        });
                                      await OrderController.updateOrderState(
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user
                                            .token!,
                                        _orderGetDetails.id,
                                        "4",
                                      ).then((value) async {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          isScrollControlled: true,
                                          enableDrag: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return SnackabrDialog(
                                              status: true,
                                              message: LocaleKeys.order_delivery
                                                  .tr(),
                                              onPopFunction: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                        refreshOrder();
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 166.95.w,
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        color: kprimaryColor,
                                      ),
                                      child: Text(
                                        LocaleKeys.ship_order.tr(),
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryLightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_orderGetDetails.state == "4" &&
                                    _orderGetDetails.deliveryBy == "1" &&
                                    _orderGetDetails.delivery == "1")
                                  GestureDetector(
                                    onTap: () async {
                                      if (mounted)
                                        setState(() {
                                          changed = true;
                                          isLoading = true;
                                        });
                                      showModal(
                                        context: context,
                                        configuration:
                                            FadeScaleTransitionConfiguration(
                                          transitionDuration: Duration(
                                            milliseconds: 400,
                                          ),
                                          reverseTransitionDuration: Duration(
                                            milliseconds: 400,
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return OrderRecieved(
                                            order: _orderGetDetails,
                                          );
                                        },
                                      ).then((value) async {
                                        refreshOrder();
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 166.95.w,
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        color: kprimaryColor,
                                      ),
                                      child: Text(
                                        LocaleKeys.delivered.tr(),
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryLightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_orderGetDetails.state == "1")
                                  GestureDetector(
                                    onTap: () async {
                                      if (mounted)
                                        setState(() {
                                          changed = true;
                                          isLoading = true;
                                        });

                                      await OrderController.updateOrderState(
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user
                                              .token!,
                                          _orderGetDetails.id,
                                          "2");
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        enableDrag: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return SnackabrDialog(
                                            status: true,
                                            message: LocaleKeys
                                                .order_accepted_message
                                                .tr(),
                                            onPopFunction: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ).then((value) async {
                                        if (_orderGetDetails.deliveryBy ==
                                                "null" &&
                                            _orderGetDetails.delivery == "1") {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DeliveyChoice(
                                                order: _orderGetDetails,
                                                deliveryPrice:
                                                    _orderGetDetails.shipping,
                                              );
                                            },
                                          ).then((value) {
                                            refreshOrder();
                                          });
                                        } else {
                                          refreshOrder();
                                        }
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 166.95.w,
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        color: kprimaryColor,
                                      ),
                                      child: Text(
                                        LocaleKeys.order_accept_order.tr(),
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kprimaryLightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_orderGetDetails.state == "1")
                                  GestureDetector(
                                    onTap: () async {
                                      if (mounted)
                                        setState(() {
                                          changed = true;
                                          isLoading = true;
                                        });
                                      showModal(
                                        context: context,
                                        configuration:
                                            FadeScaleTransitionConfiguration(
                                          transitionDuration: Duration(
                                            milliseconds: 400,
                                          ),
                                          reverseTransitionDuration: Duration(
                                            milliseconds: 400,
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return CancelOrderModel(
                                            order: _orderGetDetails,
                                          );
                                        },
                                      ).then((value) async {
                                        refreshOrder();
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 166.95.w,
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border: Border.all(
                                          color: kprimaryTextColor,
                                        ),
                                        color: kprimaryLightColor,
                                      ),
                                      child: Text(
                                        LocaleKeys.order_reject_order.tr(),
                                        style: GoogleFonts.getFont(
                                          'Tajawal',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
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
        ),
      ),
    );
  }
}
