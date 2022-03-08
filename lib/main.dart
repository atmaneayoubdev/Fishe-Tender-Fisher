import 'dart:math';

import 'package:animations/animations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fishe_tender_fisher/services/image_provider.dart';
import 'package:fishe_tender_fisher/services/ios_notification.dart';
import 'package:fishe_tender_fisher/services/order_count.dart';
import 'package:fishe_tender_fisher/services/recent_orders.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/add_product_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/wallet_history_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Wallet/views/wallet_view.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/privacy_policy_view.dart';
import 'package:fishe_tender_fisher/views/Profile/notifications/views/notification_view.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_details_view.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/termsandconditions_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/about_fichtender_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/helpandsupport_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/help_center_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/Market%20Account/views/market_view.dart';
import 'package:fishe_tender_fisher/views/Profile/MyTickets/views/my_tickets_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/faqs_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/invoice/views/invoice_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/settings/settings_screen.dart';
import 'package:fishe_tender_fisher/translations/codegen_loader.g.dart';
import 'package:fishe_tender_fisher/views/Profile/help&support/views/tips_instructions_view.dart';
import 'package:fishe_tender_fisher/splash_screen.dart';
import 'package:fishe_tender_fisher/views/offer/views/offers_view.dart';
import 'package:fishe_tender_fisher/views/Order/views/order_view.dart';
import 'package:fishe_tender_fisher/views/Home/views/home_screen.dart';
import 'package:fishe_tender_fisher/views/Profile/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'views/Sign In & Sign Up/number_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  var rng = new Random();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
          channelKey: 'FISHTENDER_NOTIFICATION_FISHER',
          channelName: '',
          channelDescription: "",
          defaultColor: Color(0XFF9050DD),
          playSound: true,
          enableLights: true,
          enableVibration: true,
        )
      ]);

  FirebaseApp firebaseApp = await Firebase.initializeApp();
  FirebaseMessaging firebaseMessaging;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;
    if (notification != null && android != null && !kIsWeb) {
      print(message);
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: rng.nextInt(100),
        color: Colors.transparent,
        displayOnBackground: true,
        displayOnForeground: true,
        channelKey: 'FISHTENDER_NOTIFICATION_FISHER',
        notificationLayout: NotificationLayout.Inbox,
        hideLargeIconOnExpand: true,
        largeIcon: 'asset://assets/images/appicon.png',
        title: message.notification!.title,
        body: message.notification!.body,
      ));
    }
  });

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) =>
    EasyLocalization(
      path: 'assets/translations/',
      supportedLocales: [
        Locale('ar'),
        Locale('en'),
      ],
      startLocale: Locale('ar'),
      assetLoader: CodegenLoader(),
      fallbackLocale: Locale('ar'),
      child: MyApp(),
    ), // Wrap your app
    //),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<String?> authStatus() async* {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print('this is your token: ' + token!);
    yield token;
  }

  PushNotificationsManager push = PushNotificationsManager();

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ImgProvider()),
          ChangeNotifierProvider(
            create: (_) => CountProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => RecentOrders(),
          )
        ],
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'صياد فش تندر',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            sliderTheme: ThemeData.dark().sliderTheme.copyWith(
                  valueIndicatorColor: Colors.grey,
                  valueIndicatorTextStyle:
                      TextStyle(backgroundColor: Colors.transparent),
                ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
                TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
              },
            ),
          ),
          home: SplashScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ProfilScreen.routeName: (ctx) => ProfilScreen(),
            NumberInput.routeName: (ctx) => NumberInput(),
            InvoiceScreen.routeName: (ctx) => InvoiceScreen(),
            Settingscreen.routeName: (ctx) => Settingscreen(),
            HelpAndSupportScreen.routeName: (ctx) => HelpAndSupportScreen(),
            HelpCenterScreen.routeName: (ctx) => HelpCenterScreen(),
            TermsAndConditionsScreen.routeName: (ctx) =>
                TermsAndConditionsScreen(),
            AboutFicheTenderScreen.routeName: (ctx) => AboutFicheTenderScreen(),
            FaqsScreen.routeName: (ctx) => FaqsScreen(),
            MyTicketsScreen.routeName: (ctx) => MyTicketsScreen(),
            MarketAccountScreen.routeName: (ctx) => MarketAccountScreen(),
            MarketDetailsView.routeName: (ctx) => MarketDetailsView(),
            NotificationView.routeName: (ctx) => NotificationView(),
            OrderView.routeName: (ctx) => OrderView(),
            WalletHistoryView.routeName: (ctx) => WalletHistoryView(),
            WalletView.routeName: (ctx) => WalletView(),
            AddProductView.routeName: (ctx) => AddProductView(),
            OfferView.routeName: (ctx) => OfferView(),
            PrivacyPolicyView.routeName: (ctx) => PrivacyPolicyView(),
            TipsInstructionsView.routeName: (ctx) => TipsInstructionsView(),
          },
        ),
      ),
      designSize: const Size(390, 844),
    );
  }
}
