import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/AddMenu.dart';

class user_page extends StatefulWidget {
  @override
  _user_page createState() => _user_page();
}

class _user_page extends State<user_page> {
  int _currentPage = 0;

  PageController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = PageController(initialPage: 0);
  }

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
          color: Colors.white,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueGrey),
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                ),
              ),
              Container(
                child: Text('Name',
                    style: TextStyle(color: Colors.black, fontSize: 25)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Color(0xffFCFCFC),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPage = 0;
                              _scrollController.animateToPage(0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                                color: _currentPage == 0
                                    ? Color(0xffFCFCFC)
                                    : Color(0xffE0E0E0),
                                border: Border(
                                  top: BorderSide(color: Colors.grey),
                                  right: BorderSide(color: Colors.grey),
                                  left: BorderSide(color: Colors.grey),
                                )),
                            alignment: Alignment.center,
                            height: 40,
                            child: Text(
                              'สูตรอาหารของคุณ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentPage = 1;
                              _scrollController.animateToPage(1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                                color: _currentPage == 1
                                    ? Color(0xfffcfcfc)
                                    : Color(0xffE0E0E0),
                                border: Border(
                                  top: BorderSide(color: Colors.grey),
                                  right: BorderSide(color: Colors.grey),
                                  left: BorderSide(color: Colors.grey),
                                )),
                            alignment: Alignment.center,
                            height: 40,
                            child: Text(
                              'เมนูอาหารที่บันทึกไว้',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: PageView(
                      onPageChanged: (int index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      controller: _scrollController,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return add_menu();
                                  }));
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.asset('assets/write.png'),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'เขียนสูตรอาหารเลย',
                                  style: TextStyle(
                                      color: Color(0xffA5A5A5), fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          child: ListView(
                            padding: EdgeInsets.all(20),
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
                                        'assets/write.png',
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
                                                    color: Color(0xff914d1f),
                                                    fontSize: 30),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 40,
                                                      color: Color(0xff914d1f),
                                                      child: Text(
                                                        "วิธีการทำ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Icon(
                                                      Icons.restore_from_trash,
                                                      size: 50,
                                                      color: Colors.lightGreen,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
