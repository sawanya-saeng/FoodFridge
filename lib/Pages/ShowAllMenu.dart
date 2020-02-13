import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taluewapp/Pages/ExploredMenu/CanDoMenuPage.dart';
import 'package:taluewapp/Pages/ExploredMenu/MayBeMenuPage.dart';

import 'HowToPage.dart';

class showall_page extends StatefulWidget {
  @override
  _showall_page createState() => _showall_page();
}

class _showall_page extends State<showall_page> {
  int _currentPage = 0;
  PageController _scrollController;
  final _db = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  List<Map<String,dynamic>> allMenu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new PageController(initialPage: 0);
    getAllMenu();
  }

  Future getAllMenu()async{
    List<Map<String,dynamic>> tmp = List<Map<String,dynamic>>();
    var map_tmp;
    await _db.collection('Menu').getDocuments().then((docs){
      docs.documents.forEach((data){
        map_tmp = data.data;
        map_tmp['menu_id'] = data.documentID;
        tmp.add(map_tmp);
      });
    });

    for(int i=0;i<tmp.length;i++){
      String url = await _storage.ref().child('Menu').child(tmp[i]['menu_id']).child('menupic.jpg').getDownloadURL().catchError((e){
        return null;
      });
      tmp[i]['image'] = url;
    }

    setState(() {
      print('Ok');
      allMenu = tmp;
      print(allMenu);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
                              ? Color(0xffFC9002)
                              : Color(0xffffffff),
                          border: Border.all(color: Color(0xffFC9002))),
                      alignment: Alignment.center,
                      height: 55,
                      child: Text(
                        "Let's Searched",
                        style: TextStyle(
                            color: _currentPage == 0
                                ? Colors.white
                                : Color(0xffFC9002),
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: allMenu == null ? CircularProgressIndicator() : ListView.builder(
                padding: EdgeInsets.only(top: 15),
                itemCount: allMenu == null ? 0 : allMenu.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          height: 120,
                          width: 160,
                          child: allMenu[index]['image'] == null ? Icon(Icons.error_outline) : Image.network(
                            allMenu[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    allMenu[index]['Name'],
                                    style: TextStyle(
                                        color: Color(0xff914d1f), fontSize: 30),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return howto_page(allMenu[index]['menu_id']);
                                            }));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            color: Color(0xff914d1f),
                                            child: Text(
                                              "วิธีการทำ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
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
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
