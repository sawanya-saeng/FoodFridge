import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class add_menu extends StatefulWidget {
  @override
  _add_menu createState() => _add_menu();
}

class _add_menu extends State<add_menu> {
  List<Map<String, dynamic>> ingredients = [
    {
      "ingredient_name": new TextEditingController(),
      "ingredient_value": new TextEditingController(text: '1'),
      "ingredient_unit": "กิโล"
    }
  ];

  List<Map<String, dynamic>> howToMake = [
    {
      "description": new TextEditingController(),
      "images":[]
    },
    {
      "description": new TextEditingController(),
      "images":[]
    }
  ];

  File _foodImage;

  Future getPhotoFromGallery() async {
    File _tmp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _foodImage = _tmp;
    });
  }

  Future addPhotoToHowToMake(rowIndex) async{
    File _tmp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      howToMake[rowIndex]['images'].add(_tmp);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _safeTop = MediaQuery.of(context).padding.top;
    TextStyle bigText = TextStyle(fontSize: 20, color: Color(0xffa5a5a5));
    TextStyle headerText = TextStyle(fontSize: 20, color: Colors.black);

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
                    'เพืิ่มสูตรอาหารของคุณ',
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
                        child: _foodImage == null
                            ? Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "ใส่รูปอาหาร",
                                        style: bigText,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 250,
                                child: Image.file(_foodImage),
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
                                  style: bigText,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "ชื่อสูตรอาหาร"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "วัตถุดิบที่ใช้",
                                style: headerText,
                              ),
                            ),
                            ingredients.length == 0
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.all(20),
                                    color: Colors.white,
                                  )
                                : Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.all(20),
                                    color: Colors.white,
                                    child: Column(
                                      children: List.generate(
                                          ingredients.length, (index) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          height: 45,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: TextField(
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText:
                                                                "ใส่ชื่อวัตถุดิบ"),
                                                    controller:
                                                        ingredients[index]
                                                            ['ingredient_name'],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xffc5c5c5))),
                                                width: 50,
                                                height: 50,
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText: "จำนวน"),
                                                  controller: ingredients[index]
                                                      ['ingredient_value'],
                                                ),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffc5c5c5))),
                                                  child: DropdownButton<String>(
                                                    value: ingredients[index]
                                                        ['ingredient_unit'],
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        ingredients[index][
                                                                'ingredient_unit'] =
                                                            newValue;
                                                      });
                                                    },
                                                    underline: Container(),
                                                    items: <String>[
                                                      'กรัม',
                                                      'กิโล',
                                                      'ตัน'
                                                    ].map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    print(ingredients[index]
                                                            ["ingredient_name"]
                                                        .text);
                                                    ingredients.removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  child: Icon(Icons.remove),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  ingredients.add({
                                    "ingredient_name":
                                        new TextEditingController(),
                                    "ingredient_value":
                                        new TextEditingController(text: '1'),
                                    "ingredient_unit": "กิโล"
                                  });
                                });
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(Icons.add),
                                    ),
                                    Container(
                                      child: Text(
                                        "เพิ่มวัตถุดิบที่ใช้",
                                        style: headerText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              alignment: Alignment.centerLeft,
                              child: Text("ขั้นตอนการทำ",style: headerText,),
                            ),
                            howToMake.length == 0 ? Container(
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(20),
                              color: Colors.white,
                            ) : Container(
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(20),
                              color: Colors.white,
                              child: Column(
                                children: List.generate(howToMake.length, (index){
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(right: 15),
                                                height: 25,
                                                width: 25,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                                  color: Color(0xffc3c3c3),
                                                ),
                                                child: Text((index+1).toString(),style: TextStyle(color: Colors.white,fontSize: 20),),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: TextField(
                                                    decoration: InputDecoration.collapsed(hintText: "dasdadas"),
                                                    maxLines: null,
                                                    controller: howToMake[index]['description'],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 40,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: List.generate(4, (jdex){
                                                      if(jdex == 3){
                                                        return GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              howToMake.removeAt(index);
                                                            });
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: 15),
                                                            child: Icon(Icons.remove),
                                                          ),
                                                        );
                                                      }
                                                      if(jdex < howToMake[index]['images'].length){
                                                        return Container(
                                                          height: 59,
                                                          width: 59,
                                                          child: Image.file(howToMake[index]['images'][jdex],fit: BoxFit.cover,),
                                                        );
                                                      }
                                                      return GestureDetector(
                                                        onTap: (){
                                                          addPhotoToHowToMake(index);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(0xffe6e6e6),
                                                              borderRadius: BorderRadius.all(Radius.circular(7))
                                                          ),
                                                          height: 41,
                                                          width: 59,
                                                          alignment: Alignment.center,
                                                          child: Icon(Icons.camera_alt),
                                                        ),
                                                      );
                                                    }),
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Icon(Icons.add),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        howToMake.add({
                                          "description": new TextEditingController(),
                                          "images":[]
                                        });
                                      });
                                    },
                                    child: Container(
                                      child: Text("เพิ่มขั้นตอนการทำ", style: headerText,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20,bottom: 20),
                              alignment: Alignment.center,
                              height: 51,
                              decoration: BoxDecoration(
                                color: Color(0xffec2d1c),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text("บันทึก",style: TextStyle(color: Colors.white,fontSize: 20),),
                            )
                          ],
                        ),
                      ),
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
