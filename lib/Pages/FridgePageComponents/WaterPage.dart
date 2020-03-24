import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';
import 'AddPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:date_calc/date_calc.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class water_page extends StatefulWidget {
  @override
  _water_page createState() => _water_page();
}
int click;

class _water_page extends State<water_page> with TickerProviderStateMixin{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  List<DocumentSnapshot> ingres;
  LoadingProgress _loadingProgress;
  AnimationController _animationController;
  bool isLoading = false;
  List<bool> expandList = [];
  ScrollController _scrollController;
  final format = DateFormat('yyyy-MM-dd');
  List<Map<String, dynamic>> items = [];

  Future getMeat() async {
    FirebaseUser user = await _auth.currentUser();
    List<DocumentSnapshot> tmp;
    _db.collection('Fridge').where('uid', isEqualTo: user.uid).where('type', isEqualTo:'water').orderBy('date', descending: false).snapshots().listen((docs) {
      tmp = docs.documents;
      setState(() {
        ingres = tmp;
        items.clear();
        for(int i=0; i<ingres.length; i++){
          bool isHas = checkMember(ingres[i].data['name'])['isHas'];
          int index = checkMember(ingres[i].data['name'])['index'];
          if(isHas){
            items[index]['id'].add(ingres[i].documentID);
            items[index]['num'].add(ingres[i].data['num']);
            items[index]['expire'].add(ingres[i]['date'] == null ? 'ไม่มีกำหนด':'${calculateDate(format.format(ingres[i]['date'].toDate()))} วัน');
            items[index]['unit'].add(ingres[i].data['unit']);
            items[index]['date'].add(ingres[i].data['date']);
          }else{
            items.add({
              'id': [ingres[i].documentID],
              'name': ingres[i].data['name'],
              'num': [ingres[i].data['num']],
              'expire': [ingres[i].data['date'] == null ? 'ไม่มีกำหนด':'${calculateDate(format.format(ingres[i].data['date'].toDate()))} วัน'],
              'unit': [ingres[i].data['unit']],
              'date': [ingres[i].data['date']]
            });
          }
        }
        print(items);
      });
    });
  }

  Map<String, dynamic> checkMember(String value){
    for(int i=0; i<items.length; i++){
      if(items[i]['name'] == value){
        return {
          'isHas': true,
          'index': i
        };
      }
    }
    return {
      'isHas': false,
      'index': null
    };
  }

  Future deleteItem(String itemId) async{
    setState(() {
      isLoading = true;
    });
    await _db.collection('Fridge').document(itemId).delete();
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingProgress = new LoadingProgress(_animationController);
    _scrollController = new ScrollController();
    getMeat();
  }


  calculateDate(String date1){
    List<String> dateList = date1.split('-');

    if(DateTime.now().year > int.parse(dateList[0])){
      return 0;
    }

    if(DateTime.now().month > int.parse(dateList[1]) && DateTime.now().year == int.parse(dateList[0])){
      return 0;
    }

    if(DateTime.now().day > int.parse(dateList[2]) && DateTime.now().month == int.parse(dateList[1]) && DateTime.now().year == int.parse(dateList[0])){
      return 0;
    }

    DateCalc date = DateCalc.fromDateTime(new DateTime.now());
    int diff = date.differenceValue(date: DateTime(int.parse(dateList[0]), int.parse(dateList[1]), int.parse(dateList[2])+1), type: DateType.day);

    return diff;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading ? _loadingProgress.getSubWidget(context) : ingres != null ? ingres.length != 0 ? Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 1),
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Color(0xffC3C3C3),
                      alignment: Alignment.center,
                      child: Text('วัตถุดิบ',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Color(0xffE58200),
                      alignment: Alignment.center,
                      child: Text('คงเหลือ',
                        style: TextStyle(
                            fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Color(0xffE58200),
                      alignment: Alignment.center,
                      child: Text(
                        'วันที่เหลือ',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: items == null ? 0 : items.length,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        expandList.add(false);
                        if(items[index]['num'].length > 1){
                          return Stack(
                              children: List.generate(items[index]['num'].length, (int jdex){
                                return Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onLongPress: (){
                                        showDialog(context: context,builder: (context){
                                          return PlatformAlertDialog(
                                            title: Text('ยืนยันการลบหรือไม่?'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('หากลบวัตถุดิบจะเอากลับมาไม่ได้แล้วนะ!!'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              PlatformDialogAction(
                                                child: Text('ยกเลิก'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              PlatformDialogAction(
                                                child: Text('ตกลง'),
                                                onPressed: () {
                                                  deleteItem(items[index]['id'][jdex]);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: expandList[index] == true ? double.parse((100*(items[index]['num'].length - (jdex+1))).toString()) : 0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 100,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 4,
                                                    child: Container(
                                                      color: Color(0xffFCFCFC),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        items[index]['name'],
                                                        style: TextStyle(fontSize: 25),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      color: Color(0xffFC9002),
                                                      alignment: Alignment.center,
                                                      child: Text(items[index]['num'][jdex].toString(),
                                                        style: TextStyle(
                                                            fontSize: 25, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Stack(
                                                          alignment: Alignment.bottomCenter,
                                                          children: <Widget>[
                                                            Container(
                                                              color: Color(0xffFFA733),
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                items[index]['expire'][jdex],
                                                                style: TextStyle(
                                                                    fontSize: 25,
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment.center,
                                                              height: 30,
                                                              child: Text(
                                                                items[index]['date'][jdex] == null ? 'ไม่มีกำหนด':'${items[index]['date'][jdex].toDate().day.toString()}/${items[index]['date'][jdex].toDate().month.toString()}/${items[index]['date'][jdex].toDate().year.toString()}',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.white),
                                                              ),
                                                              color: Color(0xffFC9002),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    jdex == 0 ? GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          expandList[index] = !expandList[index];
//                                        if(expandList[index]){
//                                          _scrollController.animateTo(_scrollController.position.pixels + 100, duration: Duration(milliseconds: 300), curve: Curves.ease);
//                                        }else{
//                                          _scrollController.animateTo(_scrollController.position.pixels - 100, duration: Duration(milliseconds: 300), curve: Curves.ease);
//                                        }
                                        });
                                      },
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey)
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(expandList[index] ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      ),
                                    ):Container()
                                  ],
                                );
                              })
                          );
                        }
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return add_page('water', true, items[index]['id'][0]);
                            }));
                          },
                          onLongPress: (){
                            showDialog(context: context,builder: (context){
                              return PlatformAlertDialog(
                                title: Text('ยืนยันการลบหรือไม่?'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('หากลบวัตถุดิบจะเอากลับมาไม่ได้แล้วนะ!!'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  PlatformDialogAction(
                                    child: Text('ยกเลิก'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  PlatformDialogAction(
                                    child: Text('ตกลง'),
                                    onPressed: () {
                                      deleteItem(items[index]['id'][0]);
                                    },
                                  )
                                ],
                              );
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 100,
                            color: Colors.green,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    color: Color(0xffFCFCFC),
                                    alignment: Alignment.center,
                                    child: Text(
                                      items[index]['name'],
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    color: Color(0xffFC9002),
                                    alignment: Alignment.center,
                                    child: Text(
                                      items[index]['num'][0].toString() +
                                          ' ' +
                                          items[index]['unit'][0],
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          Container(
                                            color: Color(0xffFFA733),
                                            alignment: Alignment.center,
                                            child: Text(
                                              items[index]['expire'][0],
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            child: Text(
                                              items[index]['date'][0] == null ? 'ไม่มีกำหนด':'${items[index]['date'][0].toDate().day.toString()}/${items[index]['date'][0].toDate().month.toString()}/${items[index]['date'][0].toDate().year.toString()}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                            color: Color(0xffFC9002),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return add_page('water');
                }));
              },
              child: Container(
                alignment: Alignment.center,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.add,
                        size: 25,
                      ),
                    ),
                    Container(
                      child: Text(
                        "เพิ่ม",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    ):Column(
      children: <Widget>[
        Expanded(
          child: Container(
              alignment: Alignment.center,
              child: Text("ไม่มีวัตถุดิบ",style: TextStyle(fontSize: 25),)
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return add_page('water');
            }));
          },
          child: Container(
            alignment: Alignment.center,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.add,
                    size: 25,
                  ),
                ),
                Container(
                  child: Text(
                    "เพิ่ม",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ):Column(
      children: <Widget>[
        Expanded(
          child: Container(
              alignment: Alignment.center,
              child: Text("ไม่มีวัตถุดิบ",style: TextStyle(fontSize: 25),)
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return add_page('water');
            }));
          },
          child: Container(
            alignment: Alignment.center,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.add,
                    size: 25,
                  ),
                ),
                Container(
                  child: Text(
                    "เพิ่ม",
                    style: TextStyle(fontSize: 25),
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
