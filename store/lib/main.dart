import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/screens/AddProduct/addProduct.dart';
import 'package:store/screens/Invoice/SellerInvoice.dart';
import 'package:store/screens/ReportGeneration/reportHomeScreen.dart';
import 'package:store/screens/ShopDetails/shopDetails.dart';

import 'screens/AddCompany/addCompany.dart';
import 'screens/Admin/admin.dart';
import 'screens/Invoice/UploadInvoice.dart';
import 'screens/Login/login_screen.dart';
import 'screens/Signup/signup_screen.dart';
import 'screens/Welcome/welcome_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Management',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      routes: {
        "home": (context) => const WelcomeScreen(),
        "login": (context) => const LoginScreen(),
        "signup": (context) => const SignUpScreen(),
        "admin": (context) => AdminPanel(),
        "uploadInvoice": (context) => const UploadInvoiceScreen(),
        "addCompany": ((context) => CompanyEntry()),
        "addProduct": (context) => ProductEntry(),
        "sellingInvoice": (context) => const SellingInvoiceScreen(),
        "reportPanel": (context) => const ReportGenerationScreen(),
        "shopDetails": ((context) => const ShopDetailsScreen())
      },
      initialRoute: "home",
    );
  }
}
