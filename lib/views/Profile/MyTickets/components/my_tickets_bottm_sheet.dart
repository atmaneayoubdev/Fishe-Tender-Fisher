import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/ticket_controller.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MyTicketsBottomSheet extends StatefulWidget {
  const MyTicketsBottomSheet({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _MyTicketsBottomSheetState createState() => _MyTicketsBottomSheetState();
}

class _MyTicketsBottomSheetState extends State<MyTicketsBottomSheet> {
  TextEditingController _controller = TextEditingController();
  var borderColor = kbordercolor;
  bool _isLoading = false;

  Future<void> addComment() async {
    if (_controller.text != "") {
      if (mounted)
        setState(() {
          _isLoading = true;
        });
      await TicketController.addComment(
        Provider.of<UserProvider>(context, listen: false).user.token!,
        _controller.text,
        widget.id,
      ).then((value) {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SnackabrDialog(
              status: value == 'Created' ? true : false,
              message: value == 'Created'
                  ? LocaleKeys.operation_success.tr()
                  : LocaleKeys.operation_field.tr(),
              onPopFunction: () {
                Navigator.pop(context);
              },
            );
          },
        ).then((value) {
          Navigator.pop(context);
        });
      });
    } else {
      if (mounted)
        setState(() {
          borderColor = kredcolor;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 343.h,
      decoration: BoxDecoration(
        color: kprimaryLightColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: context.locale.toLanguageTag() == 'en'
                            ? EdgeInsets.only(left: 16.w, top: 16.h)
                            : EdgeInsets.only(right: 16.w, top: 16.h),
                        child: TitleWidget(
                          title: LocaleKeys.myTickets_ticket_number.tr() +
                              " : ${widget.id}",
                          color: ksecondaryColor,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kprimaryColor,
                        ),
                        height: 32.h,
                        width: 32.w,
                        alignment: Alignment.center,
                        margin: context.locale.toLanguageTag() == 'en'
                            ? EdgeInsets.only(top: 15.5.h, right: 18.w)
                            : EdgeInsets.only(top: 15.5.h, left: 18.w),
                        // Button color
                        child: InkWell(
                          splashColor: ksecondaryColor, // Splash color
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                              child: Icon(
                            Icons.close,
                            size: 20.sp,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: context.locale.toLanguageTag() == 'en'
                      ? EdgeInsets.only(top: 15.5.h, left: 18.w)
                      : EdgeInsets.only(top: 15.5.h, right: 18.w),
                  child: Text(LocaleKeys.write_response.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: kprimaryTextColor,
                      )),
                ),
                Container(
                  margin: context.locale.toLanguageTag() == 'en'
                      ? EdgeInsets.only(top: 12.5.h, left: 18.w)
                      : EdgeInsets.only(top: 12.5.h, right: 18.w),
                  child: Text(LocaleKeys.myTickets_answer.tr(),
                      style: GoogleFonts.getFont(
                        'Tajawal',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: kprimaryTextColor,
                      )),
                ),
                Container(
                  height: 121.h,
                  width: 355.w,
                  margin: EdgeInsets.only(
                    top: 7.h,
                    right: 18.w,
                    left: 18.w,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid, color: borderColor),
                      borderRadius: BorderRadius.circular(5.r)),
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.getFont('Tajawal',
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: LocaleKeys.response_text.tr(),
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      addComment();
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    addComment();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 20.h,
                      bottom: 16.h,
                      left: 21.w,
                      right: 21.w,
                    ),
                    child: BottomButton(title: LocaleKeys.submit.tr()),
                  ),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
