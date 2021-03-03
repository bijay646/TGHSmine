import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/components/databaseservice.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

import 'painter_bayesian_rating.dart';

class ListPainterScreen extends StatefulWidget {
  static const String id = 'list_painter_screen';
  @override
  _ListPainterScreenState createState() => _ListPainterScreenState();
}

class _ListPainterScreenState extends State<ListPainterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Painter'),
      ),
      body: ListPainter(),
    );
  }
}

class ListPainter extends StatefulWidget {
  @override
  _ListPainterState createState() => _ListPainterState();
}

class _ListPainterState extends State<ListPainter> {
  Future _data;
  Future getPainter() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('painter')
        .orderBy('rating', descending: true)
        .get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PainterDetailPage(post: post)));
  }

  @override
  void initState() {
    super.initState();
    _data = getPainter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
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
                    if (snapshot.data[index].data()['verification'] ==
                        'verified')
                      return Column(children: <Widget>[
                        ListTile(
                          title: Text(
                            snapshot.data[index].data()['username'],
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          trailing: Text(
                            'Rating' +
                                '\n' +
                                '     ' +
                                snapshot.data[index]
                                    .data()['rating']
                                    .toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          leading:CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data[index]
                        .data()['image_url']),

                    ),
                          contentPadding: EdgeInsets.all(20.0),
                          onTap: () => navigateToDetail(snapshot.data[index]),
                        ),
                        Divider(),
                      ]);
                    else {
                      return SizedBox(height: 1.0);
                    }
                  });
            }
          }),
    );
  }
}

class PainterDetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  PainterDetailPage({this.post});

  @override
  _PainterDetailPageState createState() => _PainterDetailPageState();
}

class _PainterDetailPageState extends State<PainterDetailPage> {
  String userID;
  User loggedInUser;
  double ratingvalue;
  final _auth = FirebaseAuth.instance;

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

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('could not launch $command');
    }
  }

  createRatingDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Rate the Worker"),
            content: SmoothStarRating(
                size: 45.0,
                color: Colors.amber,
                allowHalfRating: false,
                onRated: (rating) {
                  ratingvalue = rating;
                }),
            actions: <Widget>[
              GestureDetector(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.yellow.shade800,
                    ),
                  ),
                ),
                onTap: () async {
                  await DatabaseService(uid: widget.post.data()['uid'])
                      .updateUserData(
                          widget.post.data()['uid'], userID, ratingvalue);
                  Navigator.pushNamedAndRemoveUntil(context, PainterBayesianScreen.id, (r) => false,
                      arguments: widget.post.id);
                  // arguments: widget.post.data()['uid']);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data()['username']),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 14.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      NetworkImage(widget.post.data()['image_url']),
                ),
              ),
            ),

            ListTile(
              title: Text(
                '\n\n\n'
                        'Username   :    ' +
                    widget.post.data()['username'] +
                    '\n\n\n' 'Contact     :    ' +
                    widget.post.data()['phoneNumber'] +
                    '\n\n\n' 'payment      :    ' +
                    'Rs.' +
                    widget.post.data()['payment'] +
                    '/hr' +
                    '\n\n\n' 'experience  :    ' +
                    widget.post.data()['years'] +
                    'years',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      customLaunch("tel: ${widget.post.data()['phoneNumber']}");
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: 20,
                      child: Text(
                        "Call Worker",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  RaisedButton(
                    onPressed: () {
                      createRatingDialog(context);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: 20,
                      child: Text("Rate Worker",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
