import 'package:flutter/material.dart';
import 'package:flutter_app/screens/forget_password.dart';
import '../constants.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading);
  final bool _isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn; //submitFn is a property in class AuthForm of type function that returns nothing and has the given properties as same to that in auth_screen

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var username = '';
  var email = '';
  var password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate(); //called to validate the form from _fomkey calling validators,current state gives access to the form
    FocusScope.of(context).unfocus(); //turns off the keyboard

    if (isValid) {
      _formKey.currentState
          .save(); //triggers the onsave function on text fields to get the values
      widget.submitFn(
          email.trim(), password.trim(), username.trim(), _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      'T G H S',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.yellow.shade800,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                TextFormField(
                    key: ValueKey('email'),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Email is Required';
                      }
                      if (!RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                        return 'Please enter a valid email Address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email')),
                SizedBox(height: 12.0),
                if (!_isLogin)
                  TextFormField(
                      key: ValueKey('username'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        username = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your Username')),
                SizedBox(height: 12.0),
                TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Password must be at least 8 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password')),
                SizedBox(height: 12.0),
                if (widget._isLoading)
                  LinearProgressIndicator(
                    backgroundColor: Colors.yellow.shade800,
                  ),
                if (!widget._isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    color: Colors.green,
                    onPressed: _trySubmit,
                  ),
                if (!widget._isLoading)
                  FlatButton(
                    textColor: Colors.tealAccent,
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'Already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLogin)
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password!!!',
                        style: TextStyle(
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, ForgetPasswordScreen.id);
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
