import 'package:flutter/material.dart';
import './FridgePageComponents/AddPage.dart';

class howto_page extends StatefulWidget {
  @override
  _howto_page createState() => _howto_page();
}

class _howto_page extends State<howto_page> {
  int _currentPage = 0;

  PageController _scrollController;

  List<Map<String, dynamic>> demoData1 = [
    {
      "name": "ไก่",
      "value": new TextEditingController(text: "2"),
      "unit": "กรัม"
    },
    {
      "name": "ไข่",
      "value": new TextEditingController(text: "4"),
      "unit": "ฟอง"
    },
    {
      "name": "หมู",
      "value": new TextEditingController(text: "1"),
      "unit": "กิโล"
    },
    {
      "name": "ผัก",
      "value": new TextEditingController(text: "1"),
      "unit": "เม็ด"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = PageController(initialPage: 0);
  }

  Future deleteIngredientManual() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 270,
              width: 330,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: Text("รายการวัตถุดิบที่คงเหลือ"),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: demoData1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                        "${index + 1}. ${demoData1[index]["name"]}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              int tmp = int.parse(
                                                  demoData1[index]["value"]
                                                      .text);
                                              tmp++;
                                              demoData1[index]["value"].text =
                                                  tmp.toString();
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                        Container(
                                            height: 25,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            alignment: Alignment.center,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText: null),
                                              controller: demoData1[index]
                                                  ["value"],
                                            )),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              int tmp = int.parse(
                                                  demoData1[index]["value"]
                                                      .text);
                                              tmp--;
                                              demoData1[index]["value"].text =
                                                  tmp.toString();
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Icon(Icons.remove),
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(
                                              "${demoData1[index]["unit"]}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Icon(Icons.not_interested),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Icon(Icons.check_circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future deleteIngredientAuto() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 270,
              width: 330,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: Text("รายการวัตถุดิบที่คงเหลือ"),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: demoData1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                        "${index + 1}. ${demoData1[index]["name"]}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                            height: 25,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            alignment: Alignment.center,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText: null),
                                              controller: demoData1[index]
                                                  ["value"],
                                            )),
                                        Container(
                                          width: 40,
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(
                                              "${demoData1[index]["unit"]}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Icon(Icons.not_interested),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Icon(Icons.check_circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

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
                    'ขั้นตอนการทำ',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
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
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 180,
                    child: Image.asset('assets/menu1.jpg'),
                  ),
                  Container(
                    child: Text('ผัดเต้าหู้มะเขือเทศ',
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
                                  'ส่วนประกอบ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
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
                                  'วิธีการทำ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentPage = 2;
                                  _scrollController.animateToPage(2,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    color: _currentPage == 2
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
                                  'ให้คะแนน',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: PageView(
                          onPageChanged: (int index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          controller: _scrollController,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 35, top: 25),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(right: 85),
                                          child: Text(
                                            'เต้าหู้ \n'
                                            'ไข่ \n'
                                            'มะเขือเทศ\n'
                                            'ซอส\n',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '2 ชิ้น \n'
                                            '2 ฟอง \n'
                                            '2 ลูก \n'
                                            '2 ช้อนโต๊ะ \n',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: ListView(
                                padding: EdgeInsets.all(20),
                                children: <Widget>[
                                  Container(
                                    child: Row(children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15, top: 15, right: 15),
                                        child: Text(
                                          '1. ตั้งกะทะใส่น้ำมันลงไปให้ร้อน\n'
                                          '2. ใส่กะเทียมผัดพอเหลืองหอม\n'
                                          '3. ใส่เต้าหู้ลงไปผัด ปรุงรสด้วยซอสเห็ดหอม \n'
                                          '4. ใส่มะเขือเทศ ต้นหอมผัดพอเฉา แล้วปิดไฟทันที\n',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 19),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(left: 20, top: 20, right: 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom:
                                          BorderSide(color: Color(0xffEDEDED)),
                                    )),
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blueGrey),
                                            width: 80,
                                            child: Icon(
                                              Icons.people,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 85),
                                          child: Text(
                                            'taluew',
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom:
                                          BorderSide(color: Color(0xffEDEDED)),
                                    )),
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blueGrey),
                                            width: 80,
                                            child: Icon(
                                              Icons.people,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 85),
                                          child: Text(
                                            'taluew',
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
                                        ),
                                        Container(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow),
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
            ),
            GestureDetector(
              onTap: () {
                deleteIngredientAuto();
              },
              child: Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                height: 51,
                decoration: BoxDecoration(
                  color: Color(0xff5A0000),
                ),
                child: Text(
                  "ลบจำนวนวัตถุดิบออก ตามสูตร",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                deleteIngredientManual();
              },
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 15),
                alignment: Alignment.center,
                height: 51,
                decoration: BoxDecoration(
                  color: Color(0xffB50000),
                ),
                child: Text(
                  "ลบจำนวนวัตถุดิบออก โดยกำหนดเอง",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
