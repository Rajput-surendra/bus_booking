import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme/colors.dart';

class BookingDetals extends StatefulWidget {
  const BookingDetals({Key? key}) : super(key: key);

  @override
  State<BookingDetals> createState() => _BookingDetalsState();
}

class _BookingDetalsState extends State<BookingDetals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SR Travels"),
        backgroundColor: primary,
        centerTitle: true,),
    );
  }
}
