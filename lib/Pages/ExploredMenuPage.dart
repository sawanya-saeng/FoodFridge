import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/ExploredMenu/CanDoMenuPage.dart';
import 'package:taluewapp/Pages/ExploredMenu/MayBeMenuPage.dart';

class explored_page extends StatefulWidget {
  @override
  _explored_page createState() => _explored_page();
}

class _explored_page extends State<explored_page> {
  int _currentPage = 0;
  PageController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              ? Color(0xffFC9002)
                              : Color(0xffffffff),
                          border: Border.all(color: Color(0xffFC9002))),
                      alignment: Alignment.center,
                      height: 55,
                      child: Text(
                        'เมนูอาหารที่สามารถทำได้',
                        style: TextStyle(color:  _currentPage == 0 ? Colors.white: Color(0xffFC9002), fontSize: 20),
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
                              ? Color(0xffFC9002)
                              : Color(0xffffffff),
                          border: Border.all(color: Color(0xffFC9002))),
                      alignment: Alignment.center,
                      height: 55,
                      child: Text(
                        'เมนูอาหารที่เทียบเคียง',
                        style: TextStyle(color: _currentPage == 1 ? Colors.white: Color(0xffFC9002), fontSize: 20),
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
                controller: _scrollController,
                children: <Widget>[
                  cando_page(),
                  maybe_page()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
