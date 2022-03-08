import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/notifications/components/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);
  static final String routeName = '/notfication_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.notification_notification.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 16.h,
            ),
            NotificationModel(
              title: LocaleKeys.notification_complaint.tr(),
              subtitle: LocaleKeys.notification_complaint_body_text.tr(),
              image: 'assets/icons/ic_complaint.png',
            ),
            SizedBox(
              height: 12.h,
            ),
            NotificationModel(
              title: LocaleKeys.notification_rating.tr(),
              subtitle: LocaleKeys.notification_complaint_body_text.tr(),
              image: 'assets/icons/ic_rating.png',
            ),
            SizedBox(
              height: 12.h,
            ),
            NotificationModel(
              title: LocaleKeys.notification_new_order.tr(),
              subtitle: LocaleKeys.notification_complaint_body_text.tr(),
              image: 'assets/icons/ic_new_order.png',
            ),
          ],
        ),
      ),
    );
  }
}
