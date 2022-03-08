import 'package:animations/animations.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/ask_question.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/delete_account.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/help_support_item.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/make_complaint.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/faqs_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);
  static final String routeName = '/help_center';

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.help_and_support_help_center.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            GestureDetector(
              onTap: () {
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
                    return DeleteAccount();
                  },
                );
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_delete_account.tr(),
                function: () {},
              ),
            ),
            GestureDetector(
              onTap: () {
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
                    return AskQuestion();
                  },
                );
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_ask_a_question.tr(),
                function: () {},
              ),
            ),
            GestureDetector(
              onTap: () {
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
                );
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_make_complaint.tr(),
                function: () {},
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(FaqsScreen.routeName);
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_faqs.tr(),
                function: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
