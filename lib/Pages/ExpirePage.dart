import 'package:flutter/material.dart';

class expire_page extends StatefulWidget {
  @override
  _expire_page createState() => _expire_page();
}

class _expire_page extends State<expire_page> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 60,
            alignment: Alignment.center,
            color: Color(0xffB15B25),
            child: Text(
              'หมดอายุ',
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
