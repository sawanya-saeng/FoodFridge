import 'package:flutter/material.dart';

class LoadingProgress{
  LoadingProgress(this._animationController);
  AnimationController _animationController;
  double _progress = 0;
  String _progressText = '';

  void setProgress(double progress){
    this._progress = progress;
  }

  void setProgressText(String progress){
    this._progressText = progress;
  }

  Widget getWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
//                  Navigator.of(context).pop();
                },
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(50),
                    child: Image.asset("assets/logofoodfridge.png"),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              alignment: Alignment.centerLeft,
              duration: Duration(milliseconds: 200),
              height: 3,
              width: _progress,
              color: Colors.yellowAccent,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                _progressText,
                style: TextStyle(
                    color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSubWidget(BuildContext context) {
    return Container(
      color: Color(0xffFC9002),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
//                Navigator.of(context).pop();
              },
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(50),
                  child: Image.asset("assets/logofoodfridge.png"),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            alignment: Alignment.centerLeft,
            duration: Duration(milliseconds: 200),
            height: 3,
            width: _progress,
            color: Colors.yellowAccent,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              _progressText,
              style: TextStyle(
                  color: Colors.yellowAccent, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}