import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/ExploredMenuPage.dart';
import 'package:taluewapp/Pages/ChoosePage.dart';
import 'package:taluewapp/Pages/XChoosePage.dart';
import 'package:taluewapp/Pages/ShowAllMenu.dart';
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
  bool isSignIn = false;

  Future checkSignIn()async{
    FirebaseUser user = await _auth.currentUser();
    if(user == null){
      setState(() {
        isSignIn = false;
      });
    }else{
      setState(() {
        isSignIn = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(!isLoaded){
      _ingredient = Provider.of<Ingredient>(context);
    }
  }

  bool checkMainIngredients(list, name){
    bool isHas = false;

    for(int i=0; i<list.length; i++){
      if(name == list[i]){
        isHas = true;
      }
    }

    return isHas;
  }

  double toGrum(double num, String unit) {
    double base=1;

    if(unit == "ฟอง"){
      base = 50;
    }
    if(unit == "ช้อนโต๊ะ"){
      base = 12.5;
    }
    if(unit == "กิโลกรัม"){
      base = 1000;
    }
    if(unit == "ช้อนชา") {
      base = 5;
    }
      if(unit == "มิลลิิลิตร"){
        base = 1.03;
      }
      if(unit == "ถ้วยตวง"){
        base = 240;
      }
      if(unit == "ลูก"){
        base = 67;
      }
      if(unit == "ขีด"){
        base = 100;
      }
      if(unit == "เม็ด"){
      base = 100;
     }

    return num*base;
  }

  Future loadMenuFromMainIngredient()async{
    FirebaseUser user = await _auth.currentUser();
    List<dynamic> tmp = [];
    List<dynamic> allMenu = [];
    canDo = [];
    maybeDo = [];
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

      // menu main = fridge
      for(int i=0; i<allMenu[k].data['Ingredients']['Main'].length;i++){
        bool isHas = false;
        bool isPushed = false;
        for(int j=0; j<tmp.length; j++){
          if(allMenu[k].data['Ingredients']['Main'][i]['name'] == tmp[j]['name']){
            double net1 = toGrum(double.parse(allMenu[k].data['Ingredients']['Main'][i]['num'].toString()), allMenu[k].data['Ingredients']['Main'][i]['unit']);
            double net2 = toGrum(double.parse(tmp[j]['num'].toString()), tmp[j]['unit']);

            if(net1 <= net2){
              isHas = true;
              tmp_haveMainIngredients.add(allMenu[k].data['Ingredients']['Main'][i]['name']);
            }else{
              tmp_notHaveMainIngredients.add([allMenu[k].data['Ingredients']['Main'][i]['name'], allMenu[k].data['Ingredients']['Main'][i]['num'] - double.parse(tmp[j]['num'].toString()), 'กรัม']);
              isPushed = true;
            }
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

      // menu optional = fridge
      if(allMenu[k].data['Ingredients']['Optional'] != null){
          for(int i=0; i<allMenu[k].data['Ingredients']['Optional'].length;i++){
            bool isHas = false;
            bool isPushed = false;
            if(allMenu[k].data['Ingredients']['Optional'][i] == '-'){
              break;
            }
            for(int j=0; j<tmp.length; j++){
              if(allMenu[k].data['Ingredients']['Optional'][i]['name'] == tmp[j]['name']){
                double net1 = toGrum(double.parse(allMenu[k].data['Ingredients']['Optional'][i]['num'].toString()), allMenu[k].data['Ingredients']['Optional'][i]['unit']);
                double net2 = toGrum(double.parse(tmp[j]['num'].toString()), tmp[j]['unit']);

                if(net1 <= net2){
                  isHas = true;
                  tmp_haveOptionalIngredients.add(allMenu[k].data['Ingredients']['Optional'][i]['name']);
                }else{
                  tmp_notHaveOptionalIngredients.add([allMenu[k].data['Ingredients']['Optional'][i]['name'], allMenu[k].data['Ingredients']['Optional'][i]['num'] - double.parse(tmp[j]['num'].toString()), 'กรัม']);
                  isPushed = true;
                }
              }
            }
            if(isHas){
              tmp_optionBool.add(true);
            }else{
              tmp_optionBool.add(false);
              if(!isPushed){
                tmp_notHaveOptionalIngredients.add([allMenu[k].data['Ingredients']['Optional'][i]['name'], allMenu[k].data['Ingredients']['Optional'][i]['num'], 'กรัม']);
              }
            }
          }
      }

      mainBool.add(tmp_mainBool);
      optionBool.add(tmp_optionBool);
      notHaveMainIngredients.add(tmp_notHaveMainIngredients);
      notHaveOptionalIngredients.add(tmp_notHaveOptionalIngredients);
      haveMainIngredients.add(tmp_haveMainIngredients);
      haveOptionalIngredients.add(tmp_haveOptionalIngredients);
    }

    for(int i=0;i<allMenu.length;i++){
      if(isAllfalse(mainBool[i])){
        continue;
      }else{
        if((isHasfalse(mainBool[i])) || (isHasfalse(optionBool[i]))){
          if(!checkMainIngredients(haveMainIngredients[i], _ingredient.getIngredient()['name'])){
            continue;
          }

          if(isHasfalse(mainBool[i])){
            continue;
          }

          setState(() {
            maybeDo.add({
              "menu_id": allMenu[i].documentID,
              "haveMain": haveMainIngredients[i],
              "haveOpt": haveOptionalIngredients[i],
              "notMain": notHaveMainIngredients[i],
              "notOpt": notHaveOptionalIngredients[i]
            });
          });
        }else{
          if(!checkMainIngredients(haveMainIngredients[i], _ingredient.getIngredient()['name'])){
            continue;
          }

          setState(() {
            canDo.add(allMenu[i].documentID);
          });
        }
      }
    }
    print('cando');
    print(canDo);
    print('maybe');
    print(maybeDo);
  }

  Future loadMenuFromManual()async{
    FirebaseUser user = await _auth.currentUser();
    List<dynamic> tmp = [];
    List<dynamic> allMenu = [];
    canDo = [];
    maybeDo = [];
    List<List<bool>> mainBool = [];
    List<List<bool>> optionBool = [];
    List<dynamic> notHaveMainIngredients = [];
    List<dynamic> notHaveOptionalIngredients = [];
    List<dynamic> haveMainIngredients = [];
    List<dynamic> haveOptionalIngredients = [];

    tmp = _ingredient.getIngredients();

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

      // menu main = fridge
      for(int i=0; i<allMenu[k].data['Ingredients']['Main'].length;i++){
        bool isHas = false;
        bool isPushed = false;
        for(int j=0; j<tmp.length; j++){
          if(allMenu[k].data['Ingredients']['Main'][i]['name'] == tmp[j]['name']){
            double net1 = toGrum(double.parse(allMenu[k].data['Ingredients']['Main'][i]['num'].toString()), allMenu[k].data['Ingredients']['Main'][i]['unit']);
            double net2 = toGrum(double.parse(tmp[j]['num']), tmp[j]['unit']);

            if(net1 <= net2){
              isHas = true;
              tmp_haveMainIngredients.add(allMenu[k].data['Ingredients']['Main'][i]['name']);
            }else{
              tmp_notHaveMainIngredients.add([allMenu[k].data['Ingredients']['Main'][i]['name'], allMenu[k].data['Ingredients']['Main'][i]['num'] - double.parse(tmp[j]['num']), 'กรัม']);
              isPushed = true;
            }
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

      // menu optional = fridge
      if(allMenu[k].data['Ingredients']['Optional'] != null){
        for(int i=0; i<allMenu[k].data['Ingredients']['Optional'].length;i++){
          bool isHas = false;
          bool isPushed = false;
          if(allMenu[k].data['Ingredients']['Optional'][i] == '-'){
            break;
          }
          for(int j=0; j<tmp.length; j++){
            if(allMenu[k].data['Ingredients']['Optional'][i]['name'] == tmp[j]['name']){
              double net1 = toGrum(double.parse(allMenu[k].data['Ingredients']['Optional'][i]['num'].toString()), allMenu[k].data['Ingredients']['Optional'][i]['unit']);
              double net2 = toGrum(double.parse(tmp[j]['num']), tmp[j]['unit']);

              if(net1 <= net2){
                isHas = true;
                tmp_haveOptionalIngredients.add(allMenu[k].data['Ingredients']['Optional'][i]['name']);
              }else{
                tmp_notHaveOptionalIngredients.add([allMenu[k].data['Ingredients']['Optional'][i]['name'], allMenu[k].data['Ingredients']['Optional'][i]['num'] - int.parse(tmp[j]['num']), 'กรัม']);
                isPushed = true;
              }
            }
          }
          if(isHas){
            tmp_optionBool.add(true);
          }else{
            tmp_optionBool.add(false);
            if(!isPushed){
              tmp_notHaveOptionalIngredients.add([allMenu[k].data['Ingredients']['Optional'][i]['name'], allMenu[k].data['Ingredients']['Optional'][i]['num'], 'กรัม']);
            }
          }
        }
      }

      mainBool.add(tmp_mainBool);
      optionBool.add(tmp_optionBool);
      notHaveMainIngredients.add(tmp_notHaveMainIngredients);
      notHaveOptionalIngredients.add(tmp_notHaveOptionalIngredients);
      haveMainIngredients.add(tmp_haveMainIngredients);
      haveOptionalIngredients.add(tmp_haveOptionalIngredients);
    }

    for(int i=0;i<allMenu.length;i++){
      if(isAllfalse(mainBool[i])){
        continue;
      }else{
        if((isHasfalse(mainBool[i])) || (isHasfalse(optionBool[i]))){
          if(isHasfalse(mainBool[i])){
            continue;
          }
          bool isHas = false;
          for(int j=0;j<tmp.length;j++){
            if(checkMainIngredients(haveMainIngredients[i], tmp[j]['name'])){
              isHas = true;
            }
          }

//          if(!isHas){
//            continue;
//          }

          setState(() {
            maybeDo.add({
              "menu_id": allMenu[i].documentID,
              "haveMain": haveMainIngredients[i],
              "haveOpt": haveOptionalIngredients[i],
              "notMain": notHaveMainIngredients[i],
              "notOpt": notHaveOptionalIngredients[i]
            });
          });
        }else{
//          if(!checkMainIngredients(haveMainIngredients[i], _ingredient.getIngredient()['name'])){
//            continue;
//          }

          setState(() {
            canDo.add(allMenu[i].documentID);
          });
        }


      }
    }
    print('cando');
    print(canDo);
    print('maybe');
    print(maybeDo);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: Container(
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
                              setState(() {
                                isSearched = false;
                              });
                              var result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return choose_page();
                              }));
                              if(result != null){
                                loadMenuFromMainIngredient().then((a){
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
                              setState(() {
                                isSearched = false;
                              });
                              var result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return xchoose_page();
                                  }));
                              print("result:");
                              print(result);
                              if(result != null){
                                loadMenuFromManual().then((a){
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
                        if(isSignIn){
                          setState(() {
                            if (_navHeight == 0.0) {
                              _navHeight = 120;
                            } else {
                              _navHeight = 0.0;
                            }
                          });
                        }
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
