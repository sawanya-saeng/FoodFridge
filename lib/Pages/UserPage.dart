import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:taluewapp/Pages/HowToPage.dart';
import 'package:taluewapp/Pages/LoginPage.dart';
import './AddMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taluewapp/Services/loadingScreenService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'EditUserPage.dart';

class user_page extends StatefulWidget {
  @override
  _user_page createState() => _user_page();
}

class IUser{
  String name;
  String image;
}

class _user_page extends State<user_page> with TickerProviderStateMixin{
  String menu_id;
  int _currentPage = 0;
  PageController _scrollController;
  TextEditingController _searchController = new TextEditingController();
  final _db = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<Map<String,dynamic>> allMenu;
  LoadingProgress _loadingProgress;
  AnimationController _animationController;
  bool isLoaded;
  final _auth = FirebaseAuth.instance;
  IUser user;
  List<String> favorListId = [];
  List<Map<String, dynamic>> favorListMenu = [];
  bool isSignIn = false;
  String _url;
  List<Map<String, dynamic>> myListMenu = [];
  List<String> myListMenuImage = [];

  bool isLoading = false;

  Future checkSignIn()async{
    FirebaseUser user = await _auth.currentUser();
    if(user == null){
      setState(() {
        isSignIn = false;
        isLoaded = false;
      });
    }else{
      setState(() {
        isSignIn = true;
        isLoaded = false;
      });
    }
  }

  Future getFavorId()async{
    final user = await _auth.currentUser();
    setState(() {
      favorListId.clear();
      favorListMenu.clear();
    });
    await _db.collection('Favor').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      docs.documents.forEach((d){
        setState(() {
          favorListId.add(d.data['menu']);
        });
      });
    });

    for(int i=0; i<favorListId.length; i++){
      Map<String, dynamic> tmp = {};
      await _db.collection('Menu').document(favorListId[i]).get().then((d){
        tmp = d.data;
      });

      if(tmp == null){
        continue;
      }
      
      String url = await _storage.ref().child('Menu').child(favorListId[i]).child('menupic.jpg').getDownloadURL().catchError((e){});
      tmp['image'] = url;

      setState(() {
        favorListMenu.add(tmp);
      });
    }
  }

  Future getMyMenu()async{
    setState(() {
      myListMenu.clear();
      myListMenuImage.clear();
    });
    setState(() {
      isLoaded = true;
    });
    final user = await _auth.currentUser();
    List<Map<String, dynamic>> menu_tmp = [];
    List<String> url_tmp = [];
    await _db.collection('Menu').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      docs.documents.forEach((d){
        setState(() {
          var superTmp = {};
          superTmp = d.data;
          superTmp['menu_id'] = d.documentID;
          menu_tmp.add(superTmp);
          url_tmp.add(d.documentID);
        });
      });
    });
    
    setState(() {
      myListMenu = menu_tmp;
    });

    for(int i=0; i<url_tmp.length; i++){
      String tmp = await _storage.ref().child('Menu').child(url_tmp[i]).child('menupic.jpg').getDownloadURL();
      myListMenuImage.add(tmp);
    }

    setState(() {
      isLoaded = false;
    });
  }

  Future deleteMenu(String menu_id) async {
    setState(() {
      isLoaded = true;
    });
    await _db.collection('Menu').document(menu_id).delete();
    await deleteFavor(menu_id);
    setState(() {
      isLoaded = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = new IUser();
    isLoaded = true;
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _loadingProgress = new LoadingProgress(_animationController);
    _scrollController = new PageController(initialPage: 0);

    checkSignIn().then((e){
      if(isSignIn){
        //    getFavMenu();
        getUserData();
        getFavorId();
        getMyMenu();
      }
    });
  }

  Future getUserData()async{
    //Get google account data
    FirebaseUser userTmp = await _auth.currentUser();
    setState(() {
      isLoaded = true;
    });
    String urlTmp;
    urlTmp = await _storage.ref().child('User').child(userTmp.uid).child('profile').getDownloadURL().catchError((e){
      urlTmp = null;
    });
    setState(() {
      _url = urlTmp;
    });

    await _db.collection('User').where('uid', isEqualTo: userTmp.uid).getDocuments().then((docs){
      setState(() {
        this.user.name = docs.documents[0].data['name'];
        this.user.image = docs.documents[0].data['display'];
      });
    });

    setState(() {
      isLoaded = false;
    });
  }

  Future getFavMenu()async{
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
      allMenu = tmp;
      isLoaded = false;
    });
  }

  Future deleteFavor(docId) async {
    FirebaseUser user = await _auth.currentUser();
    await _db
        .collection('Favor')
        .where('uid', isEqualTo: user.uid)
        .where('menu', isEqualTo: docId)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((d) {
        _db.collection('Favor').document(d.documentID).delete();
      });
    });
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded ? _loadingProgress.getSubWidget(context) : isSignIn == null ? Container() : isSignIn ? Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Container(
              height: 60,
              alignment: Alignment.center,
              color: Color(0xffB15B25),
              child: Text(
                'ข้อมูลส่วนตัว',
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) {
                          return edit_user();
                        }));
              },
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: this._url == null ? this.user.image == null ? AssetImage('assets/user.png') :NetworkImage(this.user.image) :  NetworkImage(_url),fit: BoxFit.cover)
                ),
              ),
              Container(
                child: Text(this.user.name == null ? 'Loading' : this.user.name,
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
                              'สูตรอาหารของคุณ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
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
                              'เมนูอาหารที่บันทึกไว้',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
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
                    child: PageView(
                      onPageChanged: (int index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      controller: _scrollController,
                      children: <Widget>[
                        Container(
                          child: myListMenu == null ? Container() : myListMenu.length > 0 ?
                          ListView.builder(
                            padding: EdgeInsets.all(20),
                            itemCount: myListMenu == null ? 0 : myListMenuImage == null ? 0 : myListMenuImage.length != myListMenu.length ? 0 : myListMenu.length + 1,
                            itemBuilder: (BuildContext context, int index){
                              if(index == myListMenu.length){
                                return GestureDetector(
                                  onTap: ()async {
                                    await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return add_menu();
                                        }));
                                    getMyMenu();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Icon(Icons.add),
                                        ),
                                        Container(
                                          child: Text("เพิ่มเมนู",style: TextStyle(fontSize: 25),),
                                        ),
                                      ],
                                    )
                                  ),
                                );
                              }
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child:  Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      height: 120,
                                      width: 160,
                                      child: Image.network(
                                        myListMenuImage[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                myListMenu[index]['Name'],
                                                style: TextStyle(
                                                    color: Color(0xff914d1f),
                                                    fontSize: 25),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                                          return howto_page(myListMenu[index]['menu_id']);
                                                        }));
                                                      },
                                                      child: Container(
                                                        alignment:
                                                        Alignment.center,
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
                                                  GestureDetector(
                                                    onTap: (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (context){
                                                            return PlatformAlertDialog(
                                                              title: Text('เดี๋ยวก่อน!'),
                                                              content: SingleChildScrollView(
                                                                child: ListBody(
                                                                  children: <Widget>[
                                                                    Text("ยืนกันการลบเมนูหรือไม่"),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                PlatformDialogAction(
                                                                  child: Text('ยกเลิก'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                                PlatformDialogAction(
                                                                  child: Text('ตกลง'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                    deleteMenu(myListMenu[index]['menu_id']).then((e){
                                                                      getMyMenu();
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 50,
                                                        color: Colors.green,
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
                          ):
                          ListView(
                            children: <Widget>[
                              GestureDetector(
                                onTap: ()async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return add_menu();
                                  }));
                                  print('asdadasdasdsad11111111111');
                                  getMyMenu();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top:30),
                                  height: 210,
                                  child: Image.asset('assets/write.png'),
                                ),
                              ),

                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            itemCount: favorListId == null ? 0 : favorListMenu == null ? 0 : favorListId.length == favorListMenu.length ? favorListId.length : 0,
                            itemBuilder: (BuildContext context, int index){
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child:  Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      height: 120,
                                      width: 160,
                                      child: Image.network(favorListMenu[index]['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                favorListMenu[index]['Name'],
                                                style: TextStyle(
                                                    color: Color(0xff914d1f),
                                                    fontSize: 27),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                                          return howto_page(favorListId[index]);
                                                        }));
                                                      },
                                                      child: Container(
                                                        alignment:
                                                        Alignment.center,
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

                                                  GestureDetector(
                                                    onTap: (){
                                                      showDialog(context: context,builder: (context){
                                                        return PlatformAlertDialog(
                                                          title: Text('ยืนยันการลบหรือไม่?'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(' '),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            PlatformDialogAction(
                                                              child: Text('ยกเลิก'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            PlatformDialogAction(
                                                              child: Text('ตกลง'),
                                                              onPressed: () {
                                                                deleteFavor(favorListId[index]).then((e){
                                                                  getFavorId();
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 47,
                                                        color: Colors.green,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            _auth.signOut().then((e){
              _googleSignIn.signOut().then((e){
                Navigator.popUntil(context, (route)=> route.isFirst);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return login_page();
                }));
              });
            });
          },
          child: Container(
            color: Colors.redAccent,
            height: 60,
            alignment: Alignment.center,
            child: Text('ออกจากระบบ', style: TextStyle(color: Colors.white, fontSize: 28)),
          ),
        )
      ],
    ):Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.popUntil(context, (route)=> route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return login_page();
              }));
            },
            child: Container(
              color: Colors.lightGreen,
              height: 60,
              alignment: Alignment.center,
              child: Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white, fontSize: 28)),
            ),
          )
        ],
      ),
    );
  }
}
