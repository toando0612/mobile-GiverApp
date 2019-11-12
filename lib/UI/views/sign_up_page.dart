import 'dart:ui' as prefix0;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/enum/view_state.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email;
  String _password;
  String _username;
  String _address;
  String _selected;
  String _errorMessage = '';
  var _state;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _usernameController = TextEditingController();
  final _addressController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmpasswordFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  void onChanged(String value) {
    setState(() {
      _selected = value;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const menuCategories = <String>[
    'Food',
    'Clothing',
    'Accessories',
  ];
  final List<DropdownMenuItem<String>> _dropdownMenuCategories = menuCategories
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  static const menuRoles = <String>[
    'Customer',
    'Merchant',
  ];
  final List<DropdownMenuItem<String>> _dropdownMenuRoles = menuRoles
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  String _selectedCate;
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
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Center(
              child: Text('Register'),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        title: Text('Who are you ?'),
                        trailing: DropdownButton(
                          value: _selected,
                          hint: Text('Role'),
                          onChanged: (String newValue) {
                            setState(() {
                              _selected = newValue;
                            });
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                          items: _dropdownMenuRoles,
                        ),
                      ),
                      Container(
                        height: 4.0,
                      ),
                      Container(
                        height: 4.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _emailFocus, _usernameFocus);
                        },
                        controller: _emailController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Provide an email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        onSaved: (input) => _email = input,
                      ),
                      Container(
                        height: 4.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _usernameFocus,
                        onFieldSubmitted: (term) {
                          _selected == 'Customer'
                              ? _fieldFocusChange(
                                  context, _usernameFocus, _passwordFocus)
                              : _usernameFocus.unfocus();
                        },
                        controller: _usernameController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Provide a username';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                            hintText: _selected == 'Merchant'
                                ? 'Display Store Name'
                                : 'Username',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        onSaved: (input) => _username = input,
                      ),
                      Container(
                        height: 4.0,
                      ),
                      _selected == 'Merchant'
                          ? Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text('Category'),
                                  trailing: DropdownButton(
                                    value: _selectedCate,
                                    hint: Text('Choose'),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _selectedCate = newValue;
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(_addressFocus);
                                    },
                                    items: _dropdownMenuCategories,
                                  ),
                                ),
                                Container(
                                  height: 4.0,
                                ),
                                TextFormField(
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _addressFocus,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(
                                        context, _addressFocus, _passwordFocus);
                                  },
                                  controller: _addressController,
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Provide a address';
                                    } else if (input.length < 6) {
                                      return 'Address must have at least 6 characters';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      hintText: "Address",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0))),
                                  onSaved: (input) => _address = input,
                                ),
                                Container(
                                  height: 4.0,
                                ),
                              ],
                            )
                          : Container(
                              height: 4.0,
                            ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _passwordFocus, _confirmpasswordFocus);
                        },
                        controller: _passwordController,
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
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                      Container(
                        height: 4.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        focusNode: _confirmpasswordFocus,
                        onFieldSubmitted: (term) {
                          _confirmpasswordFocus.unfocus();
                          signUp();
                        },
                        controller: _confirmController,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Provide a confirm password';
                          } else if (input.length < 6) {
                            return 'Password must have at least 6 characters';
                          } else if (input != _passwordController.text) {
                            return 'Confirm password did not match!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                            hintText: "Confirm password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        obscureText: true,
                      ),
                      Container(
                        height: 30.0,
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: signUp,
                            child: Text('Sign up'),
                          ),
                          FlatButton(
                            child: Text(
                              'Have an account? Login !',
                              style: TextStyle(color: Colors.black54),
                            ),
                            onPressed: backLogin,
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }

  Future<void> signUp() async {
    setState(() {
      _state == ViewState.Busy;
    });
    if (_formKey.currentState.validate()) {
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));// bug when not using inside Scafford
      _formKey.currentState.save();
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .catchError((error) {
          setState(() {
            _errorMessage = error.code == 'ERROR_EMAIL_ALREADY_IN_USE'
                ? 'Email is already exist!'
                : 'Please try again!';
          });
          return null;
        });
        if (result.user != null) {
          result.user.sendEmailVerification();
          print("send email to-->");
          print(_emailController.text);
          Firestore.instance.runTransaction((Transaction transaction) async {
            CollectionReference reference =
                Firestore.instance.collection('users');
            if (_selected == 'Customer') {
              await reference.document(result.user.uid).setData({
                "email": _email,
                "username": _username,
                "level": 1,
              });
            } else {
              await reference.document(result.user.uid).setData({
                "email": _email,
                "username": _username,
                "level": 2,
                "address": _address,
                "category": _selectedCate
              });
            }
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInPage()));
        }
        setState(() {
          _state == ViewState.DataFetched;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void backLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
