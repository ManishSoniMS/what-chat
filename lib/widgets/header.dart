import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  static const String top = "assets/images/top.png";
  static const String left = "assets/images/left.png";
  static const String right = "assets/images/right.png";
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: deviceWidth,
          alignment: Alignment.topLeft,
          child: Image.asset(
            top,
            width: deviceWidth * 0.489,
            height: deviceHeight * 0.148,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              right,
              height: deviceHeight * 0.195,
              width: deviceWidth * 0.095,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "WhatChat",
                style: GoogleFonts.poppins(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              left,
              height: deviceHeight * 0.275,
              width: deviceWidth * 0.17,
            ),
          ],
        ),
      ],
    );
  }
}
