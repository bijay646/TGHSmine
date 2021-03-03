import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/components/painter_rating.dart';
import 'package:flutter_app/components/plumber_rating.dart';
import 'package:flutter_app/components/user_image_picker.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserFormScreen extends StatefulWidget {
  static const String id = 'user_form_screen';

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  File _userImageFile;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String userID, _payment, _years, _username, _phoneNumber;
  bool isLoading = false;
  double rating;
  String verficationStatus = 'Not Verified';

  final _paymentPerHourFocusNode = FocusNode();
  final _experienceFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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


  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final categoryselected = TextEditingController();
  String workerCategory = '';
  List<String> category = [
    "plumber",
    "painter",
  ];

  @override
  void dispose() {
    _paymentPerHourFocusNode.dispose();
    _experienceFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    categoryselected.dispose();
    super.dispose();
  }

  void _submitForm() async {
    try {
      setState(() {
        isLoading = true;
      });
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (_userImageFile == null){
        Fluttertoast.showToast(
          msg: 'Pick an Image',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }
      if (isValid) {
        _formKey.currentState.save();
      }
      if (workerCategory == 'plumber') {
        PlumberRating plumberRating = PlumberRating(
            payment: double.parse(_payment), we: int.parse(_years));
        rating = plumberRating.calculateRating();
        print(rating);
        final ref = FirebaseStorage.instance
            .ref()
            .child('plumber_image')
            .child(userID + '.jpg');

        await ref.putFile(_userImageFile);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('plumber')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'phoneNumber': _phoneNumber,
          'years': _years,
          'rating': rating,
          'verification':verficationStatus,
          'uid': userID,
          'image_url': url,
        });
        await FirebaseFirestore.instance
            .collection('worker')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'years': _years,
          'phoneNumber': _phoneNumber,
          'verification':verficationStatus,
          'category': workerCategory,
          'uid': userID,
          'image_url': url,
        }, SetOptions(merge: true));
        Navigator.pushNamed(context, HomeScreen.id);
      }
      if (workerCategory == 'painter') {
        PainterRating painterRating = PainterRating(
            payment: double.parse(_payment), we: int.parse(_years));
        rating = painterRating.calculateRating();
        final ref = FirebaseStorage.instance
            .ref()
            .child('painter_image')
            .child(userID + '.jpg');

        await ref.putFile(_userImageFile);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('painter')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'phoneNumber': _phoneNumber,
          'years': _years,
          'verification':verficationStatus,
          'rating': rating,
          'uid': userID,
          'image_url': url,
        });
        await FirebaseFirestore.instance
            .collection('worker')
            .doc(loggedInUser.uid)
            .set({
          'username': _username,
          'payment': _payment,
          'years': _years,
          'phoneNumber': _phoneNumber,
          'rating': rating,
          'verification':verficationStatus,
          'category': workerCategory,
          'uid': userID,
          'image_url': url,
        }, SetOptions(merge: true));
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  UserImagePicker(_pickedImage),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('worker')
                          .doc(userID)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text('Loading...'),
                          );
                        } else {
                          return TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            readOnly: true,
                            initialValue: snapshot.data['username'],
                            onSaved: (String value) {
                              _username = value;
                            },
                          );
                        }
                      }),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Payment per hour'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
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
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    focusNode: _phoneNumberFocusNode,
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
                      FocusScope.of(context).requestFocus(_experienceFocusNode);
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Years of Experience'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
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
                  DropDownField(
                    controller: categoryselected,
                    hintText: 'Select your working Category',
                    enabled: true,
                    required: true,
                    //strict: true,
                    itemsVisibleInDropdown: 5,
                    items: category,
                    onValueChanged: (value) {
                      setState(() {
                        workerCategory = value;
                      });
                    },
                  ),
                  // if (widget.isLoading)
                  //   LinearProgressIndicator(
                  //     backgroundColor: Colors.yellow.shade800,
                  //   ),
                  // if (!widget.isLoading)
                  RaisedButton(
                    child: Text('Submit'),
                    color: Colors.yellow.shade800,
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
