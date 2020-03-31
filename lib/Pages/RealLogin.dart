import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taluewapp/Pages/FridgePage.dart';
import 'MainPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class real_page extends StatefulWidget {
  @override
  _real_page createState() => _real_page();
}

class _real_page extends State<real_page> {
  FirebaseMessaging _firebaseMessaging;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;

  Future logInWithGoogle() async {
    String meessage_token = await _firebaseMessaging.getToken();
    if(await _googleSignIn.isSignedIn() == false){
      _googleSignIn.signOut();
    }
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    await _auth.signInWithCredential(credential);

    FirebaseUser user = await _auth.currentUser();

    var userData = await isMember();
    if(userData['isHas']){
      _db.collection('User').document(userData['docId']).updateData({
        'message_token': meessage_token
      });
    }else{
      _db.collection('User').add({
        'name': user.displayName == null ? '' : user.displayName,
        'uid': user.uid == null ? '' : user.uid,
        'display': user.photoUrl == null ? '' : user.photoUrl,
        'email': user.email == null ? '' : user.email,
        'phone': user.phoneNumber == null ? '' : user.phoneNumber,
        'message_token': meessage_token
      });
    }
  }

  Future<Map<String, dynamic>> isMember()async{
    FirebaseUser user = await _auth.currentUser();
    bool isHas = false;
    String docId = '';
    await _db.collection('User').where('uid', isEqualTo: user.uid).getDocuments().then((docs){
      if(docs.documents.length > 0){
        isHas = true;
        docId = docs.documents[0].documentID;
      }
    });

    return {
      'isHas': isHas,
      'docId': docId
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20,top: 10),
                  alignment: Alignment.topLeft,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 30,
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        'กลับ',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 150, right: 150),
                            child: Image.asset('assets/google.png'),
                          ),
                          Container(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              logInWithGoogle().then((e){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return main_page(0);
                                }));
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xfff3181d),
                                    borderRadius: BorderRadius.all(Radius.circular(30))),
                                height: 50,
                                width: 270,
                                alignment: Alignment.center,
                                child: Text(
                                  'เข้าสู่ระบบด้วย Google',
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}