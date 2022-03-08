import 'package:animations/animations.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/components/invoice_item.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/views/invoice_details.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/components/invoices_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);
  static final String routeName = '/invoice_sceeen';

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  ScrollController _scrollController = ScrollController();

  List<Order2> order2 = [];
  List<Order2> invoices = [];
  var next;
  var pageNumber = 1;
  bool _isLoading = false;
  bool isShimmer = true;
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
      await OrderController.getOrdersList(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        pageNumber,
      ).then((value) {
        if (mounted)
          setState(() {
            order2 = value["data"];
            next = value["next"];
            print(next);
            invoices = order2.where((element) => element.state == "5").toList();
            isShimmer = false;
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
            if (next != null) {
              await OrderController.getOrdersList(
                      Provider.of<UserProvider>(context, listen: false)
                          .user
                          .token!,
                      ++pageNumber)
                  .then((value) {
                if (mounted)
                  setState(() {
                    order2.addAll(value["data"]);
                    next = value["next"];
                    print(next);
                    invoices = order2
                        .where((element) => element.state == "5")
                        .toList();
                    _isLoading = false;
                  });
              });
            }
          });
        }
      }
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
              title: LocaleKeys.invoices_title.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: !isShimmer
                  ? AnimationLimiter(
                      child: Stack(
                      children: [
                        invoices.isNotEmpty
                            ? ListView.builder(
                                controller: _scrollController,
                                physics:
                                    const AlwaysScrollableScrollPhysics(), // new
                                padding: EdgeInsets.zero,
                                itemCount: invoices.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Order2 invoice = invoices[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 600),
                                    child: SlideAnimation(
                                      horizontalOffset: 390.0.w,
                                      child: FadeInAnimation(
                                          child: Container(
                                        margin: EdgeInsets.only(
                                          top: 16.h,
                                          left: 18.w,
                                          right: 18.w,
                                        ),
                                        padding:
                                            context.locale.toLanguageTag() ==
                                                    'en'
                                                ? EdgeInsets.only(
                                                    top: 17.h,
                                                    left: 18.w,
                                                    bottom: 2,
                                                    right: 86.w)
                                                : EdgeInsets.only(
                                                    top: 17.h,
                                                    left: 86.w,
                                                    bottom: 2,
                                                    right: 18.w,
                                                  ),
                                        height: 140.h,
                                        width: 355.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: kprimaryLightColor,
                                          boxShadow: [
                                            BoxShadow(
                                                color: kshadowcolor,
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                                offset: Offset(0.0, 3.0)),
                                          ],
                                        ),
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
                                              VoidCallback openContainer) {
                                            return InvoiceItem(
                                              date: invoice.date,
                                              invoiceNumber:
                                                  invoice.id.toString(),
                                              number: invoice.user.name,
                                              totalPrice: invoice.delivery ==
                                                      "1"
                                                  ? invoice.amount
                                                  : (double.parse(
                                                              deliveryPrice) +
                                                          double.parse(
                                                              invoice.amount))
                                                      .toString(),
                                            );
                                          },
                                          openBuilder: (BuildContext _,
                                              VoidCallback __) {
                                            return InvoiceDtetails(
                                              invoice: invoice,
                                            );
                                          },
                                        ),
                                      )
                                          //       );
                                          ),
                                    ),
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
                        if (_isLoading)
                          Positioned(
                            bottom: 100.h,
                            child: Container(
                              width: 390.w,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          InvoiceShimmer(),
                          InvoiceShimmer(),
                          InvoiceShimmer(),
                          InvoiceShimmer(),
                          InvoiceShimmer(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
