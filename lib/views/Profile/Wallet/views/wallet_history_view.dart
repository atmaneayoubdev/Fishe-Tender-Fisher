import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/common/app_bar.dart';
import 'package:fishe_tender_fisher/controllers/transaction_controller.dart';
import 'package:fishe_tender_fisher/models/transaction/transaction_model.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/components/history_shimmer.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/components/wallet_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class WalletHistoryView extends StatefulWidget {
  static final String routeName = '/wallet_history_view';
  const WalletHistoryView({Key? key}) : super(key: key);

  @override
  _WalletHistoryViewState createState() => _WalletHistoryViewState();
}

class _WalletHistoryViewState extends State<WalletHistoryView> {
  ScrollController _scrollController = ScrollController();

  List<Transaction> _transactions = [];
  bool _isShimmer = true;
  var next;
  int page = 1;
  bool _isLoading = false;

  @override
  void initState() {
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
              Provider.of<UserProvider>(context, listen: false).user.token!,
              ++page,
            ).then((value) {
              setState(() {});
              if (value["data"].isNotEmpty) {
                setState(() {
                  _transactions.addAll(value["data"]);
                  print(_transactions.length);
                  next = value['next'];
                  _isLoading = false;
                });
              }
            });
          });
        }
      }
    });
    super.initState();
  }

  Future _onRefresh() async {
    setState(() {
      page = 1;
      //_transactions.clear();
    });
    await TransactionController.getTransaction(
            Provider.of<UserProvider>(context, listen: false).user.token!, page)
        .then((value) {
      if (value != null) {
        setState(() {
          _transactions = value["data"];
          next = value["next"];
          print(next);
        });
      }
      _isShimmer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBarWidget(
              title: LocaleKeys.wallet_wallet_history.tr(),
              cangoback: true,
              function: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 14.h,
            ),
            Expanded(
              child: !_isShimmer
                  ? Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: _transactions.isNotEmpty
                              ? ListView.separated(
                                  controller: _scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: _transactions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Transaction transaction =
                                        _transactions[index];
                                    print(transaction.parent.user.name);
                                    DateTime dateTime =
                                        DateTime.parse(transaction.createdAt);
                                    return WalletHistoryItem(
                                      transactionType:
                                          transaction.transactionType,
                                      image: transaction.transactionType == "2"
                                          ? "assets/icons/ic_cach_withdrawal.svg"
                                          : transaction.transactionType == "1"
                                              ? transaction.parent.user.picUrl
                                              : transaction.parent.image,
                                      orderNb: transaction.id,
                                      name:
                                          transaction.parent.user.name != "null"
                                              ? transaction.parent.user.name
                                              : transaction.parent.user.phone,
                                      date:
                                          "${dateTime.year} - ${dateTime.month} - ${dateTime.day}",
                                      transaction: transaction.amount,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 10.h,
                                    );
                                  },
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
                        ),
                        if (_isLoading)
                          Positioned(
                            bottom: 20.h,
                            child: Container(
                              width: 390.w,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    )
                  : Wrap(
                      direction: Axis.horizontal,
                      children: [
                        HistoryShimmer(),
                        HistoryShimmer(),
                        HistoryShimmer(),
                        HistoryShimmer(),
                        HistoryShimmer(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
