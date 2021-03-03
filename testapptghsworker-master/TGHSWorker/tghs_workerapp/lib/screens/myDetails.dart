import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyDetails extends StatefulWidget {
  static const String id = 'myDetails';
  @override
  _MyDetailsState createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userID;
  User loggedInUser;
  Future _data;
  Future getWorker() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('worker').get();
    return qn.docs;
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _data = getWorker();
  }
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        userID=loggedInUser.uid;
        print(userID);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          backgroundColor:Colors.blueGrey[800],
          title:Text(
              'My Details',
            style: TextStyle(
              color: Colors.yellow.shade800,
            ),
          )
      ),
      body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    if(snapshot.data[index].data()['uid']==userID)
                    {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 14.0),
                        child: Column(
                          children: <Widget>[
                            Material(
                              borderRadius: BorderRadius.all(Radius.circular(110.0)),
                              elevation: 8.0,
                              child: Container(
                                height: 250.0,
                                width: 250.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade500,
                                  backgroundImage:
                                  NetworkImage(snapshot.data[index].data()['image_url']),
                                ),
                              ),
                            ),

                            ListTile(
                              title: Text(
                                '\n\n\n'
                                    'Username   :    ' +
                                     snapshot.data[index].data()['username'] +
                                    '\n\n\n' 'Contact     :    ' +
                                     snapshot.data[index].data()['phoneNumber'] +
                                    '\n\n\n' 'payment      :    ' +
                                    'Rs.' +
                                     snapshot.data[index].data()['payment'] +
                                    '/hr' +
                                    '\n\n\n' 'experience  :    ' +
                                    snapshot.data[index].data()['years'] +
                                    'years',
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ),

                          ],
                        ),
                      );


                    }

                  });
            }
          }),
    );
  }
}
