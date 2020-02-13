import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/ChooseComponent/MeatChoosePage.dart';

class choose_page extends StatefulWidget {
  @override
  _choose_page createState() => _choose_page();
}

class _choose_page extends State<choose_page> {
  int click;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    click = 0;
  }

  List<Widget> pages = [meat_choose_page()];

  @override
  Widget build(BuildContext context) {
    double _safeTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
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
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  color: Color(0xffB15B25),
                  child: Text(
                    'วัตถุดิบของฉัน',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop({"isSearched": true});
                        },
                        child: Container(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          click = 0;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        color: click == 0 ? Color(0xffE5E5E5) : Colors.white,
                        child: Text('เนื้อ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          click = 1;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        color: click == 1 ? Color(0xffE5E5E5) : Colors.white,
                        child: Text('ผัก',
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          click = 2;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        color: click == 2 ? Color(0xffE5E5E5) : Colors.white,
                        child: Text('ผลไม้',
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          click = 3;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        color: click == 3 ? Color(0xffE5E5E5) : Colors.white,
                        child: Text('น้ำ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          click = 4;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        color: click == 4 ? Color(0xffE5E5E5) : Colors.white,
                        child: Text('อื่นๆ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: pages[0],
              ),
            )
          ],
        ),
      ),
    );
  }
}
