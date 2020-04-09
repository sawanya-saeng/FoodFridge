import 'package:date_calc/date_calc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taluewapp/Pages/MainPage.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';
import 'package:transparent_image/transparent_image.dart';

class howto_page extends StatefulWidget {
  String menu_id;

  howto_page(this.menu_id);

  @override
  _howto_page createState() => _howto_page(this.menu_id);
}

class _howto_page extends State<howto_page> with TickerProviderStateMixin{
  String menu_id;

  _howto_page(this.menu_id);
  bool isLoading = true;
  int _currentPage = 0;
  final _db = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  PageController _scrollController;
  final format = DateFormat("yyyy-MM-dd");
  bool isFavor;
  Map<String, dynamic> menuDetail;
  List<dynamic> mainIngredients;
  List<dynamic> optionIngredients;
  List<dynamic> allIngredients;
  List<dynamic> fridgeIngredients;
  List<dynamic> items = [];
  List<dynamic> calculatedItems = [];
  String mainImage;
  bool isSignIn = false;
  Map<String, dynamic> userData;
  String userUrl;
  TextEditingController _commentText = TextEditingController();
  LoadingProgress _loadingProgress;
  AnimationController _animationController;
  List<dynamic> commentData;
  List<dynamic> commentUserData = [];

  Future checkSignIn() async {
    FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      setState(() {
        isSignIn = false;
      });
    } else {
      setState(() {
        isSignIn = true;
      });
    }
  }

  Future getUserData() async {
    FirebaseUser user = await _auth.currentUser();
    String tmp;
    tmp = await _storage.ref().child('User').child(user.uid).child('profile').getDownloadURL().catchError((e){
      tmp = null;
    });

    await _db.collection('User').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      setState(() {
        userData = docs.documents[0].data;
        userUrl = tmp;
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  double grumToUnit(num, unit) {
    double base = 1;

    if (unit == 'ฟอง') {
      base = 50;
    }

    if (unit == 'กิโล') {
      base = 100;
    }

    if (unit == 'ช้อนโต๊ะ') {
      base = 12.5;
    }

    return num / base;
  }

  bool checkMainIngredient() {
    return true;
  }

  double getNumFromId(String id) {
    for (int i = 0; i < fridgeIngredients.length; i++) {
      if (id == fridgeIngredients[i]['id']) {
        return double.parse(fridgeIngredients[i]['num'].toString());
      }
    }

    return 0;
  }

  Future saveToFavor() async {
    FirebaseUser user = await _auth.currentUser();
    await _db.collection('Favor').add(
        {'uid': user.uid, 'menu': this.menu_id, 'date': new DateTime.now()});
  }

  Future deleteFavor() async {
    FirebaseUser user = await _auth.currentUser();
    await _db
        .collection('Favor')
        .where('uid', isEqualTo: user.uid)
        .where('menu', isEqualTo: this.menu_id)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((d) {
        _db.collection('Favor').document(d.documentID).delete();
      });
    });
  }

  Future loadFavor() async {
    FirebaseUser user = await _auth.currentUser();
    await _db
        .collection('Favor')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((d) {
        if (this.menu_id == d.data['menu']) {
          setState(() {
            isFavor = true;
          });
        }
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  Future deleteIngredientFromFridge() async {
    List<Map<String, String>> toDelete = [];
    List<Map<String, String>> toUpdate = [];
    bool isConfirm = false;
    TextEditingController _text = TextEditingController(text: '1');

    await showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("กรุณาใส่จำนวนจาน"),
          content: Container(
            height: 55,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _text,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("ยกเลิก"),
            ),
            FlatButton(
              onPressed: (){
                if(int.parse(_text.text) >= 1){
                  isConfirm = true;
                }
                Navigator.of(context).pop();
              },
              child: Text("ยืนยัน"),
            ),
          ],
        );
      },
    );

    if(!isConfirm){
      return;
    }

    if (checkMainIngredient()) {
      for (int i = 0; i < allIngredients.length; i++) {
        var ingredienctCost = toGrum(
            double.parse(allIngredients[i]['num'].toString()),
            allIngredients[i]['unit']);

        ingredienctCost *= int.parse(_text.text);

        for (int j = 0; j < calculatedItems.length; j++) {
          if (calculatedItems[j]['name'] == allIngredients[i]['name']) {
            for (int k = 0; k < calculatedItems[j]['id'].length; k++) {
              var targetNum = toGrum(getNumFromId(calculatedItems[j]['id'][k]),
                  calculatedItems[j]['unit'][k]);
              ingredienctCost -= targetNum;

              if (ingredienctCost < 0) {
                toUpdate.add({
                  'id': calculatedItems[j]['id'][k],
                  'num': grumToUnit((ingredienctCost).abs(),
                          calculatedItems[j]['unit'][k])
                      .toString(),
                  'name': calculatedItems[j]['name'],
                  'unit': calculatedItems[j]['unit'][k]
                });

                k = calculatedItems[j]['id'].length;
              } else {
                toDelete.add({
                  'id': calculatedItems[j]['id'][k],
                  'name': calculatedItems[j]['name']
                });
              }
            }
          }
        }
      }
    }

    for (int i = 0; i < toDelete.length; i++) {
      await _db.collection('Fridge').document(toDelete[i]['id']).delete();
    }

    for (int i = 0; i < toUpdate.length; i++) {
      await _db
          .collection('Fridge')
          .document(toUpdate[i]['id'])
          .updateData({'num': toUpdate[i]['num'].toString()});
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return main_page(0);
    }));
  }

  Future getImage() async {
    String tmp;
    tmp = await _storage
        .ref()
        .child('Menu')
        .child(this.menu_id)
        .child('menupic.jpg')
        .getDownloadURL();
    setState(() {
      mainImage = tmp;
    });
  }

  Future getIngredientFromFridge() async {
    FirebaseUser user = await _auth.currentUser();
    List<dynamic> tmp = List<dynamic>();
    await _db
        .collection('Fridge')
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((data) {
        var tmpMap = data.data;
        tmpMap['id'] = data.documentID;
        tmp.add(tmpMap);
      });
    });

    setState(() {
      fridgeIngredients = tmp;
      items.clear();
      calculatedItems.clear();
      for (int i = 0; i < fridgeIngredients.length; i++) {
        bool isHas = checkMember(fridgeIngredients[i]['name'])['isHas'];
        int index = checkMember(fridgeIngredients[i]['name'])['index'];
        if (isHas) {
          items[index]['id'].add(fridgeIngredients[i]['id']);
          items[index]['num'].add(fridgeIngredients[i]['num']);
          items[index]['expire'].add(fridgeIngredients[i]['date'] == null
              ? 'ไม่มีกำหนด'
              : '${calculateDate(format.format(fridgeIngredients[i]['date'].toDate()))} วัน');
          items[index]['unit'].add(fridgeIngredients[i]['unit']);
          items[index]['date'].add(fridgeIngredients[i]['date']);
        } else {
          items.add({
            'id': [fridgeIngredients[i]['id']],
            'name': fridgeIngredients[i]['name'],
            'num': [fridgeIngredients[i]['num']],
            'expire': [
              fridgeIngredients[i]['date'] == null
                  ? 'ไม่มีกำหนด'
                  : '${calculateDate(format.format(fridgeIngredients[i]['date'].toDate()))} วัน'
            ],
            'unit': [fridgeIngredients[i]['unit']],
            'date': [fridgeIngredients[i]['date']]
          });
        }
      }
      for (int i = 0; i < items.length; i++) {
        if (items[i]['num'].length > 1) {
          double weightSum = 0;
          Timestamp latestDate;
          int max = 0;
          for (int j = 0; j < items[i]['num'].length; j++) {
            double otherWeight = double.parse(items[i]['num'][j].toString());
            if (items[i]['unit'][0] != items[i]['unit'][j]) {
              otherWeight = toGrum(double.parse(items[i]['num'][j].toString()),
                  items[i]['unit'][0]);
            }
            weightSum += otherWeight;
          }

          for (int j = 0; j < items[i]['date'].length; j++) {
            if (items[i]['date'][j] == null) {
              continue;
            }
            if (max <=
                calculateDate(format.format(items[i]['date'][j].toDate()))) {
              max = calculateDate(format.format(items[i]['date'][j].toDate()));
              latestDate = items[i]['date'][j];
            }
          }

          items[i]['num'] = [weightSum];
          items[i]['date'] = [latestDate];
        }
        calculatedItems.add(items[i]);
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  calculateDate(String date1) {
    List<String> dateList = date1.split('-');

    if (DateTime.now().year > int.parse(dateList[0])) {
      return 0;
    }

    if (DateTime.now().month > int.parse(dateList[1]) &&
        DateTime.now().year == int.parse(dateList[0])) {
      return 0;
    }

    if (DateTime.now().day > int.parse(dateList[2]) &&
        DateTime.now().month == int.parse(dateList[1]) &&
        DateTime.now().year == int.parse(dateList[0])) {
      return 0;
    }

    DateCalc date = DateCalc.fromDateTime(new DateTime.now());
    int diff = date.differenceValue(
        date: DateTime(int.parse(dateList[0]), int.parse(dateList[1]),
            int.parse(dateList[2]) + 1),
        type: DateType.day);

    return diff;
  }

  Map<String, dynamic> checkMember(String value) {
    for (int i = 0; i < items.length; i++) {
      if (items[i]['name'] == value) {
        return {'isHas': true, 'index': i};
      }
    }
    return {'isHas': false, 'index': null};
  }

  double toGrum(double num, String unit) {
    double base = 1;

    if (unit == "กิโล") {
      base = 1000;
    }
    if (unit == "ฟอง") {
      base = 50;
    }
    if (unit == "ช้อนโต๊") {
      base = 12.5;
    }

    return num * base;
  }

  Future getCommentData()async{
    await _db.collection('Menu').document(this.menu_id).get().then((d){
      setState(() {
        commentData = d.data['comments'] == null ? [] : d.data['comments'];
      });
    });
  }

  Future getCommentUser()async{
    for(int i=0; i<commentData.length; i++){
      await _db.collection('User').where('uid', isEqualTo: commentData[i]['uid']).getDocuments().then((d)async{
        String url;
//        url = await _storage.ref().child('User').child(commentData[i]['uid']).child('profile').getDownloadURL().catchError((e){
//          url = d.documents[0]['display'];
//        });

        url = d.documents[0]['display'];

        setState(() {
          commentUserData.add({
            'display': url
          });
        });
      });
    }

  }

  Map<String, dynamic> checkIngredients(list, item) {
    double net1 = 0;
    double net2 = 0;
    for (int i = 0; i < list.length; i++) {
      if (item['name'] == list[i]['name']) {
        net1 = toGrum(double.parse(list[i]['num'].toString()), list[i]['unit']);
        net2 = toGrum(double.parse(item['num'].toString()), item['unit']);

        if (net1 >= net2) {
          return {"isHas": true, "num": '0'};
        } else {
          return {"isHas": false, "num": list[i]['num']};
        }
      }
    }

    return {"isHas": false, "num": '0'};
  }

  Future getMenuDetail() async {
    await _db.collection('Menu').document(this.menu_id).get().then((data) {
      setState(() {
        List<dynamic> tmpMap = List<dynamic>();
        menuDetail = data.data;
        tmpMap = data.data['Ingredients']['Main'];
        for (int i = 0; i < tmpMap.length; i++) {
          tmpMap[i]['type'] = 'main';
          tmpMap[i]['value'] =
              new TextEditingController(text: tmpMap[i]['num'].toString());
        }
        mainIngredients = tmpMap;
        tmpMap = data.data['Ingredients']['Optional'];
        for (int i = 0; i < tmpMap.length; i++) {
          tmpMap[i]['type'] = 'optional';
          tmpMap[i]['value'] =
              new TextEditingController(text: tmpMap[i]['num'].toString());
        }
        optionIngredients = tmpMap;
        allIngredients = mainIngredients + optionIngredients;
      });
    });
  }

  @override
  void initState() {
    isLoading = true;
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingProgress = new LoadingProgress(_animationController);
    // TODO: implement initState
    super.initState();
    _scrollController = PageController(initialPage: 0);
    isFavor = false;
    checkSignIn().then((e) {
      getCommentData().then((e){
        getCommentUser();
      });
      getImage();
      getMenuDetail();
      if (isSignIn) {
        getUserData();
        getIngredientFromFridge();
        loadFavor();
      }
    });
  }

  Future deleteIngredientManual() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 270,
              width: 330,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: Text("รายการวัตถุดิบที่คงเหลือ"),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount:
                            allIngredients == null ? 0 : allIngredients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                        "${index + 1}. ${allIngredients[index]["name"]}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              int tmp = int.parse(
                                                  allIngredients[index]["value"]
                                                      .text);
                                              tmp--;
                                              allIngredients[index]['value']
                                                  .text = tmp.toString();
                                              allIngredients[index]["num"] =
                                                  tmp.toString();
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Icon(Icons.remove),
                                          ),
                                        ),
                                        Container(
                                            height: 25,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            alignment: Alignment.center,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText: null),
                                              controller: allIngredients[index]
                                                  ["value"],
                                            )),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              int tmp = int.parse(
                                                  allIngredients[index]["value"]
                                                      .text);
                                              tmp++;
                                              allIngredients[index]['value']
                                                  .text = tmp.toString();
                                              allIngredients[index]["num"] =
                                                  tmp.toString();
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(
                                              "${allIngredients[index]["unit"]}"),
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
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Icon(Icons.not_interested),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteIngredientFromFridge();
                          },
                          child: Container(
                            child: Icon(Icons.check_circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future deleteIngredientAuto() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 270,
              width: 330,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: Text("รายการวัตถุดิบที่คงเหลือ"),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount:
                            allIngredients == null ? 0 : allIngredients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                        "${index + 1}. ${allIngredients[index]["name"]}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                            height: 25,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            alignment: Alignment.center,
                                            child: checkIngredients(
                                                        fridgeIngredients,
                                                        allIngredients[index])[
                                                    'isHas']
                                                ? TextField(
                                                    enabled: false,
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText: null),
                                                    controller:
                                                        allIngredients[index]
                                                            ["value"],
                                                  )
                                                : TextField(
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText: null),
                                                    controller:
                                                        new TextEditingController(
                                                            text:
                                                                '${checkIngredients(fridgeIngredients, allIngredients[index])['num']}'),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  )),
                                        Container(
                                          width: 40,
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(
                                              "${allIngredients[index]["unit"]}"),
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
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            child: Icon(Icons.not_interested),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteIngredientFromFridge();
                          },
                          child: Container(
                            child: Icon(Icons.check_circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadComment()async{
    setState(() {
      isLoading = true;
    });
    FirebaseUser user = await _auth.currentUser();
    String name = user.displayName;
    await _db.collection('User').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      name = docs.documents[0].data['name'];
    });
    String commentText = _commentText.text;
    List<dynamic> tmp = new List<dynamic>.from(commentData);
    _commentText.text = "";
    tmp.add({
      'name': name,
      'text': commentText,
      'uid': user.uid,
      'updated_at': new DateFormat('yyyy-MM-dd hh:mm:ss').format(new DateTime.now())
    });
    await _db.collection('Menu').document(this.menu_id).updateData({
      'comments': tmp
    });

    await getCommentData();
    await getCommentUser();

    setState(() {
      isLoading = false;
      _currentPage = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _safeTop = MediaQuery.of(context).padding.top;
    return isLoading ? _loadingProgress.getWidget(context) : Scaffold(
      //Here
      resizeToAvoidBottomPadding: false,
      //
      body: Container(
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
                    'ขั้นตอนการทำ',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size:30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isSignIn) {
                            setState(() {
                              isFavor = !isFavor;
                            });
                            if (isFavor) {
                              saveToFavor();
                            } else {
                              deleteFavor();
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            isFavor ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 180,
                    child: mainImage == null
                        ? CircularProgressIndicator()
                        : Image.network(mainImage),
                  ),
                  Container(
                    child: Text(menuDetail == null ? '' : menuDetail['Name'],
                        style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xffFCFCFC),
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
                                        ? Color(0xffFCFCFC)
                                        : Color(0xffE0E0E0),
                                    border: Border(
                                      top: BorderSide(color: Colors.grey),
                                      right: BorderSide(color: Colors.grey),
                                      left: BorderSide(color: Colors.grey),
                                    )),
                                alignment: Alignment.center,
                                height: 40,
                                child: Text(
                                  'ส่วนประกอบ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentPage = 1;
                                  _scrollController.animateToPage(1,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    color: _currentPage == 1
                                        ? Color(0xfffcfcfc)
                                        : Color(0xffE0E0E0),
                                    border: Border(
                                      top: BorderSide(color: Colors.grey),
                                      right: BorderSide(color: Colors.grey),
                                      left: BorderSide(color: Colors.grey),
                                    )),
                                alignment: Alignment.center,
                                height: 40,
                                child: Text(
                                  'วิธีการทำ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentPage = 2;
                                  _scrollController.animateToPage(2,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    color: _currentPage == 2
                                        ? Color(0xfffcfcfc)
                                        : Color(0xffE0E0E0),
                                    border: Border(
                                      top: BorderSide(color: Colors.grey),
                                      right: BorderSide(color: Colors.grey),
                                      left: BorderSide(color: Colors.grey),
                                    )),
                                alignment: Alignment.center,
                                height: 40,
                                child: Text(
                                  'คอมเมนท์',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: PageView(
                          onPageChanged: (int index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          controller: _scrollController,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 35, top: 25, right: 35),
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Main',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 23),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                child: Column(
                                                  children: List.generate(
                                                      mainIngredients == null
                                                          ? 0
                                                          : mainIngredients
                                                              .length,
                                                      (int index) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 200,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 85),
                                                          child: Text(
                                                            mainIngredients[
                                                                index]['name'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 75,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            '${mainIngredients[index]['num'].toString()} ${mainIngredients[index]['unit']}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Optional',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 23),
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: List.generate(
                                                      optionIngredients == null
                                                          ? 0
                                                          : optionIngredients
                                                              .length,
                                                      (int index) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 200,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 85),
                                                          child: Text(
                                                            optionIngredients[
                                                                        index] ==
                                                                    '-'
                                                                ? ''
                                                                : optionIngredients[
                                                                        index]
                                                                    ['name'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 75,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            '${optionIngredients[index] == '-' ? '' : optionIngredients[index]['num'].toString()} ${optionIngredients[index]['unit']}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 23),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Seasoning',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 23),
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: List.generate(
                                                      menuDetail == null
                                                          ? 0
                                                          : menuDetail[
                                                                  'Seasoning']
                                                              .length,
                                                      (int index) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 1),
                                                          child: Text(
                                                            "${index + 1}. ${menuDetail['Seasoning'][index]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              child: ListView(
                                padding: EdgeInsets.all(20),
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: List.generate(
                                          menuDetail == null
                                              ? 0
                                              : menuDetail['Howto'].length,
                                          (int index) {
                                        return Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 350,
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 15,
                                                    right: 15),
                                                child: Text(
                                                  "${menuDetail['Howto'][index]}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            ////////////////// COMMENT //////////////////

                            Container(
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: userUrl == null ? userData ==
                                                null
                                                ? 'assets/user.png'
                                                : userData['display'] == null
                                                ? 'assets/user.png'
                                                : userData['display'] : userUrl,
                                            fit: BoxFit.cover,
                                          ),
                                          margin: EdgeInsets.only(right: 15),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                              top: BorderSide(
                                                  color: Color(0xffEDEDED)),
                                            )),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                    height: 75,
                                                    child: TextField(
                                                      maxLines: null,
                                                      controller: _commentText,
                                                      decoration: InputDecoration
                                                          .collapsed(
                                                              hintText:
                                                                  "พิมพ์ข้อความของคุณ"),
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
                                  Container(
                                    height: 50,
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: (){
                                            uploadComment();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(Radius.circular(12))
                                            ),
                                            child: Text(
                                              "ส่ง",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    color: Colors.grey,
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text("ความคิดเห็น ${commentData == null ? 0 : commentData.length} รายการ", style: TextStyle(color: Colors.white),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Column(
                                      children: List.generate(commentData == null ? 0 : commentUserData == null ? 0 : commentData.length != commentUserData.length ? 0 : commentData.length, (int index){
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
                                          ),
                                          margin: EdgeInsets.only(bottom: 15),
                                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                height: 50,
                                                width: 50,
                                                child: FadeInImage.memoryNetwork(
                                                  placeholder: kTransparentImage,
                                                  image: commentUserData[index]['display'] == null ? 'assets/user.png' : commentUserData[index]['display'],
                                                  fit: BoxFit.cover,
                                                ),
                                                margin: EdgeInsets.only(right: 15),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  height: 50,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(commentData[index]['name']),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child:  Text(commentData[index]['text']),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isSignIn) {
                  deleteIngredientAuto();
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xff5A0000),
                ),
                child: Text(
                  "ลบจำนวนวัตถุดิบออก ตามสูตร",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isSignIn) {
                  deleteIngredientManual();
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 1, bottom: 15),
                alignment: Alignment.center,
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xffB50000),
                ),
                child: Text(
                  "ลบจำนวนวัตถุดิบออก โดยกำหนดเอง",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
