import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/HowToPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';


class cando_page extends StatefulWidget {
  List<dynamic> canDo;
  cando_page(this.canDo);
  @override
  _cando_page createState() => _cando_page(this.canDo);
}

class _cando_page extends State<cando_page> with TickerProviderStateMixin{
  Firestore _db = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<dynamic> canDo;
  _cando_page(this.canDo);
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
    loadcandoMenu();
  }

  Future loadcandoMenu()async{
    List<String> tmp_menuImages = [];
    List<dynamic> tmp_menuDetail = [];

    setState(() {
      _loadingProgress.setProgress(0);
      return _loadingProgress;(0);
      _loadingProgress.setProgressText('กำลังโหลดเมนู');
    });

    for(int i=0; i<this.canDo.length; i++){
      setState(() {
        _loadingProgress.setProgress((i*100)/this.canDo.length);
        _loadingProgress.setProgressText('กำลังโหลดเมนู ${i}/${this.canDo.length}');
      });
      await _db.collection('Menu').document(this.canDo[i]).get().then((data){
        tmp_menuDetail.add(data.data);
      });
    }

    setState(() {
      _loadingProgress.setProgress(100);
      _loadingProgress.setProgressText('กำลังโหลดรูป');
    });

    for(int i=0;i<this.canDo.length;i++){
      setState(() {
        _loadingProgress.setProgress(((i*100)/this.canDo.length)+100);
        _loadingProgress.setProgressText('กำลังโหลดรูป ${i}/${this.canDo.length}');
      });
      String url = await _storage.ref().child('Menu').child(this.canDo[i]).child('menupic.jpg').getDownloadURL().catchError((e){
        return null;
      });
      tmp_menuImages.add(url);
    }

    setState(() {
      menuDetail = tmp_menuDetail;
      menuImages = tmp_menuImages;
      isLoaded = false;
      print(menuDetail.length);
      print(menuImages.length);
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
                                              return howto_page(this.canDo[index]);
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
    );
  }
}

