import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/FridgePage.dart';
import 'package:taluewapp/Pages/FindMenuPage.dart';
import 'package:taluewapp/Pages/ExpirePage.dart';
import 'package:taluewapp/Pages/BinPage.dart';
import 'package:taluewapp/Pages/UserPage.dart';

class main_page extends StatefulWidget {
  @override
  _main_page createState() => _main_page();
}

int _currentIndex = 0;
List<Widget> pages = [fridge_page(),findmenu_page(),expire_page(),bin_page(),user_page()];

class _main_page extends State<main_page> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _safeTop = MediaQuery.of(context).padding.top;
    double _safeBottom = MediaQuery.of(context).padding.bottom;

    // TODO: implement build
    return Scaffold(
      body: Container(
          color: Color(0xffFCFCFC),
          child: Column(
            children: <Widget>[
              Container(
                height: _safeTop,
                color: Color(0xfff3181d),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                color: Color(0xfff3181d),
                child: Image.asset('assets/logofoodfridge.png'),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: pages[_currentIndex],
                ),
              ),
              Container(
                color: Color(0xffFFA733),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          color: _currentIndex == 0 ? Color(0xffB46F25) : Color(0xffFFA733),
                          height:80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/fridge.png')
                              ),
                              Container(
                                  child: Text('ตู้เย็น',style: TextStyle(color: Colors.white,fontSize: 15),)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 1 ? Color(0xffB46F25) : Color(0xffFFA733),
                          height:80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/diet.png')
                              ),
                              Container(
                                  child: Text('หาเมนูอาหาร',style: TextStyle(color: Colors.white,fontSize: 15),)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _currentIndex = 2;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 2 ? Color(0xffB46F25) : Color(0xffFFA733),
                          height:80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/calendar.png')
                              ),
                              Container(
                                  child: Text('หมดอายุ',style: TextStyle(color: Colors.white,fontSize: 15),)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _currentIndex = 3;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 3 ? Color(0xffB46F25) : Color(0xffFFA733),
                          height:80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/delete.png')
                              ),
                              Container(
                                  child: Text('ถังขยะ',style: TextStyle(color: Colors.white,fontSize: 15),)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _currentIndex = 4;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 4 ? Color(0xffB46F25) : Color(0xffFFA733),
                          height:80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/user.png')
                              ),
                              Container(
                                  child: Text('ข้อมูลส่วนตัว',style: TextStyle(color: Colors.white,fontSize: 15),)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
              ),


              Container(
                height: _safeBottom,
                color: Color(0xffFFA733),
              ),
            ],
          )),
    );
  }
}
