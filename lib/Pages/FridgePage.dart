import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/FridgePageComponents/FruitPage.dart';
import 'package:taluewapp/Pages/FridgePageComponents/OthersPage.dart';
import 'package:taluewapp/Pages/FridgePageComponents/VegetablePage.dart';
import 'package:taluewapp/Pages/FridgePageComponents/WaterPage.dart';
import './FridgePageComponents/MeatPage.dart';

class fridge_page extends StatefulWidget {
  @override
  _fridge_page createState() => _fridge_page();
}

int click;

class _fridge_page extends State<fridge_page> {

  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    click = 0;
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
              'วัตถุดิบของฉัน',
              style: TextStyle(color: Colors.white, fontSize: 35),
            )),
        Container(
          alignment: Alignment.center,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      click = 0;
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    color: click == 0 ? Color(0xffE5E5E5) :Colors.white,
                    child: Text('เนื้อ',
                        style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      click = 1;
                      _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    color: click == 1 ? Color(0xffE5E5E5) : Colors.white,
                    child: Text('ผัก',
                        style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      click = 2;
                      _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.ease);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    color: click == 2 ? Color(0xffE5E5E5) : Colors.white,
                    child: Text('ผลไม้',
                        style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      click = 3;
                      _pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.ease);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    color: click == 3 ? Color(0xffE5E5E5) : Colors.white,
                    child: Text('น้ำ',
                        style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      click = 4;
                      _pageController.animateToPage(4, duration: Duration(milliseconds: 300), curve: Curves.ease);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    color: click == 4 ? Color(0xffE5E5E5) : Colors.white,
                    child: Text('อื่นๆ',
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                meat_page(),
                veget_page(),
                fruit_page(),
                water_page(),
                others_page()
              ],
            ),
          ),
        )
      ],
    );
  }
}
