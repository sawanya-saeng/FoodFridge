import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taluewapp/Pages/MainPage.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';

class noti_page extends StatefulWidget {
  @override
  _noti_page createState() => _noti_page();
}

int click;

class _noti_page extends State<noti_page> with TickerProviderStateMixin{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  LoadingProgress loadingProgress;
  AnimationController _animationController;
  List<dynamic> newNotificationData = [];
  List<dynamic> oldNotificationData = [];
  bool isLoading = true;

  Future getNotificationData ()async{
    setState(() {
      isLoading = true;
    });
    List<dynamic> tmp1 = [];
    List<dynamic> tmp2 = [];
    FirebaseUser user = await _auth.currentUser();
    _db.collection("Notification").where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      docs.documents.forEach((d){
        var tmp = d.data;
        tmp['id'] = d.documentID;
        if(!d.data['is_read']){
          tmp1.add(tmp);
        }else{
          tmp2.add(tmp);
        }
      });
      setState(() {
        isLoading = false;
        newNotificationData = tmp1;
        oldNotificationData = tmp2;
      });
    });
  }

  Future setIsRead(docId)async{
    setState(() {
      isLoading = true;
    });
    await _db.collection('Notification').document(docId).updateData({
      'is_read': true
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 10));
    loadingProgress = new LoadingProgress(_animationController);
    // TODO: implement initState
    super.initState();
    getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    double _safeTop = MediaQuery.of(context).padding.top;
    // TODO: implement build
    return isLoading ? loadingProgress.getSubWidget(context) : Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            alignment: Alignment.center,
            color: Color(0xffB15B25),
            child: Text(
              'แจ้งเตือน',
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[Container(
                    child: Column(
                      children: List.generate(newNotificationData.length + 1, (k){
                        int index = k-1;
                        if(newNotificationData.length == 0){
                          return Container();
                        }
                        if(k == 0){
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xffB15B25)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text("ใหม่",style: TextStyle(color: Colors.red, fontSize: 25),),
                                )
                              ],
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: (){
                            setIsRead(newNotificationData[index]['id']).then((e){
                              Navigator.popUntil(context, (route)=>route.isFirst);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>main_page(0)));
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              border: Border(bottom: BorderSide(color: Color(0xffB15B25)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Text(newNotificationData[index]['ingredient_name'],style: TextStyle(fontSize: 25, color: Colors.white),),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  child: Text(newNotificationData[index]['expireIn'] < 1 ? "หมดอายุแล้ว" : "จะหมดอายุภายใน ${newNotificationData[index]['expireIn']} วัน",style: TextStyle(fontSize: 25, color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: List.generate(oldNotificationData.length + 1, (k){
                        int index = k-1;
                        if(k == 0){
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xffB15B25)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text("ก่อนหน้านี้",style: TextStyle(color: Colors.red, fontSize: 25),),
                                )
                              ],
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: (){
                            Navigator.popUntil(context, (route)=>route.isFirst);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>main_page(0)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xffB15B25)))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Text(oldNotificationData[index]['ingredient_name'],style: TextStyle(fontSize: 25),),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  child: Text("จะหมดอายุภายใน ${oldNotificationData[index]['expireIn']} วัน",style: TextStyle(fontSize: 25),),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
