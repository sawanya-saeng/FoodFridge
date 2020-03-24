import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class add_page extends StatefulWidget {
  String type;
  bool isEdit;
  String id;
  add_page(this.type, [this.isEdit = false, this.id = '']);
  _add_page createState() => _add_page(this.type, this.isEdit, this.id);
}


class _add_page extends State<add_page> {
  String type;
  bool isEdit;
  String id;
  _add_page(this.type, this.isEdit, this.id);

  String unitValue = 'กรัม';
  String dateNow = '';
  DateTime dateTime;
  TextEditingController _name = TextEditingController();
  TextEditingController _num = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  Map<String, dynamic> item = {};
  final format = DateFormat('yyyy-MM-dd');

  Future loadItem()async {
    await _db.collection('Fridge').document(this.id).get().then((docs){
      setState(() {
        item['id'] = docs.documentID;
        item = docs.data;
        print(item);

        _name.text = item['name'];
        _num.text = item['num'].toString();
        unitValue = item['unit'];
        dateNow = item['date'] == null ? 'ไม่มีกำหนด' : format.format(item['date'].toDate());
        dateTime =item['date'] == null ? null :  item['date'].toDate();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double _safeTop = MediaQuery.of(context).padding.top;

    Future errorDialog(String msg) async {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            title: Text('เดี๋ยวก่อน!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                child: Text('ตกลง'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }

    Future confirmData()async{
      if(_name.text.isEmpty){
        await errorDialog('กรุณาใส่ชื่อวัตถุดิบ');
        return;
      }

      if(_num.text.isEmpty){
        await errorDialog('กรุณาใส่จำนวนวัตถุดิบ');
        return;
      }



      FirebaseUser user = await _auth.currentUser();
      if(this.isEdit){
        await _db.collection('Fridge').document(this.id).updateData({
          'name' : _name.text,
          'num' : _num.text,
          'unit' : unitValue,
          'date' : dateTime,
        });
      }else{
        await _db.collection('Fridge').add({
          'name' : _name.text,
          'num' : _num.text,
          'unit' : unitValue,
          'date' : dateTime,
          'uid' : user.uid,
          'type' : this.type
        });
      }


      Navigator.of(context).pop();
    }

    return Scaffold(
      body: Container(
        color: Color(0xffFCFCFC),
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
                    'เพืิ่มวัตถุดิบ',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                color: Color(0xffF7FFDD),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('ชื่อวัตถุดิบ',style: TextStyle(fontSize: 25,color : Color(0xffB15B25)),),
                          ),
                          Container(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.center,
                            height: 30,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xffB15B25))
                            ),
                            child: TextField(
                              controller: _name,
                              style: TextStyle(fontSize: 25,color : Color(0xff5C2807)),
                              decoration: InputDecoration.collapsed(hintText: ''),
                            ),
                          ),
                        ],
                      ),
                    ),



                    Container(
                      height: 20,
                    ),

                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('จำนวน',style: TextStyle(fontSize: 25,color : Color(0xffB15B25)),),
                          ),
                          Container(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.center,
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xffB15B25))
                            ),
                            child: TextField(
                              controller: _num,
                              style: TextStyle(fontSize: 25,color : Color(0xff5C2807)),
                              decoration: InputDecoration.collapsed(hintText: ''),
                            ),
                          ),


                          Container(
                            width: 10,
                          ),


                          Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.center,
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xffB15B25))
                            ),
                            child: DropdownButton<String>(
                              value: unitValue,
                              icon: Icon(Icons.arrow_drop_down),
                              onChanged: (String value){
                                setState(() {
                                  unitValue = value;
                                });
                              },
                              items: <String>['กรัม', 'กิโล', 'ฟอง', 'ช้อนโต๊ะ' , 'ถ้วย'].map<DropdownMenuItem<String>>((String value){
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                            )
                          ),

                        ],
                      ),
                    ),




                    Container(
                      height: 20,
                    ),

                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text('วันหมดอายุ',style: TextStyle(fontSize: 25,color : Color(0xffB15B25)),),
                          ),
                          Container(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: (){
                              DatePicker.showDatePicker(context,onConfirm: (time,lists){
                                setState(() {
                                  dateTime = time;
                                  dateNow = time.year.toString() + '-' + time.month.toString() + '-' + time.day.toString();
                                });
                              },locale: DateTimePickerLocale.en_us,pickerMode: DateTimePickerMode.date);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 15),
                              alignment: Alignment.centerLeft,
                              height: 30,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xffB15B25))
                              ),
                              child: Text(dateNow),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        confirmData();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 170,
                          color: Colors.red,
                          child: Text('ยืนยัน',style: TextStyle(fontSize: 25,color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
