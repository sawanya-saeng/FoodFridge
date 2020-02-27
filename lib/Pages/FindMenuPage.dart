import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/ExploredMenuPage.dart';
import 'package:taluewapp/Pages/ChoosePage.dart';
import 'package:taluewapp/Pages/XChoosePage.dart';
import 'package:taluewapp/Pages/ShowAllMenu.dart';
import 'package:taluewapp/main.dart';
import 'MainPage.dart';
import 'package:taluewapp/Services/Ingredient.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class findmenu_page extends StatefulWidget {
  @override
  _findmenu_page createState() => _findmenu_page();
}

class _findmenu_page extends State<findmenu_page> {
  double _navHeight = 0.0;
  bool isSearched = false;
  Ingredient _ingredient;
  bool isLoaded = false;
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> ingredientInFridge;
  List<dynamic> canDo = [];
  List<dynamic> maybeDo = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(!isLoaded){
      _ingredient = Provider.of<Ingredient>(context);
    }
  }

  Future loadMenuFromMainIngredient()async{
    FirebaseUser user = await _auth.currentUser();
    List<dynamic> tmp = [];
    List<dynamic> allMenu = [];

    List<List<bool>> mainBool = [];
    List<List<bool>> optionBool = [];
    List<dynamic> notHaveMainIngredients = [];
    List<dynamic> notHaveOptionalIngredients = [];
    List<dynamic> haveMainIngredients = [];
    List<dynamic> haveOptionalIngredients = [];

    await _db.collection('Fridge').where('uid' ,isEqualTo: user.uid).getDocuments().then((docs){
      docs.documents.forEach((data){
        tmp.add(data.data);
      });
    });

    await _db.collection('Menu').getDocuments().then((docs){
      allMenu = docs.documents;
    });

    for(int k=0;k<allMenu.length;k++){
      List<bool> tmp_mainBool = [];
      List<bool> tmp_optionBool = [];
      List<dynamic> tmp_notHaveMainIngredients = [];
      List<dynamic> tmp_notHaveOptionalIngredients = [];
      List<dynamic> tmp_haveMainIngredients = [];
      List<dynamic> tmp_haveOptionalIngredients = [];

      for(int i=0;i<allMenu[k].data['Ingredients']['Main'].length;i++){
        bool isHas = false;
        bool isPushed = false;
        if(allMenu[k].data['Ingredients']['Main'][i]['name'] == _ingredient.getIngredient()['name']){
          if(allMenu[k].data['Ingredients']['Main'][i]['num'] <= int.parse(_ingredient.getIngredient()['num'])){
            isHas = true;
            tmp_haveMainIngredients.add(allMenu[k].data['Ingredients']['Main'][i]['name']);
          }else{
            tmp_notHaveMainIngredients.add([allMenu[k].data['Ingredients']['Main'][i]['name'], allMenu[k].data['Ingredients']['Main'][i]['num'] - int.parse(_ingredient.getIngredient()['num']), 'กรัม']);
            isPushed = true;
          }
        }

        if(isHas){
          tmp_mainBool.add(true);
        }else{
          tmp_mainBool.add(false);
          if(!isPushed){
            tmp_notHaveMainIngredients.add([allMenu[k].data['Ingredients']['Main'][i]['name'], allMenu[k].data['Ingredients']['Main'][i]['num'], 'กรัม']);
          }
        }
      }

      //

      //

      mainBool.add(tmp_mainBool);
      optionBool.add(tmp_optionBool);
      notHaveMainIngredients.add(tmp_notHaveMainIngredients);
      notHaveOptionalIngredients.add(tmp_haveOptionalIngredients);
      haveMainIngredients.add(tmp_haveMainIngredients);
      haveOptionalIngredients.add(tmp_haveOptionalIngredients);
    }

    for(int i=0;i<allMenu.length;i++){
      if(isAllfalse(mainBool[i])){
        continue;
      }else{
        if(isHasfalse(mainBool[i])){
          setState(() {
            maybeDo.add(allMenu[i].documentID);
          });
        }else{
          setState(() {
            canDo.add(allMenu[i].documentID);
          });
        }
      }
    }
//    print(canDo);
//    print(maybeDo);
  }

  bool isHasfalse(dynamic a){
    bool isBool = false;
    for(int i=0;i<a.length;i++){
      if(!a[i]){
        isBool = true;
        break;
      }
    }
    return isBool;
  }

  bool isAllfalse(dynamic a){
    bool isBool = true;
    for(int i=0;i<a.length;i++){
      if(a[i]){
        isBool = false;
        break;
      }
    }
    return isBool;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: Container(
//                color: Colors.grey,

              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                AnimatedContainer(
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 300),
                  color: Colors.red,
                  height: _navHeight,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              var result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return choose_page();
                              }));
                              if(result != null){
                                loadMenuFromMainIngredient().then((a){
                                  print(result);
                                  setState(() {
                                    isSearched = true;
                                  });
                                });
                              }
                            },
                            child: Container(
                              color: Color(0xff8B451A),
                              child: Text(
                                'เลือกจากวัตถุดิบหลัก',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                              ),
                              alignment: Alignment.center,
                              height: 60,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              var result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return xchoose_page();
                                  }));
                              if(result != null){
                                loadMenuFromMainIngredient().then((a){
                                  print(result);
                                  setState(() {
                                    isSearched = true;
                                  });
                                });
                              }
                            },
                            child: Container(
                              color: Color(0xff8B451A),
                              child: Text(
                                'เลือกโดยกำหนดเอง',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                              ),
                              alignment: Alignment.center,
                              height: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      color: Color(0xffB15B25),
                      child: Text(
                        'หาเมนูอาหาร',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_navHeight == 0.0) {
                            _navHeight = 120;
                          } else {
                            _navHeight = 0.0;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        height: 60,
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15,right: 15,bottom: 25,top: 25),
                child: Container(
                  child: isSearched ? explored_page(canDo, maybeDo) : showall_page(),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
