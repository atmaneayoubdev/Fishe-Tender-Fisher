import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/help_support_controller.dart';
import 'package:fishe_tender_fisher/models/FAQ/subject_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/faq_item.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/faqs_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({Key? key}) : super(key: key);
  static final String routeName = '/faqs_screen';

  @override
  _FaqsScreenState createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  List<Subject> _sub = [];
  List<Subject> _temp = [];

  bool question1 = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await HelpSupportController.getFaqList(
              Provider.of<UserProvider>(context, listen: false).user.token!)
          .then((value) {
        if (mounted)
          setState(() {
            _sub = value;
            _temp = value;
          });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              title: LocaleKeys.help_and_support_faqs.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
              rightbutton: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r),
                  boxShadow: [
                    BoxShadow(
                        color: kshadowcolor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0.0, 3.0)),
                  ],
                ),
                height: 31.h,
                width: 31.w,
                margin: EdgeInsets.only(
                    bottom: 20.0.h, left: 16.0.w, top: 72.0.h, right: 16.w),
                // Button color
                child: InkWell(
                  splashColor: ksecondaryColor, // Splash color
                  onTap: () {
                    showModalBottomSheet<Subject>(
                      context: context,
                      enableDrag: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return FaqBottomSheet();
                      },
                    ).then((subject) async {
                      if (subject != null) if (mounted)
                        setState(() {
                          _sub = _temp
                              .where((element) => element.id == subject.id)
                              .toList();
                        });
                    });
                  },
                  child: SizedBox(
                    child: Image.asset(
                      "assets/icons/filtre.png",
                      color: ksecondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, left: 18.w, right: 18.w),
              child: Text(
                LocaleKeys.help_and_support_frequently_asked_questions.tr(),
                style: GoogleFonts.getFont('Tajawal',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: kprimaryTextColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 9.h, left: 18.w, right: 18.w),
              child: Text(
                LocaleKeys.help_and_support_faqs_subtitle.tr(),
                style: GoogleFonts.getFont(
                  'Tajawal',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ksecondaryTextColor,
                ),
              ),
            ),
            Expanded(
              child: _sub.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _sub.length,
                      itemBuilder: (BuildContext context, int index) {
                        Subject _subject = _sub[index];
                        if (_subject.questions.isNotEmpty) {
                          for (int i = 0; i < _subject.questions.length; i++) {
                            {
                              return FaqItem(
                                questin: _subject.questions[i].question,
                                answer: _subject.questions[i].answer,
                              );
                            }
                          }
                        }
                        return SizedBox();
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
