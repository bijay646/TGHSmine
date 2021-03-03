import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/list_plumber.dart';

var plumberid;

class FinalPlumberRatingScreen extends StatefulWidget {
  static const String id = 'final_plumber_ratings';

  @override
  _FinalPlumberRatingScreenState createState() => _FinalPlumberRatingScreenState();
}

class _FinalPlumberRatingScreenState extends State<FinalPlumberRatingScreen> {
  double finalrating, bayrating, prating;
  Future getPainter() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('plumber').get();
    for (int i = 0; i <= qn.docs.length - 1; i++) {
      setState(() {
        if (qn.docs[i].get('uid') == plumberid) {
          bayrating = qn.docs[i].get('bayrating');
          prating = qn.docs[i].get('rating');
          finalrating = ((bayrating * 0.7) + (prating * 0.3));
        }
      });
    }
    print('bayrating');
    print(bayrating);
    print('prating');
    print(prating);
    print('finalrating');
    print(finalrating);
    return qn.docs;
  }

  @override
  void initState() {
    super.initState();
    getPainter();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    plumberid = args;
    return Scaffold(
      body: AlertDialog(
        title: Text("Do you want another plumber"),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'yes',
                style: TextStyle(
                  color: Colors.yellow.shade800,
                ),
              ),
            ),
            onTap: () async{
       await FirebaseFirestore.instance
              .collection('plumber')
              .doc(plumberid)
              .update(
          {'rating': double.parse((finalrating).toStringAsFixed(1))});
              Navigator.pushNamedAndRemoveUntil(context, ListPlumberScreen.id, (r) => false);
              },
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.yellow.shade800,
                ),
              ),
            ),
            onTap: () async{
              await FirebaseFirestore.instance
                           .collection('plumber')
                           .doc(plumberid)
                           .update(
                           {'rating':finalrating});
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (r) => false);
              },
          )
        ],
      ),
    );
    // Center(
    //   child: GestureDetector(
    //       child: Container(
    //         alignment: Alignment.centerRight,
    //         child: Text(
    //           'Final Page',
    //           style: TextStyle(
    //             color: Colors.yellow.shade800,
    //           ),
    //         ),
    //       ),
    //       onTap: () async {
    //         await FirebaseFirestore.instance
    //             .collection('plumber')
    //             .doc(plumberid)
    //             .update(
    //             {'rating': double.parse((finalrating).toStringAsFixed(1))});
    //         Navigator.pushNamed(context, HomeScreen.id);
    //       }),
    // );
  }
}
