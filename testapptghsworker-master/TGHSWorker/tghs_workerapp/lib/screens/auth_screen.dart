import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/components/auth_form.dart';
import 'package:flutter_app/screens/user_form_screen.dart';
import 'home_screen.dart';
// import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  static const String id = 'auth_screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var errorMessage;
  bool _isLoading = false;
  //to submit the form
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential _userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id,(r) => false);
        setState(() {
          _isLoading = false;
        });
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('worker')
            .doc(_userCredential.user.uid)
            .set({'username': username, 'email': email});
        Navigator.pushReplacementNamed(context, UserFormScreen.id);
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
        // setState(() {
        //   errorMessage = message;
        // });
        print(message);
      }
      // Scaffold.of(ctx).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: Theme
      //         .of(ctx)
      //         .errorColor,
      //   ),
      // );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        errorMessage = error.toString();
        _isLoading = false;
      });
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }
}
