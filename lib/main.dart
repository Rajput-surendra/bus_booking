import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quick_pay/BottomNavigation/Home/home.dart';
import 'package:quick_pay/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/login_navigator.dart';
import 'BottomNavigation/bottom_navigation.dart';
import 'Locale/language_cubit.dart';
import 'Locale/locales.dart';
import 'Routes/routes.dart';
import 'Theme/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
      Phoenix(
      child: BlocProvider<LanguageCubit>(
    create: (context) => LanguageCubit(),
    child: QuickPay(),
  )));
}

class QuickPay extends StatefulWidget {
  @override
  State<QuickPay> createState() => _QuickPayState();
}

class _QuickPayState extends State<QuickPay> {

  String? id;
  void checkLogin()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('id');
    print("this is is user is${id}");
  }
  @override
  void initState() {
    // TODO: implement initState
    // Timer(Duration(seconds: 3), () {
    //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));}
    // );
    super.initState();
    Future.delayed(Duration(milliseconds: 300),(){
      return checkLogin();
    });
    // Future.delayed(Duration(seconds: 2),(){
    //   print("Conditions   ${id == null || id == ""}");
    //   if(id == null || id == ""){
    //     print("this is is user is${id}");
    //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginUI()));
    //   }
    //   else{
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    //   }
    // });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(builder: (context, appLocale) {
      return MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.getSupportedLocales(),
        locale: appLocale,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home:SplashScreen()
        // id == null ||  id == "" ? LoginNavigator() : AppNavigation(),
        // routes: PageRoutes().routes(),
      );
    });
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'Auth/login_navigator.dart';
// import 'Locale/language_cubit.dart';
// import 'Locale/locales.dart';
// import 'Routes/routes.dart';
// import 'Theme/style.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   runApp(Phoenix(
//       child: BlocProvider<LanguageCubit>(
//         create: (context) => LanguageCubit(),
//         child: QuickPay(),
//       )));
// }
// class QuickPay extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LanguageCubit, Locale>(builder: (context, appLocale) {
//       return MaterialApp(
//         localizationsDelegates: [
//           const AppLocalizationsDelegate(),
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: AppLocalizations.getSupportedLocales(),
//         locale: appLocale,
//         debugShowCheckedModeBanner: false,
//         theme: appTheme,
//         home: LoginNavigator(),
//         routes: PageRoutes().routes(),
//       );
//     });
//   }
// }
