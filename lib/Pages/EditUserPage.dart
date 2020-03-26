import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taluewapp/Pages/MainPage.dart';

class edit_user extends StatefulWidget {
  @override
  _edit_user createState() => _edit_user();
}

class _edit_user extends State<edit_user> {
  final _db = Firestore.instance;
  final _storageRef = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  File _file;
  TextEditingController _name = new TextEditingController();
  String _url;
  String _uid;
  String docId;

  Future getUserData()async{
    FirebaseUser user = await _auth.currentUser();
    await _db.collection('User').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      setState(() {
        _name.text = docs.documents[0].data['name'];
        _url = docs.documents[0].data['display'];
        _uid = user.uid;
        docId = docs.documents[0].documentID;
      });
    });
  }

  Future getPhotoFromGallery() async {
    File _tmp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = _tmp;
    });
  }

  Future saveUserData()async{
    StorageReference storageReference = _storageRef.ref().child('User').child(_uid).child('profile');
    if(_file != null){
      StorageUploadTask mission = storageReference.putFile(_file);
    }

    await _db.collection('User').document(docId).updateData({
      'name': _name.text
    });

    Navigator.popUntil(context, (e) => e.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
      return main_page(4);
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
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
                    'แก้ไขข้อมูลส่วนตัว',
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
            Expanded(
              child: Padding(
                padding:
                EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          getPhotoFromGallery();
                        },
                        child: _file == null
                            ? Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: _url == null ? Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                ):Image.network(_url),
                              ),
                              Container(
                                child: Text(
                                  "เปลี่ยนรูปโปรไฟล์",
                                  style: bigText,
                                ),
                              ),
                            ],
                          ),
                        )
                            : Container(
                          height: 250,
                          child: Image.file(_file),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                height: 45,
                                child: TextField(
                                  controller: _name,
                                  style: bigText,
                                  decoration: InputDecoration.collapsed(hintText: "เปลี่ยนชื่อของคุณ"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          saveUserData();
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