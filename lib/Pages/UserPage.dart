import 'package:flutter/material.dart';

class user_page extends StatefulWidget {
  @override
  _user_page createState() => _user_page();
}

class _user_page extends State<user_page> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 60,
            alignment: Alignment.center,
            color: Color(0xffB15B25),
            child: Text(
              'ข้อมูลส่วนตัว',
              style: TextStyle(color: Colors.white, fontSize: 35),
            )),
        Container(
          alignment: Alignment.center,
          height: 50,
        ),
      ],
    );
  }
}
