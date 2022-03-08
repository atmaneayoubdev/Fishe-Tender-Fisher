import 'package:animations/animations.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/controllers/ticket_controller.dart';
import 'package:fishe_tender_fisher/models/ticket/ticket_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/components/item_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/components/my_tickets_item.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/views/tickets_details.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/make_complaint.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);
  static final String routeName = '/my_tickets';

  @override
  _MyTicketsScreenState createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late List<Ticket> _tickets = [];

  bool isShimmer = true;
  bool _isLoading = false;
  int page = 1;
  var next;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await TicketController.getTickets(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              page)
          .then((value) {
        if (mounted)
          setState(() {
            _tickets = value["data"];
            next = value["next"];
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
            await TicketController.getTickets(
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        .token!,
                    ++page)
                .then((value) {
              if (mounted)
                setState(() {
                  _tickets.addAll(value["data"]);
                  next = value["next"];
                  _isLoading = false;
                });
            });
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarWidget(
            title: LocaleKeys.myTickets_title.tr(),
            cangoback: true,
            function: () {
              Navigator.pop(context);
            },
            rightbutton: Container(
              margin: EdgeInsets.only(
                bottom: 20.0.h,
                left: 16.0.w,
                top: 72.0.h,
                right: 16.w,
              ),
              child: InkWell(
                onTap: () {
                  if (Provider.of<UserProvider>(context, listen: false)
                          .user
                          .status ==
                      "2") {
                    showModal(
                      context: context,
                      configuration: FadeScaleTransitionConfiguration(
                        transitionDuration: Duration(
                          milliseconds: 400,
                        ),
                        reverseTransitionDuration: Duration(
                          milliseconds: 400,
                        ),
                      ),
                      builder: (BuildContext context) {
                        return MakeComplaint();
                      },
                    ).then((value) {
                      if (mounted)
                        setState(() {
                          page = 1;
                        });
                      Future.delayed(Duration.zero, () async {
                        await TicketController.getTickets(
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .token!,
                                page)
                            .then((value) {
                          if (mounted)
                            setState(() {
                              _tickets = value["data"];
                              next = value["next"];
                            });
                        });
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
                child: Row(
                  children: [
                    Container(
                      height: 31.h,
                      child: Text(
                        LocaleKeys.open_ticket.tr(),
                        style: GoogleFonts.tajawal(
                          color: kprimaryTextColor,
                          fontSize: 15.sp,
                          height: 2.2,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      height: 31.h,
                      width: 31.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: [
                          BoxShadow(
                            color: kshadowcolor,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                      child: Icon(
                        FontAwesomeIcons.plus,
                        color: kprimaryColor,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: !isShimmer
                ? Container(
                    //height: 500,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (mounted)
                          setState(() {
                            page = 1;
                          });
                        Future.delayed(Duration.zero, () async {
                          await TicketController.getTickets(
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user
                                      .token!,
                                  page)
                              .then((value) {
                            if (mounted)
                              setState(() {
                                _tickets = value["data"];
                                next = value["next"];
                              });
                          });
                        });
                      },
                      child: AnimationLimiter(
                        child: _tickets.isNotEmpty
                            ? ListView.separated(
                                controller: _scrollController,
                                padding: EdgeInsets.only(top: 16.h),
                                key: listKey,
                                itemCount: _tickets.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Ticket _ticket = _tickets[index];
                                  DateTime dateTime =
                                      DateTime.parse(_ticket.creationDate);
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: Duration(milliseconds: 200),
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
                                              ContainerTransitionType
                                                  .fadeThrough,
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          closedBuilder: (BuildContext _,
                                              VoidCallback openContainer) {
                                            return MyTicketsItem(
                                              state: _ticket.status,
                                              date:
                                                  "${dateTime.year} - ${dateTime.month} - ${dateTime.day}",
                                              message: _ticket.message,
                                              number: _ticket.id.toString(),
                                            );
                                          },
                                          openBuilder: (BuildContext _,
                                              VoidCallback __) {
                                            return TicketDetailsView(
                                              id: _ticket.id,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
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
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        TicketShimmer(),
                        SizedBox(height: 16.h),
                        TicketShimmer(),
                        SizedBox(height: 16.h),
                        TicketShimmer(),
                        SizedBox(height: 16.h),
                        TicketShimmer(),
                        SizedBox(height: 16.h),
                        TicketShimmer(),
                        SizedBox(height: 16.h),
                        TicketShimmer(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
