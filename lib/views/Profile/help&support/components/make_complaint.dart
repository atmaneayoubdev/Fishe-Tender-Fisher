import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/ticket_controller.dart';
import 'package:fishe_tender_fisher/models/ticket/ticket_category_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MakeComplaint extends StatefulWidget {
  @override
  _MakeComplaintState createState() => _MakeComplaintState();
}

class _MakeComplaintState extends State<MakeComplaint> {
  TextEditingController _controller = TextEditingController();
  String languagedropdownValue = LocaleKeys.help_and_support_suggestions.tr();
  TicketCategory? _value;
  late List<TicketCategory> _cats = [];
  bool _isLoading = false;
  var borderColor0 = kbordercolor;
  var borderColor1 = kbordercolor;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await TicketController.getTicketCategories(
              Provider.of<UserProvider>(context, listen: false).user.token!)
          .then((value) {
        if (mounted) if (mounted)
          setState(() {
            _cats = value;
          });
      });
    });
    super.initState();
  }

  Future<void> senFunc() async {
    if (_value == null) {
      if (mounted)
        setState(() {
          borderColor0 = kredcolor;
        });
      return;
    } else
      borderColor0 = kbordercolor;

    if (_controller.text == "") {
      if (mounted)
        setState(() {
          borderColor1 = kredcolor;
        });
      return;
    } else
      borderColor1 = kbordercolor;

    if (_value != null && _controller.text != "") {
      if (mounted)
        setState(() {
          _isLoading = true;
          borderColor0 = kbordercolor;
          borderColor1 = kbordercolor;
        });
      await TicketController.addTicket(
              token:
                  Provider.of<UserProvider>(context, listen: false).user.token!,
              message: _controller.text,
              catId: _value!.id,
              subject: _value!.name)
          .then((value) {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
        showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SnackabrDialog(
              status: value == 'success' ? true : false,
              message: value == 'success'
                  ? LocaleKeys.complaint_sent_success.tr()
                  : LocaleKeys.operation_success.tr(),
              onPopFunction: () {
                Navigator.pop(context);
              },
            );
          },
        ).then((value) {
          Navigator.pop(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(vertical: 0.h),
      content: Container(
          height: 448.h,
          width: 355.w,
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
                            margin: EdgeInsets.only(
                                top: 18.h, left: 16.w, right: 16.w),
                            child: Text(
                              LocaleKeys.help_and_support_make_complaint.tr(),
                              style: GoogleFonts.getFont('Tajawal',
                                  fontSize: 19.sp, fontWeight: FontWeight.bold),
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
                                ? EdgeInsets.only(top: 18.h, right: 16.w)
                                : EdgeInsets.only(top: 18.h, left: 16.w),
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
                                color: kprimaryLightColor,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 18.w, right: 18.w, top: 11.h),
                      child: Text(
                        LocaleKeys.help_and_support_complaint_body_text.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: context.locale.toLanguageTag() == 'en'
                          ? EdgeInsets.only(top: 7.h, left: 16.w)
                          : EdgeInsets.only(top: 7.h, right: 16.w),
                      child: Text(
                        LocaleKeys.help_and_support_complaint_title2.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 54.h,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin:
                          EdgeInsets.only(left: 18.w, right: 18.w, top: 7.h),
                      decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid, color: borderColor0),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: DropdownButton<TicketCategory>(
                        hint: Text(LocaleKeys.subject.tr()),
                        value: _value,
                        underline: SizedBox(
                          height: 0,
                        ),
                        isExpanded: true,
                        iconSize: 15.sp,
                        icon: Icon(
                          FontAwesomeIcons.chevronDown,
                        ),
                        items: (_cats).map((TicketCategory cat) {
                          return DropdownMenuItem<TicketCategory>(
                            value: cat,
                            child: new Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (TicketCategory? newValue) {
                          if (mounted)
                            setState(() {
                              _value = newValue;
                            });
                          print(newValue?.name);
                        },
                      ),
                    ),
                    Container(
                      margin: context.locale.toLanguageTag() == 'en'
                          ? EdgeInsets.only(top: 7.h, left: 16.w)
                          : EdgeInsets.only(top: 7.h, right: 16.w),
                      child: Text(
                        LocaleKeys.help_and_support_complaint_title3.tr(),
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 131.h,
                      width: 319.w,
                      margin: EdgeInsets.only(
                        top: 10.h,
                        right: 18.w,
                        left: 18.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid, color: borderColor1),
                          borderRadius: BorderRadius.circular(5.r)),
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.getFont('Tajawal',
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText:
                              LocaleKeys.help_and_support_complaint_title3.tr(),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (String v) {
                          senFunc();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 13.0.w,
                        right: 14.0.w,
                        bottom: 18.h,
                        top: 16.h,
                      ),
                      child: GestureDetector(
                        child: BottomButton(
                          title: LocaleKeys.submit.tr(),
                        ),
                        onTap: () async {
                          senFunc();
                        },
                      ),
                    ),
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
          )),
    );
  }
}
