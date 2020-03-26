import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    await _db.collection('Favor').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      docs.documents.forEach((d){
        setState(() {
          favorListId.add(d.data['menu']);
        });
      });
    });

    for(int i=0; i<favorListId.length; i++){
      await _db.collection('Menu').document(favorListId[i]).get().then((d){
        setState(() {
          favorListMenu.add(d.data);
        });
      });
    }
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
    urlTmp = await _storage.ref().child('User').child(userTmp.uid).getDownloadURL().catchError((e){
      urlTmp = null;
    });
    setState(() {
      _url = urlTmp;
    });

    await _db.collection('User').where('uid', isEqualTo: userTmp.uid).getDocuments().then((docs){
      setState(() {
        this.user.name = docs.documents[0].data['name'];
        this.user.image = docs.documents[0].data['display'];
        isLoaded = false;
      });
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
                child: Icon(
                  Icons.settings,
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
                  image: DecorationImage(image: this._url == null ? this.user.image == null ? AssetImage('assets/user.png') :NetworkImage(this.user.image) :  AssetImage('assets/user.png'),fit: BoxFit.cover)
                ),
              ),
              Container(
                child: Text(this.user.name,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return add_menu();
                                  }));
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.asset('assets/write.png'),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'เขียนสูตรอาหารเลย',
                                  style: TextStyle(
                                      color: Color(0xffA5A5A5), fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            itemCount: favorListId == null ? 0 : favorListId.length,
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
                                      child: Image.asset(
                                        'assets/menu1.jpg',
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
                                                    fontSize: 30),
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
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 50,
                                                      color: Colors.green,
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

//                            children: <Widget>[
//                              Container(
//                                child: Row(
//                                  children: <Widget>[
//                                    Container(
//                                      decoration: BoxDecoration(
//                                        border: Border.all(color: Colors.black),
//                                      ),
//                                      height: 120,
//                                      width: 160,
//                                      child: Image.asset(
//                                        'assets/menu1.jpg',
//                                        fit: BoxFit.cover,
//                                      ),
//                                    ),
//                                    Expanded(
//                                      child: Container(
//                                        padding: EdgeInsets.only(left: 15),
//                                        child: Column(
//                                          children: <Widget>[
//                                            Container(
//                                              child: Text(
//                                                'ผัดเต้าหู้มะเขือเทศ',
//                                                style: TextStyle(
//                                                    color: Color(0xff914d1f),
//                                                    fontSize: 30),
//                                              ),
//                                            ),
//                                            Container(
//                                              child: Row(
//                                                mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceBetween,
//                                                children: <Widget>[
//                                                  Expanded(
//
//                                                    child: Container(
//                                                      alignment:
//                                                          Alignment.center,
//                                                      height: 40,
//                                                      color: Color(0xff914d1f),
//                                                      child: Text(
//                                                        "วิธีการทำ",
//                                                        style: TextStyle(
//                                                            color: Colors.white,
//                                                            fontSize: 20),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                  Container(
//                                                    margin: EdgeInsets.only(
//                                                        left: 10),
//                                                    child: Icon(
//                                                      Icons.delete,
//                                                      size: 50,
//                                                      color: Colors.green,
//                                                    ),
//                                                  ),
//                                                ],
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ],
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
