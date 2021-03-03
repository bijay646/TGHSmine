//import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app/components/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/components/painter_rating.dart';
import 'package:flutter_app/components/plumber_rating.dart';
//import 'package:flutter_app/components/user_image_picker.dart';
import 'package:flutter_app/screens/home_screen.dart';

class UpdateFormScreen extends StatefulWidget {
  static const String id = 'update_form_screen';
  @override
  _UpdateFormScreenState createState() => _UpdateFormScreenState();
}

class _UpdateFormScreenState extends State<UpdateFormScreen> {
  Future _data;
  String imageurl;
  String verificationStatus;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String userID, _payment, _years, _username, _phoneNumber;
  String workerCategory = '';
  bool isLoading = false;
  double rating;
  final _paymentPerHourFocusNode = FocusNode();
  final _experienceFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _data = FirebaseFirestore.instance.collection('worker').doc(userID).get();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        userID = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _paymentPerHourFocusNode.dispose();
    _experienceFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    try {
      setState(() {
        isLoading = true;
      });
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState.save();
      }
      if (workerCategory == 'plumber') {
        PlumberRating plumberRating = PlumberRating(
            payment: double.parse(_payment), we: int.parse(_years));
        rating = plumberRating.calculateRating();

        // FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(userID)
        //     .get()
        //     .then((DocumentSnapshot snapshot) {
        //   if (snapshot.exists) {
        //     String imageurl = document.getString('verification');
        //   }
        // });



        await FirebaseFirestore.instance
            .collection('plumber')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'phoneNumber': _phoneNumber,
          'years': _years,
          'rating': rating,
          'uid': userID,
          'verification': verificationStatus
        }, SetOptions(merge: true));
        await FirebaseFirestore.instance
            .collection('worker')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'years': _years,
          'phoneNumber': _phoneNumber,
          'category': workerCategory,
          'uid': userID,
          'verification': verificationStatus
        }, SetOptions(merge: true));
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id,(r) => false);
      }
      if (workerCategory == 'painter') {
        PainterRating painterRating = PainterRating(
            payment: double.parse(_payment), we: int.parse(_years));
        rating = painterRating.calculateRating();
        await FirebaseFirestore.instance
            .collection('painter')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'phoneNumber': _phoneNumber,
          'years': _years,
          'rating': rating,
          'uid': userID,
          'verification': verificationStatus
        });
        await FirebaseFirestore.instance
            .collection('worker')
            .doc(loggedInUser.uid)
            .update({
          'username': _username,
          'payment': _payment,
          'years': _years,
          'phoneNumber': _phoneNumber,
          'category': workerCategory,
          'uid': userID,
          'verification': verificationStatus
        });
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id,(r) => false);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blueGrey[800],
        title: Text(
            'Update Details Page',
          style: TextStyle(
            color: Colors.yellow.shade800,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text('Loading...'),
                );
              }
              else {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(snapshot.data['image_url']),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Username'),
                          readOnly: true,
                          initialValue: snapshot.data['username'],
                          onSaved: (String value) {
                            _username = value;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Verified Status'),
                          readOnly: true,
                          initialValue: snapshot.data['verification'],
                          onSaved: (String value) {
                            verificationStatus = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'category'),
                          readOnly: true,
                          initialValue: snapshot.data['category'],
                          onSaved: (String value) {
                            workerCategory = value;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Payment per hour'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          initialValue: snapshot.data['payment'],
                          focusNode: _paymentPerHourFocusNode,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Payment is Required';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _payment = value;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_phoneNumberFocusNode);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          maxLength: 10,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          focusNode: _phoneNumberFocusNode,
                          initialValue: snapshot.data['phoneNumber'],
                          validator: (String value) {
                            if (value.isEmpty || value.length < 10) {
                              return 'Enter your phone number';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _phoneNumber = value;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_experienceFocusNode);
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Years of Experience'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          initialValue: snapshot.data['years'],
                          focusNode: _experienceFocusNode,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'This field is Required';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _years = value;
                          },
                        ),
                        SizedBox(height: 10.0),
                        RaisedButton(
                          child: Text('Update'),
                          color: Colors.yellow.shade800,
                          onPressed: _submitForm,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
