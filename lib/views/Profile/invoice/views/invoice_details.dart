import 'package:animations/animations.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Order/components/order_item_shimmer_model.dart';
import 'package:fishe_tender_fisher/views/Order/components/order_products_item_model.dart';
import 'package:fishe_tender_fisher/common/fishe_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class InvoiceDtetails extends StatefulWidget {
  const InvoiceDtetails({Key? key, required this.invoice}) : super(key: key);
  static final String routeName = '/invoice_details_sceeen';
  final Order2 invoice;

  @override
  _InvoiceDtetailsState createState() => _InvoiceDtetailsState();
}

class _InvoiceDtetailsState extends State<InvoiceDtetails> {
  OrderGetDetail _invoiceDetails = OrderGetDetail(
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
  String deliveryPrice = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await OrderController.getDeliveryPrice(
              Provider.of<UserProvider>(context, listen: false).user.token!)
          .then((value) {
        if (value != "error") if (mounted)
          setState(() {
            deliveryPrice = value;
          });
      });
      await OrderController.getOrderDetails(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        widget.invoice.id,
      ).then((value) {
        if (mounted)
          setState(() {
            _invoiceDetails = value;
          });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              title: LocaleKeys.invoices_invoice_details.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await OrderController.getOrderDetails(
                      Provider.of<UserProvider>(context, listen: false)
                          .user
                          .token!,
                      widget.invoice.id,
                    ).then((value) {
                      if (mounted)
                        setState(() {
                          _invoiceDetails = value;
                        });
                    });
                  },
                  child: _invoiceDetails.orderDetails.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: _invoiceDetails.orderDetails.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                horizontalOffset: 390.0.w,
                                child: FadeInAnimation(
                                  child: OpenContainer(
                                    closedColor: kprimaryLightColor,
                                    openColor: kprimaryLightColor,
                                    middleColor: kprimaryLightColor,
                                    closedElevation: 0,
                                    transitionType:
                                        ContainerTransitionType.fadeThrough,
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    closedBuilder: (BuildContext _,
                                        VoidCallback openContainer) {
                                      return ProductsItemModel(
                                        total: _invoiceDetails
                                            .orderDetails[index].total,
                                        totalServie: _invoiceDetails
                                            .orderDetails[index].serviceTotal,
                                        imagePath: _invoiceDetails
                                            .orderDetails[index].imageUrl,
                                        price: _invoiceDetails
                                            .orderDetails[index].price,
                                        quantity: _invoiceDetails
                                                .orderDetails[index].qty
                                                .toString() +
                                            "  " +
                                            _invoiceDetails
                                                .orderDetails[index].unit,
                                        title: _invoiceDetails
                                            .orderDetails[index].productName,
                                      );
                                    },
                                    openBuilder:
                                        (BuildContext _, VoidCallback __) {
                                      return FisheDetailsView(
                                        ordereDtails:
                                            _invoiceDetails.orderDetails[index],
                                        date: _invoiceDetails.date,
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
            ),
            if (_invoiceDetails.id != "")
              Container(
                height: _invoiceDetails.deliveryBy == "1" ? 90.h : 70.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 32.w),
                decoration: BoxDecoration(
                  color: kprimaryLightColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_invoiceDetails.deliveryBy == "1")
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 20.h,
                                width: 121.w,
                                child: Text(
                                  '${LocaleKeys.delivery_price.tr()}:',
                                  style: GoogleFonts.getFont('Tajawal',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: ksecondaryTextColor),
                                )),
                            Text(
                              deliveryPrice + " " + LocaleKeys.rs.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kprimaryTextColor),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 20.h,
                              width: 121.w,
                              child: Text(
                                '${LocaleKeys.invoices_total.tr()}:',
                                style: GoogleFonts.getFont('Tajawal',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ksecondaryTextColor),
                              )),
                          Text(
                            _invoiceDetails.amount + " " + LocaleKeys.rs.tr(),
                            style: GoogleFonts.getFont('Tajawal',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: kprimaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
