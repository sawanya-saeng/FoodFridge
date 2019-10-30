import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class meat_page extends StatefulWidget {
  @override
  _meat_page createState() => _meat_page();
}

int click;

class _meat_page extends State<meat_page> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  Map<String,dynamic> meats;

  Future getMeat()async{
//    _db.collection('Fridge').
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.builder(itemCount: 1,itemBuilder: (BuildContext context,int index){
                return Container(
                  height: 100,
                  color: Colors.green,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('Mu'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('Mu'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('Mu'),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return add_page();
              }));
            },
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.add),
                  ),
                  Container(child: Text("เพิ่ม"),),
                ],
              ),
            ),
          )
        ],
      ),

//      child: Column(
//        children: <Widget>[
//          Expanded(
//            child: Container(
//              alignment: Alignment.center,
//              child: Text("ไม่มี")
//            ),
//          ),
//          GestureDetector(
//            onTap: (){
//              Navigator.push(context, MaterialPageRoute(builder: (context){
//                return add_page();
//              }));
//            },
//            child: Container(
//              height: 100,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    child: Icon(Icons.add),
//                  ),
//                  Container(child: Text("เพิ่ม"),),
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
    );
  }
}
