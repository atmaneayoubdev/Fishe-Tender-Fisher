import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:fishe_tender_fisher/controllers/order_controller.dart';
import 'package:fishe_tender_fisher/services/order_count.dart';
import 'package:fishe_tender_fisher/services/recent_orders.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_details_view.dart';
import 'package:fishe_tender_fisher/views/Sign%20In%20&%20Sign%20Up/number_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    setState(() {
      Future.delayed(Duration.zero, () async {
        await SharedPreferences.getInstance().then((value1) async {
          if (value1.containsKey('token')) {
            await AuthController.getUser(value1.getString('token')!)
                .then((value) {
              if (value.id == "Unauthenticated") {
                value1.clear();
                return;
              } else {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(value);
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user.token = value1.getString('token');
              }
            });
            if (Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user.id !=
                "") {
              await OrderController.getOrdersList(
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user.token!,
                0,
              ).then((value) {
                Provider.of<RecentOrders>(context, listen: false)
                    .replaceAll(value["data"]);
                if (value['data'].isNotEmpty)
                  Provider.of<RecentOrders>(context, listen: false).addLast();
              });
            }
          }
        });
      });

      Future.delayed(const Duration(milliseconds: 4000), () async {
        await SharedPreferences.getInstance().then((value1) async {
          if (value1.containsKey('token')) {
            await OrderController.getOrderCount(
              value1.getString('token')!,
            ).then((value) {
              Provider.of<CountProvider>(context, listen: false).editdata(
                value.pending,
                value.received,
                value.prepared,
                value.shipped,
                value.accepted,
                value.rejected,
              );
              if (Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).user.nameAr !=
                      "" ||
                  Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).user.name !=
                      "" ||
                  Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).user.email !=
                      "" ||
                  Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).user.address !=
                      "" ||
                  Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).user.commercialRegistrationRumber !=
                      "") {
                Navigator.popAndPushNamed(context, HomeScreen.routeName);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MarketDetailsView(
                            fromNumberInput: true,
                          )),
                );
              }
            });
          } else {
            Navigator.popAndPushNamed(context, NumberInput.routeName);
          }
        });
        //Navigator.popAndPushNamed(context, OnboardingScreen.routeName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: kprimaryColor,
      body: Center(
        child: Image.asset(
          "assets/images/splash.png",
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
