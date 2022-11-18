

import 'package:ecom_users/pages/cart_page.dart';
import 'package:ecom_users/pages/checkout_page.dart';
import 'package:ecom_users/pages/order_successful_page.dart';
import 'package:ecom_users/pages/otp_verification_page.dart';
import 'package:ecom_users/pages/user_profile_page.dart';
import 'package:ecom_users/pages/launcher_page.dart';
import 'package:ecom_users/pages/login_page.dart';
import 'package:ecom_users/pages/order_list_page.dart';
import 'package:ecom_users/pages/product_details_page.dart';

import 'package:ecom_users/pages/veiw_product_page.dart';
import 'package:ecom_users/providers/cart_provider.dart';
import 'package:ecom_users/providers/order_provider.dart';
import 'package:ecom_users/providers/product_provider.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Ecommerce Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => const LauncherPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        OrderListPage.routeName: (context) => const OrderListPage(),
        ProductDetailsPage.routeName: (context) => const ProductDetailsPage(),
        ViewProductPage.routeName: (context) => const ViewProductPage(),
        UserProfilePage.routeName: (context) => const UserProfilePage(),
        OtpVerificationPage.routeName: (context) => const OtpVerificationPage(),
        CartPage.routeName: (context) => const CartPage(),
        CheckoutPage.routeName: (context) => const CheckoutPage(),
        OrderSuccessfulPage.routeName: (context) => const OrderSuccessfulPage(),
      },
    );
  }
}
