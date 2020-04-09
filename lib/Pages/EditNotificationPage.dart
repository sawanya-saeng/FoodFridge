import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taluewapp/Pages/MainPage.dart';

class edit_noti extends StatefulWidget {
  @override
  _edit_noti createState() => _edit_noti();
}

class _edit_noti extends State<edit_noti> {
  final _db = Firestore.instance;
  final _storageRef = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _safeTop = MediaQuery.of(context).padding.top;
    TextStyle bigText = TextStyle(fontSize: 20, color: Color(0xffa5a5a5));
    return Scaffold(
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
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      color:  Colors.red,
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
                            Container(
                              child: Text(
                                ' ',
                                style: TextStyle(fontSize: 5),
                              ),
                            ),


                            Row(
                              children: <Widget>[
                                Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      color:  Colors.white,
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
                            Container(
                              child: Text(
                                ' ',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),




                      GestureDetector(
                        onTap: (){

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