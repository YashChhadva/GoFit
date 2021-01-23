import 'dart:math';
import 'package:provider/provider.dart';
import './services/http_exception.dart';

import './services/authProvider.dart';

import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(32, 26, 48, 1),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Flexible(
                  //   child: Container(
                  //     margin: EdgeInsets.only(bottom: 20.0),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                  //     transform: Matrix4.rotationZ(-8 * pi / 180)
                  //       ..translate(-10.0),
                  //     // ..translate(-10.0),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: Colors.deepOrange.shade900,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           blurRadius: 8,
                  //           color: Colors.black26,
                  //           offset: Offset(0, 2),
                  //         )
                  //       ],
                  //     ),
                  //     child: Text(
                  //       'MyShop',
                  //       style: TextStyle(
                  //         color: Theme.of(context).accentTextTheme.title.color,
                  //         fontSize: 50,
                  //         fontFamily: 'Anton',
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Text(
                  //   _authMode==AuthMode.Login ? "Don't Have An Account? Sign Up" : 'Already Have An Account? Sign In',
                  // )
                  Text(
                    'Go-Fit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      // fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'fullname': '',
    'contactnumber': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: _authMode == AuthMode.Signup ? 490 : 280,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 490 : 280),
      width: deviceSize.width * 0.75,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (_authMode == AuthMode.Signup)
                Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromRGBO(56, 48, 76, 1)),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      focusColor: Colors.white54,
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                    ),
                    // obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            // if (value != _passwordController.text) {
                            //   return 'Passwords do not match!';
                            // }
                            return null;
                          }
                        : null,
                  ),
                ),
              if (_authMode == AuthMode.Signup)
                Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromRGBO(56, 48, 76, 1)),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    enabled: _authMode == AuthMode.Signup,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      focusColor: Colors.white54,
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                    ),
                    // obscureText: true,
                    // validator: _authMode == AuthMode.Signup
                    //     ? (value) {
                    //         // if (value != _passwordController.text) {
                    //         //   return 'Passwords do not match!';
                    //         // }
                    //       }
                    //     : null,
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(56, 48, 76, 1)),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    focusColor: Colors.white54,
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    // return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(56, 48, 76, 1)),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    focusColor: Colors.white54,
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
              ),
              if (_authMode == AuthMode.Signup)
                Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromRGBO(56, 48, 76, 1)),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      focusColor: Colors.white54,
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  child:
                      Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Color.fromRGBO(13, 245, 227, 1),
                  textColor: Colors.black,
                ),
              GestureDetector(
                child: Text(
                    _authMode == AuthMode.Login
                        ? "Don't Have An Account? Sign Up"
                        : 'Already Have An Account? Sign In',
                    style: TextStyle(color: Color.fromRGBO(13, 245, 227, 1))),
                // '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                onTap: _switchAuthMode,
                // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
