import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/FridgePage.dart';
import 'package:taluewapp/Pages/FindMenuPage.dart';
import 'package:taluewapp/Pages/ExpirePage.dart';
import 'package:taluewapp/Pages/NotificationPage.dart';
import 'package:taluewapp/Pages/UserPage.dart';

class main_page extends StatefulWidget {
  int pageIndex;
  main_page(this.pageIndex);
  @override
  _main_page createState() => _main_page(this.pageIndex);
}

int _currentIndex = 0;
List<Widget> pages = [
  fridge_page(),
  findmenu_page(),
  expire_page(),
  noti_page(),
  user_page()
];

class _main_page extends State<main_page> {
  int pageIndex;
  _main_page(this.pageIndex);
  PageController _pageController;
  final _auth = FirebaseAuth.instance;
  bool isSignIn = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isNotification = false;

  Future checkSignIn()async{
    FirebaseUser user = await _auth.currentUser();
    if(user == null){
      setState(() {
        isSignIn = false;
      });
    }else{
      setState(() {
        isSignIn = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: this.pageIndex);

    checkSignIn().then((e){
      if(isSignIn){
        setState(() {
          _pageController.animateToPage(this.pageIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
          _currentIndex = this.pageIndex;
        });
      }else{
        setState(() {
          _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
          _currentIndex = 1;
        });
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          isNotification = true;
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _safeTop = MediaQuery.of(context).padding.top;
    double _safeBottom = MediaQuery.of(context).padding.bottom;

    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    fridge_page(),
                    findmenu_page(),
                    expire_page(),
                    noti_page(),
                    user_page(),
                  ],
                ),
              ),
              Container(
                color: Color(0xffFFA733),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    isSignIn ? Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                            _pageController.animateToPage(0, duration: Duration(milliseconds: 1), curve: Curves.ease);
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          color: _currentIndex == 0
                              ? Color(0xffB46F25)
                              : Color(0xffFFA733),
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/fridge.png')),
                              Container(
                                  child: Text(
                                'ตู้เย็น',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ):Container(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                            _pageController.animateToPage(1, duration: Duration(milliseconds: 1), curve: Curves.ease);
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 1
                              ? Color(0xffB46F25)
                              : Color(0xffFFA733),
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/diet.png')),
                              Container(
                                  child: Text(
                                'หาเมนูอาหาร',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    isSignIn ? Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 2;
                            _pageController.animateToPage(2, duration: Duration(milliseconds: 1), curve: Curves.ease);
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 2
                              ? Color(0xffB46F25)
                              : Color(0xffFFA733),
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 35,
                                child: Image.asset('assets/calendar.png'),
                              ),
                              Container(
                                  child: Text(
                                'หมดอายุ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ):Container(),
                    isSignIn ? Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isNotification = false;
                            _currentIndex = 3;
                            _pageController.animateToPage(3, duration: Duration(milliseconds: 1), curve: Curves.ease);
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 3
                              ? Color(0xffB46F25)
                              : Color(0xffFFA733),
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Container(
                                      height: 35,
                                      child: Image.asset('assets/notification.png')
                                  ),
                                  isNotification ? Container(
                                    padding: EdgeInsets.only(left: 15, right: 15),
                                    alignment: Alignment.topRight,
                                    height: 15,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      width: 15,
                                    ),
                                  ):Container(),
                                ],
                              ),
                              Container(
                                  child: Text(
                                'แจ้งเตือน',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ):Container(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 4;
                            _pageController.animateToPage(4, duration: Duration(milliseconds: 1), curve: Curves.ease);
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: _currentIndex == 4
                              ? Color(0xffB46F25)
                              : Color(0xffFFA733),
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  child: Image.asset('assets/user.png')),
                              Container(
                                  child: Text(
                                'ข้อมูลส่วนตัว',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ))
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
