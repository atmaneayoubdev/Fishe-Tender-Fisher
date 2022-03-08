import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/help_support_item.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/about_fichtender_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/help_center_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/privacy_policy_view.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/termsandconditions_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/tips_instructions_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:html/dom.dart' as dom;

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);
  static final String routeName = '/help&support';

  @override
  _HelpAndSupportScreenState createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.help_and_support_title.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(HelpCenterScreen.routeName);
              },
              child: HelpSupportItem(
                  title: LocaleKeys.help_and_support_help_center.tr(),
                  function: () {}),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AboutFicheTenderScreen.routeName);
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_about_fish_tender.tr(),
                function: () {},
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(TermsAndConditionsScreen.routeName);
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_terms_and_conditions.tr(),
                function: () {},
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(PrivacyPolicyView.routeName);
              },
              child: HelpSupportItem(
                title: LocaleKeys.help_and_support_privacy.tr(),
                function: () {},
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(TipsInstructionsView.routeName);
              },
              child: HelpSupportItem(
                title: LocaleKeys.tips.tr(),
                function: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
