import 'package:flutter/material.dart';

class bin_page extends StatefulWidget {
  @override
  _bin_page createState() => _bin_page();
}

class _bin_page extends State<bin_page> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 60,
            alignment: Alignment.center,
            color: Color(0xffB15B25),
            child: Text(
              'ถังขยะ',
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
