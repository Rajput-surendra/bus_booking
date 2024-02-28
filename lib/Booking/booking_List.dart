import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/Theme/colors.dart';

import 'booking_Details.dart';

class BookingList extends StatefulWidget {
  const BookingList({Key? key}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking List"),
      backgroundColor: primary,
      centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text("35 BUSES FOUND"),
            SizedBox(height: 20,),
            SizedBox(
             height: MediaQuery.of(context).size.height/1.2,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                itemCount: 25,
                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black ,),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingDetals()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("START FORM",style: TextStyle(color: primary),),
                            SizedBox(height: 3,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("18:20 - 22:20"),
                            Text("From  ₹ 22:20")
                          ],
                         ),
                           SizedBox(height: 3,),
                           Row(
                             children: [
                               Text("5h 02"),
                               Text("35 seats left")
                             ],
                           ),
                            SizedBox(height: 3,),
                            Row(
                              children: [
                             Icon(Icons.bus_alert),
                                SizedBox(width: 2,),
                                Text("SR Travels",style: TextStyle(color: blackColor,fontWeight: FontWeight.bold),)
                              ],
                            ),
                            SizedBox(height: 3,),
                            Text("A/C Seater ")

                          ],
                      ),
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
