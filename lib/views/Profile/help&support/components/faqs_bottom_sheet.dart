import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/help_support_controller.dart';
import 'package:fishe_tender_fisher/models/FAQ/subject_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/faq_filter_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/components/filter_item.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FaqBottomSheet extends StatefulWidget {
  @override
  _FaqBottomSheetState createState() => _FaqBottomSheetState();
}

class _FaqBottomSheetState extends State<FaqBottomSheet> {
  List<Subject> _subjects = [];
  Subject? _selectedSubject;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await HelpSupportController.getFaqList(
              Provider.of<UserProvider>(context, listen: false).user.token!)
          .then((value) {
        if (mounted)
          setState(() {
            _subjects = value;
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 209.h,
      color: kprimaryLightColor,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 12.w,
                right: 12.w,
                top: 19.h,
                bottom: 14.h,
              ),
              child: TitleWidget(
                  title: LocaleKeys.help_and_support_question_filtre.tr(),
                  color: ksecondaryColor),
            ),
            Expanded(
              child: _subjects.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _subjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        Subject thisSub = _subjects[index];
                        return GestureDetector(
                            onTap: () {
                              if (mounted)
                                setState(() {
                                  _selectedSubject = thisSub;
                                });
                            },
                            child: FaqFilterItem(
                              name: thisSub.name,
                              isSelected:
                                  thisSub == _selectedSubject ? true : false,
                            ));
                      },
                    )
                  : Wrap(
                      direction: Axis.vertical,
                      children: [
                        FilterShimmer(),
                        FilterShimmer(),
                        FilterShimmer(),
                      ],
                    ),
            ),
            GestureDetector(
              onTap: () {
                if (_selectedSubject != null)
                  Navigator.of(context).pop(_selectedSubject);
              },
              child: Container(
                  margin: EdgeInsets.only(
                    left: 21.w,
                    right: 21.w,
                    bottom: 16.h,
                  ),
                  child: BottomButton(
                    title: LocaleKeys.help_and_support_apply.tr(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
