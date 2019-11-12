import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
  return double.parse(s, (e) => null) != null ||
      int.parse(s, onError: (e) => null) != null;
}

class CharityInfo extends StatelessWidget {
  final BuildContext context;
  final UserHomeViewModel model;
  final User customer;
  final String charityId;

  CharityInfo(
      {@required this.context,
      @required this.model,
      @required this.customer,
      @required this.charityId});

  int donatePoints;
  final _inputController = TextEditingController();
  Flushbar flush;

  @override
  Widget build(BuildContext context) {
    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
      return double.parse(s, (e) => null) != null ||
          int.parse(s, onError: (e) => null) != null;
    }

    var currentCharity = model.getCharityById(model.charities, charityId);


    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(flex:8,child: SizedBox(height: 265.0)),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(220, 220, 220, 1.0),
                            )
                          ],
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(18.0)),
                      child: RichText(
                        text: TextSpan(
                          text: '\$',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: currentCharity.credits.toString(),
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20.0)),
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(currentCharity.imageUrl),
                fit: BoxFit.fill,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 20.0,
          top: 40.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        )
      ],
    );

    final bottomContentText = Column(
      children: <Widget>[
        Text(
          currentCharity.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        RichText(
          text: TextSpan(
            text: currentCharity.name,
            style: TextStyle(fontSize: 15, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: ' helps a lot of',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: ' people around .....',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
    onDonate(String value, BuildContext context) async {
      print('donate');
      bool result = await model.onDonate(

          currentCharity.id, customer.id,int.parse(value),customer.points,);


      if (result) {
        flush = Flushbar<bool>(
          flushbarPosition: FlushbarPosition.BOTTOM,
          title: "Donate Successful",
          message: "Donated $value Credits to " + currentCharity.name,
          duration: Duration(seconds: 4),
        )..show(context);
      } else {
        flush = Flushbar<bool>(
          flushbarPosition: FlushbarPosition.BOTTOM,
          title: "Donate Fail",
          message: "Failed to donate $value Credits to " + currentCharity.name,
          duration: Duration(seconds: 4),
        )..show(context);
      }
    }

    final donateButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Number of credits ?'),
                      content: TextFormField(
                        controller: _inputController,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                            hintText: "credits",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
//                        onSaved: (input) => _username = input,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () =>
                              Navigator.pop(context, _inputController.text),
                        )
                      ],
                    )).then((returnVal) {
              if (returnVal != null) {
                print('return Val not null');
                if (!isNumeric(returnVal)) {
                  print('return Val not an Number');
                } else {
                  onDonate(returnVal, context);
                }
              }
            });
          },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("DONATE THEM", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, donateButton],
        ),
      ),
    );

    return BaseView<UserHomeViewModel>(
        builder: (context, child, model) => Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              body: Column(
                children: <Widget>[
                  Expanded(flex:5,child: topContent),
                  Expanded(
                    flex:1, child: Divider(
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(flex: 4,child: bottomContent)
                ],
              ),
            ));
  }
}
