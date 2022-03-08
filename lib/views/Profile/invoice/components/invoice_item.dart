import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({
    Key? key,
    required this.invoiceNumber,
    required this.date,
    required this.totalPrice,
    required this.number,
  }) : super(key: key);
  final String invoiceNumber;
  final String date;
  final String totalPrice;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(
            title: number,
            color: kprimaryGreenColor,
          ),
          Container(
            margin: EdgeInsets.only(top: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          '#' + invoiceNumber,
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryTextColor),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        child: Text(
                          LocaleKeys.invoices_invoice_number.tr(),
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          date,
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryTextColor),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        child: Text(
                          LocaleKeys.invoices_date.tr(),
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          totalPrice + " " + LocaleKeys.rs.tr(),
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: kprimaryTextColor),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        child: Text(
                          LocaleKeys.invoices_total_price.tr(),
                          style: GoogleFonts.getFont('Tajawal',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: ksecondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
