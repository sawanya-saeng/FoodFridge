import 'package:flutter/material.dart';

class bin_page extends StatefulWidget {
  @override
  _bin_page createState() => _bin_page();
}

class _bin_page extends State<bin_page> {
  int click;
  List<String> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    click = 0;
    items = ['1'];
  }

  @override
  Widget build(BuildContext context) {
    _deleteAlert(index, String del) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are you sure?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      setState(() {
                        items.insert(index, del);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Confirm')),
              ],
            );
          });
    }

    return Column(
      children: <Widget>[
        Container(
          height: 60,
          alignment: Alignment.center,
          color: Color(0xffB15B25),
          child: Text(
            'หมดอายุ',
            style: TextStyle(color: Colors.white, fontSize: 35),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 1),
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  color: Color(0xffC3C3C3),
                  alignment: Alignment.center,
                  child: Text(
                    'วัตถุดิบ',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Color(0xffC41C0D),
                  alignment: Alignment.center,
                  child: Text(
                    'คงเหลือ',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Color(0xffE58200),
                  alignment: Alignment.center,
                  child: Text(
                    'วันที่เหลือ',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
//                                child: Text(ingres[index].data['date'].toDate().toString()),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      background: Container(
                        color: Colors.green,
                        child: Icon(Icons.check),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Icon(Icons.cancel),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          _deleteAlert(index, items[index]);
                          print(direction);
                          items.removeAt(index);
                        });
                      },
                      key: Key(items[index]),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 100,
                        color: Colors.green,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: Color(0xffFCFCFC),
                                alignment: Alignment.center,
                                child: Text(
                                  'Food ${index}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Color(0xffE3392A),
                                alignment: Alignment.center,
                                child: Text(
                                  'หมด',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      Container(
                                        color: Color(0xffFC9002),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '4 วัน',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
//                                child: Text(ingres[index].data['date'].toDate().toString()),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        child: Text(
                                          '30/10/2019',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        color: Color(0xffE58200),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ),

      ],
    );
  }
}

