import 'package:date_calc/date_calc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:taluewapp/Services/Ingredient.dart';
import 'package:provider/provider.dart';

class fruit_choose_page extends StatefulWidget {
  @override
  _fruit_choose_page createState() => _fruit_choose_page();
}

int click;

class _fruit_choose_page extends State<fruit_choose_page> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  List<DocumentSnapshot> ingres;
  Ingredient ingredient;
  bool isLoaded = false;
  Ingredient _ingredient;
  final format = DateFormat('yyyy-MM-dd');
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> calculatedItems = [];

  Future getMeat() async {
    FirebaseUser user = await _auth.currentUser();
    List<DocumentSnapshot> tmp;
    _db.collection('Fridge')
        .where('uid', isEqualTo: user.uid)
        .where('type', isEqualTo:'fruit')
        .snapshots()
        .listen((docs) {
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

        for(int i=0; i<items.length; i++){
          if(items[i]['num'].length > 1){
            double weightSum = 0;
            Timestamp latestDate;
            int min = calculateDate(format.format(items[i]['date'][0].toDate()));
            for(int j=0;j<items[i]['num'].length;j++){
              double otherWeight = double.parse(items[i]['num'][j].toString());
              if(items[i]['unit'][0] != items[i]['unit'][j]){
                otherWeight = toGrum(double.parse(items[i]['num'][j].toString()), items[i]['unit'][0]);
              }
              weightSum += otherWeight;
            }

            for(int j=0;j<items[i]['date'].length;j++){
              if(items[i]['date'][j] == null){
                continue;
              }
              if(min >= calculateDate(format.format(items[i]['date'][j].toDate()))){
                min = calculateDate(format.format(items[i]['date'][j].toDate()));
                latestDate = items[i]['date'][j];
              }
            }

            items[i]['num'] = [weightSum];
            items[i]['date'] = [latestDate];
          }
          calculatedItems.add(items[i]);
        }

        print(calculatedItems);
      });
    });
  }

  double toGrum(double num, String unit) {
    double base=1;

    if(unit == "กิโล"){
      base = 1000;
    }
    if(unit == "ฟอง"){
      base = 50;
    }
    if(unit == "ช้อนโต๊"){
      base = 12.5;
    }

    return num*base;
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

  Map<String, String> ingredientToFind = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMeat();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(!isLoaded){
      _ingredient = Provider.of<Ingredient>(context);
      isLoaded = true;
    }
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
    return Padding(
      padding: EdgeInsets.all(20),
      child: ingres != null ? ingres.length != 0 ? Container(
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
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                ],
                              ),
                            ),
                            Container(
                              child: Text('วัตถุดิบ',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
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
                        itemCount: calculatedItems == null ? 0 : calculatedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                ingredientToFind.clear();
                                ingredientToFind.addAll({
                                  'name': calculatedItems[index]['name'],
                                  'num': calculatedItems[index]['num'][0].toString(),
                                  'unit': calculatedItems[index]['unit'][0]
                                });
                                _ingredient.setIngredient(ingredientToFind);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2),
                              height: 100,
                              color: Color(0xffFC9002),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      color: Color(0xffECECEC),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 20,right: 20),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 18,
                                                  width: 18,
                                                  decoration: BoxDecoration(
                                                      color: ingredientToFind['name'] == calculatedItems[index]['name'] ? Colors.red : Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.red)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              calculatedItems[index]['name'],
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 25),
                                          color: Color(0xffFC9002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            ((double.parse(calculatedItems[index]['num'][0].toString())).toInt()).toString(),
                                            style: TextStyle(
                                                fontSize: 25, color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          color: Color(0xffFC9002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            calculatedItems[index]['unit'][0],
                                            style: TextStyle(
                                                fontSize: 19, color: Colors.white),
                                          ),
                                        ),
                                      ],
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
                                                calculatedItems[index]['date'][0] == null ? 'ไม่มีกำหนด':'${calculateDate(format.format(calculatedItems[index]['date'][0].toDate()))} วัน',
                                                style: TextStyle(
                                                    fontSize: 21,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              child: Text(
                                                calculatedItems[index]['date'][0] == null ? 'ไม่มีกำหนด':'${calculatedItems[index]['date'][0].toDate().day.toString()}/${calculatedItems[index]['date'][0].toDate().month.toString()}/${calculatedItems[index]['date'][0].toDate().year.toString()}',
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
      ):Container(),
    );
  }
}
