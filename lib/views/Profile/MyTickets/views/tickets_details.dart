import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/controllers/ticket_controller.dart';
import 'package:fishe_tender_fisher/models/ticket/comment_model.dart';
import 'package:fishe_tender_fisher/models/ticket/ticket_details_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/components/comment_item.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/components/item_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/components/my_tickets_bottm_sheet.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/components/my_tickets_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../constants.dart';

class TicketDetailsView extends StatefulWidget {
  const TicketDetailsView({Key? key, required this.id}) : super(key: key);
  static final String routeName = '/ticket_details';
  final int id;

  @override
  _TicketDetailsViewsState createState() => _TicketDetailsViewsState();
}

class _TicketDetailsViewsState extends State<TicketDetailsView> {
  DateTime dateTime = new DateTime(2000);

  TicketDetails details = TicketDetails(
    id: 0,
    title: '',
    message: '',
    status: '0',
    catId: '',
    creationDate: '',
    comment: [],
  );
  bool isShimmer = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await TicketController.getTicketDetails(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              widget.id)
          .then((value) {
        if (mounted)
          setState(() {
            details = value;
            dateTime = DateTime.parse(value.creationDate);
            isShimmer = false;
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarWidget(
            title: LocaleKeys.ticket_details.tr(),
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
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: MyTicketsBottomSheet(
                            id: widget.id,
                          ),
                        ),
                      );
                    },
                  ).then((value) async {
                    await TicketController.getTicketDetails(
                      Provider.of<UserProvider>(context, listen: false)
                          .user
                          .token!,
                      widget.id,
                    ).then((value) {
                      if (mounted)
                        setState(() {
                          details = value;
                          dateTime = DateTime.parse(value.creationDate);
                        });
                    });
                  });
                },
                child: Row(
                  children: [
                    Container(
                      height: 31.h,
                      child: Text(
                        LocaleKeys.add_response.tr(),
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
          SizedBox(
            height: 16.h,
          ),
          if (details.status != "0")
            MyTicketsItem(
              state: details.status,
              date: "${dateTime.year} - ${dateTime.month} - ${dateTime.day}",
              message: details.message,
              number: details.id.toString(),
            ),
          SizedBox(
            height: 16.h,
          ),
          Expanded(
            child: !isShimmer
                ? Column(
                    children: [
                      details.comment.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: details.comment.length,
                                itemBuilder: (context, index) {
                                  Comment _comment = details.comment[index];
                                  DateTime dateTime =
                                      DateTime.parse(details.creationDate);
                                  return CommentItem(
                                    date:
                                        "${dateTime.year} - ${dateTime.month} - ${dateTime.day}",
                                    message: _comment.message,
                                    sender: _comment.sender,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 16.h,
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  LocaleKeys.no_data.tr(),
                                  style: GoogleFonts.tajawal(
                                      fontSize: 16.sp,
                                      color: kprimaryTextColor,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                    ],
                  )
                : Wrap(
                    direction: Axis.vertical,
                    children: [
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
        ],
      ),
    );
  }
}
