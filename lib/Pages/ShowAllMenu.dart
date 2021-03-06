import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';
import 'HowToPage.dart';

class showall_page extends StatefulWidget {
  @override
  _showall_page createState() => _showall_page();
}

class _showall_page extends State<showall_page> with TickerProviderStateMixin{
  int _currentPage = 0;
  PageController _scrollController;
  TextEditingController _searchController = new TextEditingController();
  final _db = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  List<Map<String,dynamic>> allMenu;
  LoadingProgress _loadingProgress;
  AnimationController _animationController;
  bool isLoaded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = true;
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingProgress = new LoadingProgress(_animationController);
    _scrollController = new PageController(initialPage: 0);
    getAllMenu();
  }

  Future getAllMenu()async{
    List<Map<String,dynamic>> tmp = List<Map<String,dynamic>>();
    var map_tmp;
    setState(() {
      _loadingProgress.setProgressText('กำลังโหลดเมนู');
      _loadingProgress.setProgress(0);
    });
    await _db.collection('Menu').getDocuments().then((docs){
      docs.documents.forEach((data){
        map_tmp = data.data;
        map_tmp['menu_id'] = data.documentID;
        tmp.add(map_tmp);
      });
    });
    setState(() {
      _loadingProgress.setProgressText('กำลังโหลดรูปภาพ');
      _loadingProgress.setProgress(100);
    });

    for(int i=0;i<tmp.length;i++){
      setState(() {
        _loadingProgress.setProgressText('กำลังโหลดรูปภาพ ${i+1}/${tmp.length}');
        _loadingProgress.setProgress((((i+1)*tmp.length)/100)+100);
      });
      String url = await _storage.ref().child('Menu').child(tmp[i]['menu_id']).child('menupic.jpg').getDownloadURL().catchError((e){
        return null;
      });
      tmp[i]['image'] = url;
    }

    setState(() {
      print('Ok');
      allMenu = tmp;
      print(allMenu);
      isLoaded = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoaded ? _loadingProgress.getSubWidget(context) : Container(

      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
               Expanded(

                 child: Container(
                      width: 330,
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8))),
                      height: 40,

                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration.collapsed(
                            hintText: "ค้นหาเมนูอาหาร"),
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
                  return _searchController.text.isEmpty ? Container(
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
                  ): allMenu[index]['Name'].contains(_searchController.text) ? Container(
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
                  ):Container();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}


// a = "Singhtaluew"
// b = "ZYS"
// a.contains(b) //True //False