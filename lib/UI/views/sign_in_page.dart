import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giver_app/UI/views/home_view.dart';
import 'package:giver_app/UI/views/block_home_page.dart';
import 'package:giver_app/UI/views/sign_up_page.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/enum/view_state.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _inputController = TextEditingController();
  String _errorMessage = '';
  var _state;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  Flushbar flush;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    _fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
    return BusyOverlay(
        show: this._state == ViewState.Busy,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(height: 20.0,),
                    Image.asset('assets/upup.png'),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              focusNode: _emailFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _emailFocus, _passwordFocus);
                              },
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide an email';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              onSaved: (input) => _email = input,
                            ),
                            Container(height: 5.0),
                            TextFormField(
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                              focusNode: _passwordFocus,
                              onFieldSubmitted: (value) {
                                _passwordFocus.unfocus();
                                signIn();
                              },
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide a password';
                                } else if (input.length < 6) {
                                  return 'Password must have at least 6 characters';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              onSaved: (input) => _password = input,
                              obscureText: true,
                            ),
                            Container(
                                height: 15.0,
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.red),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: signIn,
                                  child: Text('Sign in'),
                                ),
                                Container(
                                  width: 50.0,
                                ),
                                RaisedButton(
                                  onPressed: signUp,
                                  child: Text('Sign up'),
                                ),
                              ],
                            ),
                            FlatButton(
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text(
                                              'Please enter your email'),
                                          content: TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: validateEmail,
                                            controller: _inputController,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 15.0),
                                                hintText: "Email",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0))),
//                        onSaved: (input) => _username = input,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () => Navigator.pop(
                                                  context,
                                                  _inputController.text),
                                            )
                                          ],
                                        )).then((returnVal) {
                                  if (returnVal != null) {
                                    print('return Val not null');
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: _inputController.text);
                                    print('email sent to' +
                                        _inputController.text);
                                    flush = Flushbar<bool>(
                                      flushbarPosition: FlushbarPosition.BOTTOM,
                                      title: "Congratulations!",
                                      message: "Password Reset sent!",
                                      duration: Duration(seconds: 4),
                                    )..show(context);
                                  }
                                });
                              },
                            ),
                          ],
                        ))
                  ],
                )),
          ),
        ));
  }

  Future<void> signIn() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        AuthResult result = await firebaseAuth
            .signInWithEmailAndPassword(email: _email, password: _password)
            .catchError((error) {
          setState(() {
            _errorMessage = error.code.toString();
          });
        }).whenComplete(() {
          setState(() {
            _state = ViewState.DataFetched;
          });
        });
        if (result.user.isEmailVerified) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeView(user: result.user)));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BlockHomePage(user: result.user)));
        }
      } catch (e) {
        return AlertDialog(
          title: Text('error'),
        );
      }
    } else {
    }
  }

  void signUp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
