import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taluewapp/Pages/MainPage.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';

class edit_noti extends StatefulWidget {
  @override
  _edit_noti createState() => _edit_noti();
}

class _edit_noti extends State<edit_noti> with TickerProviderStateMixin{
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool onlyExpire = true;
  bool beforeExpire = true;
  LoadingProgress _loadingProgress;
  AnimationController _animationController;
  bool isLoading = true;
  List<TextEditingController> minDays = [TextEditingController(text: '1')];

  Future saveData()async{
    setState(() {
      isLoading = true;
    });
    FirebaseUser user = await _auth.currentUser();
    List<String> minDayList = [];
    for(int i=0; i<minDays.length; i++){
      minDayList.add(minDays[i].text);
    }

    Map<String, dynamic> dataToSave = {
      'only_expire': onlyExpire,
      'before_expire': beforeExpire,
      'min_day': minDayList
    };

    String docId = '';
    await _db.collection('User').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      docId = docs.documents[0].documentID;
    });

    await _db.collection('User').document(docId).updateData(dataToSave);
    setState(() {
      isLoading = false;
    });
  }

  Future loadData()async{
    setState(() {
      isLoading = true;
    });
    FirebaseUser user = await _auth.currentUser();
    List<dynamic> tmp = [];
    await _db.collection('User').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      setState(() {
        onlyExpire = docs.documents[0].data['only_expire'] == null ? true : docs.documents[0].data['only_expire'];
        beforeExpire = docs.documents[0].data['before_expire'] == null ? false : docs.documents[0].data['before_expire'];
        tmp = docs.documents[0].data['min_day'] == null ? [] : docs.documents[0].data['min_day'];
      });
    });

    minDays.clear();
    for(int i=0; i<tmp.length; i++){
      minDays.add(new TextEditingController(text: tmp[i]));
    }

    print(minDays);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingProgress = LoadingProgress(_animationController);
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double _safeTop = MediaQuery.of(context).padding.top;
    TextStyle bigText = TextStyle(fontSize: 20, color: Color(0xffa5a5a5));
    return isLoading ? _loadingProgress.getWidget(context) : Scaffold(
      body: Container(
        color: Color(0xffededed),
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
                    'ตั้งค่าการแจ้งเตือน',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10,),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text("กรุณาเลือกจำนวนวัน ที่ต้องการให้ระบบแจ้งเตือนวัตถุดิบหมดอายุ",style: TextStyle(color: Colors.black,fontSize: 20),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          ' ',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  onlyExpire = !onlyExpire;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        color: onlyExpire ? Colors.red : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.red)
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ' แจ้งเตือนเฉพาะวันทีี่หมดอายุแล้ว',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                ' ',
                                style: TextStyle(fontSize: 5),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  beforeExpire = !beforeExpire;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        color: beforeExpire ? Colors.red : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.red)
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ' แจ้งเตือนก่อนวันหมดอายุ',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                ' ',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      beforeExpire ? Container(
                        child: Column(
                          children: List.generate(minDays.length, (int index){
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        int num = int.parse(minDays[index].text);
                                        if(num > 1){
                                          num --;
                                        }
                                        minDays[index].text = num.toString();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey)
                                        ),
                                        child: TextField(
                                          controller: minDays[index],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration.collapsed(hintText: 'ใส่จำนวนวัน'),
                                        ),
                                      )
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        int num = int.parse(minDays[index].text);
                                        num++;
                                        minDays[index].text = num.toString();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        minDays.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ):Container(),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            minDays.add(new TextEditingController(text: '1'));
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Icon(Icons.add),
                              ),
                              Container(
                                child: Text("เพิ่มจำนวนวัน", style: TextStyle(fontSize: 20),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          saveData();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20,bottom: 20),
                          alignment: Alignment.center,
                          height: 51,
                          decoration: BoxDecoration(
                            color: Color(0xffec2d1c),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text("บันทึก",style: TextStyle(color: Colors.white,fontSize: 20),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}