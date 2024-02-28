
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quick_pay/BottomNavigation/Account/my_profile.dart';
import 'package:quick_pay/BottomNavigation/Home/Pages/add_money.dart';

import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Booking/booking_List.dart';
import '../../model/RechrgeModel.dart';
import '../../model/getbannermodel.dart';
import '../../model/userprofile.dart';
import '../Account/notifications_page.dart';
import '../Scan/scan_page.dart';
import 'Pages/MyWallet.dart';
import 'Pages/book_ticket.dart';
import 'Pages/get_payment.dart';
import 'Pages/phone_recharge.dart';
import 'Pages/transactions_page.dart';
import 'package:http/http.dart'as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Payment {
  String image;
  String? title;
  Function onTap;
  Payment(this.image, this.title, this.onTap);
}
class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  int currentindex=0;

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;
  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );
    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }
    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }
  Getbannermodel? getbannermodel;
  getBanner() async {
    var headers = {
      'Cookie': 'ci_session=83721b31871c96522e60f489ca4e917362cdb60c'
    };
    var request = http.Request('GET', Uri.parse('${ApiService.getSlider}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('_____fdgggggfdg_____${response.statusCode}_________');
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = Getbannermodel.fromJson(json.decode(finalResponse));
      print("aaaaaaaa>>>>>>>>>>>>>$jsonResponse");
      setState(() {
        getbannermodel = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }
  String? username;
  String? address;
  Userprofile? getprofile;
  getuserProfile() async{
    print("This is user profile${username}");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id  =  preferences.getString('id');
    username  =  preferences.getString('username');
    address =preferences.getString("address");
    var headers = {
      'Cookie': 'ci_session=7ff77755bd5ddabba34d18d1a5a3b7fbca686dfa'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${ApiService.getUserProfile}"));
    request.fields.addAll({
      'user_id': id.toString()
    });
    print("____________________${id}");
    print("request-----------__________${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("This is user request-----------${response.statusCode}");
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = Userprofile.fromJson(json.decode(finalResult));
      print("this is final resultsssssssss${jsonResponse}");

      setState(() {
        getprofile = jsonResponse;
      });
    }
    else {

      print(response.reasonPhrase);
    }
  }
  RechrgeModel? rechargecard;
  RechargeCard() async {
    var headers = {
      'Cookie': 'ci_session=08b6c6afe557dc70d0ed3fb13b09bda9d8e3e0f2'
    };
    var request = http.Request('POST', Uri.parse('${ApiService.getServices}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalrespionse = await response.stream.bytesToString();
      final jsonresponse = RechrgeModel.fromJson(json.decode(finalrespionse));

      setState(() {
        rechargecard = jsonresponse;
      });
      print(" Rechargemodelllllllllllllllll${finalrespionse}");
      print("Succes>>>>>>>>>>>>>>>>>>>>>>>>>${jsonresponse}");

    }
    else {
      print(response.reasonPhrase);
    }

  }
  void initState(){
    super.initState();
    getuserProfile();
    getBanner();
    RechargeCard();
  }
  Future _refresh() {
    return callAPI();
  }
 callAPI(){
   getuserProfile();
   getBanner();
   RechargeCard();
 }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  @override
  void dispose() {
    super.dispose();
    _anchoredBanner?.dispose();
  }
  List<Map<String, dynamic>> newsList = [
    {"image": "assets/imgs/Pay or Send.png", "title": "Pay Or Send",},
    {"image": "assets/imgs/wallet.png", "title": "My wallet",},
    {"image": "assets/imgs/Add Money.png", "title": "Add Money",},
    {"image": "assets/imgs/Get Payment.png", "title": "QR Code",},
    {"image": "assets/imgs/Add Money.png", "title": "Transaction History",},
    // {"image": "assets/imgs/Editorial1.png", "title": "Editorial",},
    // {"image": "assets/imgs/Awareness inputs.png", "title": "Awareness Inputs",},
  ];
  List<Map<String, dynamic>> newsList2 = [
    {"image": "assets/imgs/Recharge.png", "title": "Recharge",},
    {"image": "assets/imgs/Electricity.png", "title": "Electricity",},
    {"image": "assets/imgs/Water Bill.png", "title": " Water Bill",},
    {"image": "assets/imgs/Gas Bill.png", "title": "Gas Bil",},
    {"image": "assets/imgs/Recharge.png", "title": "Dth",},
    {"image": "assets/imgs/See all.png", "title": "See all",},
    // {"image": "assets/imgs/Awareness inputs.png", "title": "Awareness Inputs",},
  ];
  List<Map<String, dynamic>> banner = [
    {"image": "assets/imgs/BANNER1.png",},
    {"image": "assets/imgs/BANNER2.png",},
  ];

  TextEditingController fromController = new TextEditingController();
  TextEditingController toController = new TextEditingController();
  int _currentPost =  0;
  List<Widget> _buildDots() {
    List<Widget> dots = [];
    if(getbannermodel == null){
    }
    else {
      for (int i = 0; i < getbannermodel!.data!.length; i++) {
        dots.add(
          Container(
            margin: EdgeInsets.all(1.5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPost == i
                    ? primary
                    : sconddary
            ),
          ),
        );
      }
    }
    return dots;
  }

  // final formats = DateFormat("yyyy-MM-dd");
  late DateTime journeys;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Scaffold(
          key: _refreshIndicatorKey,
          backgroundColor: background,
          body:
          SingleChildScrollView(
            child: getprofile==null || getprofile?.data == ""? Center(child: CircularProgressIndicator(color: primary,),):
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height/10.7,
                  child: Stack(
                    children: [
                      Container(
                        height:MediaQuery.of(context).size.height/0.0,
                        width:MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color:primary,
                            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),
                                bottomRight:Radius.circular(20))),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 0, right: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage()));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(70),
                                              child:
                                              //Image.asset("assets/imgs/Layer 1753.png",fit: BoxFit.fill,),
                                               Image.network("${getprofile?.data?.profilePic}")
                                            ),
                                          ),
                                          // Column(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     Container(
                                          //       width:50,
                                          //         child:
                                          //         Text("${getprofile?.data?.first.username}" ?? " ",style: TextStyle(color: Colors.white,fontSize: 15,overflow: TextOverflow.ellipsis))
                                          //     ),
                                          //     // Container(
                                          //     //   width: 80,
                                          //     //   child: Text(address?? "" ,style: TextStyle(color: Colors.white,fontSize: 14, overflow: TextOverflow.ellipsis,
                                          //     //   ),
                                          //     //   ),
                                          //     // ),
                                          //   ],
                                          // ),
                                          // Image.asset("assets/homelogo.png", scale: 8.9),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (c)=> NotificationsPage()));
                                      },
                                      child: Icon(Icons.notifications,color: Colors.white,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   top: 85,
                      //   left: 20,
                      //   right: 20,
                      //   child: Container(
                      //     height: 45,
                      //     width:MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(8)),
                      //     child: Center(child:TextFormField(
                      //       decoration: InputDecoration(
                      //           border: InputBorder.none,
                      //           prefixIcon: Icon(Icons.search,color: Colors.grey,),
                      //           hintText: 'Search here'),style: TextStyle(color: Colors.grey),)
                      //     ),
                      //   ),
                      // )
                    ],),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child:
                  // getbannermodel == null? Center(child: CircularProgressIndicator(
                  //   color: primary,
                  // )):
                  _CarouselSlider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  _buildDots(),),
                Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Book Bus Tickets",style: TextStyle(color: blackColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            ),
                            Card(
                              elevation: 2.0,
                              child: Padding(padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                         border: InputBorder.none,
                                            icon: Icon(Icons.directions_bus_outlined),
                                            hintText: "From"
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Divider(thickness: 1,color: Colors.black,),

                                      ],
                                    ),
                                    // WidgetComponent.formField(
                                    //   borders: InputBorder.none,
                                    //   label: "From",
                                    //   prefix: Icon(Icons.location_city),
                                    //   controllers: fromController,
                                    //   valids: (value) {  },
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(Icons.directions_bus_outlined),
                                            hintText: "To"
                                        ),
                                      ),
                                    ),
                                    Divider(thickness: 1,color: blackColor,),
                                    InkWell(
                                      onTap: ()=>_selectDate(context),
                                      child: Card(
                                          elevation: 2.0,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Journey Date"),
                                                DateTimeFormField(
                                                  decoration: const InputDecoration(
                                                    enabledBorder: InputBorder.none,
                                                    hintStyle: TextStyle(color: Colors.black45),
                                                    errorStyle: TextStyle(color: Colors.redAccent),
                                                    border: OutlineInputBorder(),
                                                    suffixIcon: Icon(Icons.event_note),
                                                    // labelText: 'Only time',
                                                  ),
                                                  mode: DateTimeFieldPickerMode.date,
                                                  autovalidateMode: AutovalidateMode.always,
                                                  validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                                                  onDateSelected: (DateTime value) {
                                                    print(value);
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Divider(thickness: 1,color: Colors.black,),
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingList()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child:  Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [primary, primary],
                                                  stops: [0, 1]), color: primary),
                                          child:
                                          // isloader == true ? Center(child: CircularProgressIndicator(color: Colors.white,),) :
                                          Center(
                                              child: Text("SEARCH BUSES", style: TextStyle(fontSize: 18, color: Colors.white))),
                                        )
                                      ),
                                    ),
                                    // WidgetComponent.formField(
                                    //   borders: InputBorder.none,
                                    //   label: "To",
                                    //   prefix: Icon(Icons.location_city),
                                    //   controllers: toController, valids: (value) {  },
                                    // ),
                                    SizedBox(height: 8.0,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  newsCard(int i){
    return InkWell(
      onTap: (){
        if(i == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (C) => ScanQRPage()));
        }else if(i ==1){
          Navigator.push(
              context, MaterialPageRoute(builder: (C) => MyWallet()));
        }
        else if(i == 2){
          Navigator.push(
              context, MaterialPageRoute(builder: (C) => AddMoneyUI()));
        }
        // else if(i == 3){
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (C) => GetPaymentPage()));
        // }
        else {
          Navigator.push(
              context, MaterialPageRoute(builder: (C) => TransactionPage()));
        }
      },
      child: Container(
        height: 150,
        width: 100,
        child: Card(
            margin: EdgeInsets.all(10.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    children:[
                      Image.asset('${newsList[i]['image']}',height: 45),
                    ]
                ),
                SizedBox(height: 5,),
                Text("${newsList[i]['title']}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),)
              ],
            )),
      ),
    );
  }
  newsCard2(int i){
    return
      rechargecard?.data?[i].status == "1" ?
      Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: (){
          if(i == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (C) => PhoneRechargePage()));
          }
          // else if(i ==1){
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (C) => MyProfilePage()));
          //
          // }else if(i == 2){
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (C) => MyProfilePage()));
          // } else if (i==3){
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (C) => MyProfilePage()));
          // } else if (i==4){
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (C) => MyProfilePage()));
          // } else {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (C) => MyProfilePage()));
          // }
        },
        child: Container(
          margin:EdgeInsets.all(2) ,
          child: Card(
            elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                      children:[
                        Image.network('${rechargecard?.data?[i].image}',fit: BoxFit.fill,),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("${rechargecard?.data?[i].d2h}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
                  )
                ],
              )),
        ),
      ),
    )
    : const SizedBox.shrink();
  }
  _RechargCard2(){
    return  SizedBox(
      height:MediaQuery.of(context).size.height/2.6,
      width:MediaQuery.of(context).size.width,
      child:  rechargecard == null || rechargecard == "" ? Center(child: CircularProgressIndicator(color: primary,),)
     : GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:3,
            childAspectRatio: (1 / 1.1),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        itemBuilder:(context, index) {
          return newsCard2(index);
        },
        itemCount: rechargecard?.data?.length,
      ),
    );
  }
  _CarouselSlider(){
    return  Padding(
      padding: EdgeInsets.only(
          top: 18, bottom: 18, left: 10, right: 10),
      child: getbannermodel == null || getbannermodel == "" ? Center(child: CircularProgressIndicator(),):
      CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration:
          Duration(milliseconds: 500),
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
          height: 180,
          onPageChanged: (position, reason) {
            setState(() {
              currentindex = position;
            });
            print(reason);
            print(CarouselPageChangedReason.controller);
          },
        ),
        items: getbannermodel?.data?.map((val) {
          print('___dsfsdfsdfsdgs_______${val.image}_________');
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20)),
            // height: 180,
            // width: MediaQuery.of(context).size.width,
            child: ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
                child: Image.network(
                  "${val.image}",
                  fit: BoxFit.fill,
                )),
          );
        }).toList(),
      ),
    );

  }
}

