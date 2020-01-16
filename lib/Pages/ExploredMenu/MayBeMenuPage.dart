import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/HowToPage.dart';

class maybe_page extends StatefulWidget {
  @override
  _maybe_page createState() => _maybe_page();
}

class _maybe_page extends State<maybe_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  height: 120,
                  width: 160,
                  child: Image.asset(
                    'assets/menu1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'ผัดเต้าหู้มะเขือเทศ',
                            style: TextStyle(
                                color: Color(0xff914d1f), fontSize: 30),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return howto_page();
                                    }));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    color: Color(0xff914d1f),
                                    child: Text(
                                      "วิธีการทำ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
