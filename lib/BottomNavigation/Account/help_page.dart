import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/Locale/locales.dart';
import 'package:quick_pay/Theme/colors.dart';

class NeedHelpPage extends StatefulWidget {
  @override
  _NeedHelpPageState createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends State<NeedHelpPage> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    List<String?> _faqs = [
      locale.faq1,
      locale.faq2,
      locale.faq3,
      locale.faq4,
      locale.faq5,
      locale.faq6,
      locale.faq7,
      locale.faq8,
      locale.faq1,
      locale.faq2,
      locale.faq3,
      locale.faq4,
      locale.faq5,
      locale.faq6,
      locale.faq7,
      locale.faq8,
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: Text(

          locale.help!,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700, fontSize: 20,color: white),
        ),
        iconTheme: IconThemeData(color: white),
      ),
      body:FadedSlideAnimation(
    child:  Padding(
      padding:
      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16,top: 40),
      child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',style: TextStyle(fontSize: 15),),
    ),

        beginOffset: Offset(0, 0.3),
    endOffset: Offset(0, 0),
    slideCurve: Curves.linearToEaseOut,
    ),

    // FadedSlideAnimation(
    //     child: ListView.builder(
    //         physics: BouncingScrollPhysics(),
    //         padding: EdgeInsets.symmetric(vertical: 16),
    //         itemCount: _faqs.length,
    //         itemBuilder: (context, index) {
    //           return Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
    //             child: Text(
    //               _faqs[index]!,
    //               style: Theme.of(context)
    //                   .textTheme
    //                   .bodyText2!
    //                   .copyWith(fontSize: 17),
    //             ),
    //           );
    //         }),
    //     beginOffset: Offset(0, 0.3),
    //     endOffset: Offset(0, 0),
    //     slideCurve: Curves.linearToEaseOut,
    //   ),
    );
  }
}
