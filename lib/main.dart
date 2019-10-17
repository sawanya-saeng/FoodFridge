import 'package:flutter/material.dart';
import 'Pages/LoginPage.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'taluewFont'
      ),
      home: login_page(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
