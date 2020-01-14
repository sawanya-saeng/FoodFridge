import 'package:flutter/material.dart';
import 'MainPage.dart';

class findmenu_page extends StatefulWidget {
  @override
  _findmenu_page createState() => _findmenu_page();
}

class _findmenu_page extends State<findmenu_page> {
  double _navHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: Container(
//                color: Colors.grey,

              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                AnimatedContainer(
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 300),
                  color: Colors.red,
                  height: _navHeight,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return main_page();
                              }));
                            },
                            child: Container(
                              color: Color(0xff8B451A),
                              child: Text(
                                'เลือกจากวัตถุดิบหลัก',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                              ),
                              alignment: Alignment.center,
                              height: 60,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Color(0xff8B451A),
                            child: Text('เลือกโดยกำหนดเอง',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 21),
                            ),
                            alignment: Alignment.center,
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      color: Color(0xffB15B25),
                      child: Text(
                        'หาเมนูอาหาร',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_navHeight == 0.0) {
                            _navHeight = 120;
                          } else {
                            _navHeight = 0.0;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        height: 60,
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
