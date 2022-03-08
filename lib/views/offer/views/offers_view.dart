import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/controllers/offers_controller.dart';
import 'package:fishe_tender_fisher/models/offer/offer_model.dart';
import 'package:fishe_tender_fisher/models/products/section_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:fishe_tender_fisher/views/Order/views/order_view.dart';
import 'package:fishe_tender_fisher/views/Profile/profile_screen.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/number_input.dart';
import 'package:fishe_tender_fisher/views/offer/components/offer_item.dart';
import 'package:fishe_tender_fisher/views/offer/components/offer_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:easy_localization/easy_localization.dart';

class OfferView extends StatefulWidget {
  static final String routeName = '/offer_view';

  @override
  _OfferViewState createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  ScrollController _scrollController = ScrollController();
  List<Offer> offers = [];
  var next;
  bool _isLoading = false;
  int pageNumber = 1;
  bool isShimmer = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await OffersController.getOffers(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        pageNumber,
      ).then((value) async {
        print(value);
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
        if (value != "error") {
          if (mounted)
            setState(() {
              offers = value["data"];
              if (value["data"].isNotEmpty)
                offers.add(
                  Offer(
                    id: "",
                    from: "",
                    type: "",
                    to: "",
                    imageUrl: "",
                    state: "",
                    amount: "",
                    section: Section(
                        id: -1,
                        name: "",
                        description: "",
                        imageUrl: "",
                        isActive: ""),
                  ),
                );
              next = value["next"];
              print(next);
            });
        }
      });
    }).then((value) {
      if (mounted)
        setState(() {
          isShimmer = false;
        });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        if (next != null) {
          Future.delayed(Duration.zero, () async {
            setState(() {
              _isLoading = true;
            });
            await OffersController.getOffers(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              ++pageNumber,
            ).then((value) {
              setState(() {
                offers.removeLast();
                offers.addAll(value["data"]);
                if (value["data"].isNotEmpty)
                  offers.add(
                    Offer(
                      id: "",
                      from: "",
                      to: "",
                      imageUrl: "",
                      state: "",
                      amount: "",
                      type: "",
                      section: Section(
                          id: -1,
                          name: "",
                          description: "",
                          imageUrl: "",
                          isActive: ""),
                    ),
                  );
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              title: LocaleKeys.my_ads.tr(),
              cangoback: false,
            ),
            Expanded(
              child: !isShimmer
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await OffersController.getOffers(
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .token!,
                                pageNumber)
                            .then((value) {
                          setState(() {
                            offers = value["data"];
                            next = value["next"];
                          });
                        });
                      },
                      child: AnimationLimiter(
                        child: Stack(
                          children: [
                            offers.isNotEmpty
                                ? ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.zero,
                                    itemCount: offers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Offer _offer = offers[index];
                                      if (_offer.id == "")
                                        return SizedBox(
                                          height: 100.h,
                                        );
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 600),
                                        child: SlideAnimation(
                                          horizontalOffset: 390.0.w,
                                          child: FadeInAnimation(
                                            child: OfferItem(
                                              state: _offer.state,
                                              type: _offer.type,
                                              imageUrl: _offer.imageUrl,
                                              section: _offer.section,
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
                                            fontSize: 20.sp,
                                            color: kprimaryTextColor,
                                            fontWeight: FontWeight.normal))),
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
                      ))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          OfferShimmer(),
                          OfferShimmer(),
                          OfferShimmer(),
                          OfferShimmer(),
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
                    color: Colors.white30,
                    child: InkWell(
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                      child: Icon(
                        Icons.local_offer_outlined,
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
                      onTap: () {
                        Navigator.of(context)
                            .popAndPushNamed(OrderView.routeName);
                      },
                      focusColor: Colors.white30,
                      hoverColor: Colors.white30,
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
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
