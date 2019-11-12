import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("abc"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 6, 
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text("Categories"))),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: FlatButton(
                      child: Text("View all >"),
                      onPressed: null,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/logo.png'),
                    ),
                   Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Grocery', textAlign: TextAlign.center,))
                  ],
                ),
                Container(
                  width: 44,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/logo.png'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Grocery', textAlign: TextAlign.center,))
                  ],
                ),
                 Container(
                  width: 44,
                ),
                Column(
                  children: <Widget>[
                    Container(
                       alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(left: 20),
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/logo.png'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Grocery', textAlign: TextAlign.center,))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
