import 'package:flutter/material.dart';
import 'RealLogin.dart';

class login_page extends StatefulWidget {
  @override
  _login_page createState() => _login_page();
}

class _login_page extends State<login_page> {
  @override
  Widget build(BuildContext context) {
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
                height: 80,
                alignment: Alignment.center,
                color: Color(0xfff3181d),
                child: Image.asset('assets/logofoodfridge.png'),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left:60,right: 60),
                        child: Image.asset(
                          'assets/fried.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>real_page()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xfff3181d),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          height: 50,
                          width: 270,
                          alignment: Alignment.center,
                          child: Text('เริ่มต้นใช้งาน',style: TextStyle(color: Colors.white,fontSize: 25),)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: _safeBottom,
              ),
            ],
          )),
    );
  }
}
