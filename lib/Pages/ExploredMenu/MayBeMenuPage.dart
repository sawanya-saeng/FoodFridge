import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/HowToPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';

class maybe_page extends StatefulWidget {
  List<dynamic> maybeDo;
  maybe_page(this.maybeDo);
  @override
  _maybe_page createState() => _maybe_page(this.maybeDo);
}

class _maybe_page extends State<maybe_page> with TickerProviderStateMixin{
  Firestore _db = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<dynamic> maybeDo;
  _maybe_page(this.maybeDo);
  List<String> menuImages;
  List<dynamic> menuDetail;
  AnimationController _animationController;
  LoadingProgress _loadingProgress;
  bool isLoaded;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = true;
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingProgress = LoadingProgress(_animationController);
    loadMaybeMenu();
  }

  Future loadMaybeMenu()async{
    List<String> tmp_menuImages = [];
    List<dynamic> tmp_menuDetail = [];

    setState(() {
      isLoaded = true;
      _loadingProgress.setProgress(0);
      _loadingProgress.setProgressText('กำลังโหลดเมนู');
    });

    for(int i=0; i<this.maybeDo.length; i++){
      setState(() {
        _loadingProgress.setProgress((i*100)/this.maybeDo.length);
        _loadingProgress.setProgressText('กำลังโหลดเมนู ${i}/${this.maybeDo.length}');
      });
      await _db.collection('Menu').document(this.maybeDo[i]['menu_id']).get().then((data){
        tmp_menuDetail.add(data.data);
      });
    }

    setState(() {
      _loadingProgress.setProgress(100);
      _loadingProgress.setProgressText('กำลังโหลดรูป');
    });

    for(int i=0;i<this.maybeDo.length;i++){
      setState(() {
        _loadingProgress.setProgress(((i*100)/this.maybeDo.length)+100);
        _loadingProgress.setProgressText('กำลังโหลดรูป ${i}/${this.maybeDo.length}');
      });
      String url = await _storage.ref().child('Menu').child(this.maybeDo[i]['menu_id']).child('menupic.jpg').getDownloadURL().catchError((e){
        return null;
      });
      tmp_menuImages.add(url);
    }

    setState(() {
      menuDetail = tmp_menuDetail;
      menuImages = tmp_menuImages;
      isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
   double _width = MediaQuery.of(context).size.width;
    return isLoaded ? _loadingProgress.getSubWidget(context) : Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 15),
        itemCount: menuImages == null ? 0 : menuImages.length,
        itemBuilder: (BuildContext context, int index){
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
                  child: menuImages == null ? Icon(Icons.error_outline) : Image.network(
                    menuImages[index],
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
                            menuDetail[index]['Name'],
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
                                              return howto_page(this.maybeDo[index]['menu_id']);
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
                        Container(
                          child: Text("-------- วัตถุดิบที่ขาด --------",style: TextStyle(
                              color: Color(0xff914d1f), fontSize: 13)),
                        ),
                        Container(

                          child: Column(
                            children: List.generate(this.maybeDo[index]['notMain'].length, (i){
                              return Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(this.maybeDo[index]['notMain'][i][0],style: TextStyle(
                                    fontSize: 12)),
                                    ),
                                    Container(
                                      child: Text(" "),
                                    ),
                                    Container(
                                      child: Text(this.maybeDo[index]['notMain'][i][1].toString(),style: TextStyle(
                              color: Color(0xffC41C0D), fontSize: 12)),
                                    ),
                                    Container(
                                      child: Text(" "),
                                    ),
                                    Container(
                                      child: Text(this.maybeDo[index]['notMain'][i][2],style: TextStyle(
                               fontSize: 12)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            children: List.generate(this.maybeDo[index]['notOpt'].length, (i){
                              return Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(this.maybeDo[index]['notOpt'][i][0],style: TextStyle(
                                     fontSize: 12)),
                                    ),
                                    Container(
                                      child: Text(" "),
                                    ),
                                    Container(
                                      child: Text(this.maybeDo[index]['notOpt'][i][1].toString(),style: TextStyle(
                              color: Color(0xffC41C0D), fontSize: 12)),
                                    ),
                                    Container(
                                      child: Text(" "),
                                    ),
                                    Container(
                                      child: Text(this.maybeDo[index]['notOpt'][i][2],style: TextStyle(
                               fontSize: 12)),
                                    ),
                                  ],
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
        },
      ),
    );
  }
}
