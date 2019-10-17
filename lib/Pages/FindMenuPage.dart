import 'package:flutter/material.dart';

class findmenu_page extends StatefulWidget {
  @override
  _findmenu_page createState() => _findmenu_page();
}

class _findmenu_page extends State<findmenu_page> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 60,
            alignment: Alignment.center,
            color: Color(0xffB15B25),
            child: Text(
              'หาเมนูอาหาร..',
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
