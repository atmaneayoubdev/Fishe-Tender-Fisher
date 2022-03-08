import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/transaction_controller.dart';
import 'package:fishe_tender_fisher/models/transaction/transaction_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/components/transaction_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/components/transcation_table_item_model.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/cash_withdrawel_request_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/wallet_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class WalletView extends StatefulWidget {
  static final String routeName = '/wallet_view';

  const WalletView({Key? key}) : super(key: key);

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  ScrollController _scrollController = ScrollController();
  DateTime date = new DateTime(2000);
  List<Transaction> _transactions = [];
  bool _isShimmer = true;
  var next;
  int page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await TransactionController.getTransaction(
              Provider.of<UserProvider>(context, listen: false).user.token!,
              page)
          .then((value) {
        if (value != null) {
          setState(() {
            _transactions = value["data"];
            next = value["next"];
            print(next);
            _isShimmer = false;
          });
        }
        _isShimmer = false;
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        if (next != null) {
          Future.delayed(Duration.zero, () async {
            setState(() {
              _isLoading = true;
            });
            await TransactionController.getTransaction(
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        .token!,
                    ++page)
                .then((value) {
              if (value["data"] != null) {
                setState(() {
                  _transactions.addAll(value["data"]);
                  next = value['next'];
                  _isLoading = false;
                });
              }
            });
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.wallet_wallet.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 35.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 18.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 64.h,
                    width: 64.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 243, 242, 1),
                    ),
                    child: Icon(
                      Icons.payment,
                      color: Color.fromRGBO(252, 146, 135, 1),
                      size: 30.sp,
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<UserProvider>(context, listen: true)
                            .user
                            .wallet!,
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          color: kprimaryTextColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        LocaleKeys.wallet_wallet_balance.tr(),
                        style: GoogleFonts.getFont(
                          'Tajawal',
                          color: kprimaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38.h,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: page > 1 ? 480.h : 380.h,
              width: 340.w,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: kbordercolor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: kbordercolor,
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.wallet_transaction.tr(),
                          style: GoogleFonts.getFont(
                            'Tajawal',
                            fontSize: 12.sp,
                            color: kprimaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                        ),
                        Text(LocaleKeys.order_date.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 12.sp,
                              color: kprimaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1),
                        Text(LocaleKeys.wallet_state.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 12.sp,
                              color: kprimaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1),
                        Text(LocaleKeys.transaction_amount.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 12.sp,
                              color: kprimaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  Expanded(
                    //height: 410.h,
                    child: !_isShimmer
                        ? RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                page = 1;
                              });
                              await TransactionController.getTransaction(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user
                                          .token!,
                                      page)
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    _transactions = value["data"];
                                    next = value["next"];
                                    print(next);
                                    _isShimmer = false;
                                  });
                                }
                              });
                            },
                            child: Stack(
                              children: [
                                _transactions.isNotEmpty
                                    ? Container(
                                        child: ListView.builder(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: _scrollController,
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: false,
                                          itemCount: _transactions.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Transaction _transaction =
                                                _transactions[index];
                                            DateTime dateTime = DateTime.parse(
                                                _transaction.createdAt);
                                            print(_transaction.state);
                                            return ListItem(
                                              type: _transaction.type,
                                              number: _transaction.id,
                                              date:
                                                  "${dateTime.year} - ${dateTime.month} - ${dateTime.day}",
                                              state: _transaction.state,
                                              amount: _transaction.amount,
                                            );
                                          },
                                        ),
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
                                if (_isLoading)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 390.w,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        : Wrap(
                            direction: Axis.vertical,
                            children: [
                              TransactionShimmer(),
                              TransactionShimmer(),
                              TransactionShimmer(),
                              TransactionShimmer(),
                              TransactionShimmer(),
                              TransactionShimmer(),
                              TransactionShimmer(),
                              TransactionShimmer(),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(WalletHistoryView.routeName);
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            color: kprimaryColor,
                            size: 15.sp,
                          ),
                          SizedBox(
                            width: 7.w,
                          ),
                          Text(
                            LocaleKeys.wallet_wallet_history.tr(),
                            style: GoogleFonts.getFont(
                              'Tajawal',
                              fontSize: 12.sp,
                              color: kprimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              onTap: () {
                if (Provider.of<UserProvider>(context, listen: false)
                        .user
                        .status !=
                    "2") {
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
                  return;
                }
                var walet = double.parse(
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        .wallet!);
                if (walet == 0) {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return SnackabrDialog(
                        status: true,
                        message: LocaleKeys.no_mony.tr(),
                        onPopFunction: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CashWithdrawalView(),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                child: BottomButton(
                  title: LocaleKeys.wallet_cwr.tr(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
