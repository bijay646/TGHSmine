import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/screens/final_plumber_ratings.dart';

var wid;

class PlumberBayesianScreen extends StatefulWidget {
  static const String id = 'plumber_bayesian_screen';

  @override
  _PlumberBayesianScreenState createState() => _PlumberBayesianScreenState();
}

class _PlumberBayesianScreenState extends State<PlumberBayesianScreen> {
  int icount5, count, icount4, icount3, icount2, icount1, total, itotal;
  int tcount5, tcount4, tcount3, tcount2, tcount1;
  double bayrating, irating, orating;
  int jobcount = 100;
  Future getPlumber() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('ratings').get();
    // print("QN");
    //print(qn.docs.length);
    total = qn.docs.length;
    //count = 1;
    icount5 = 0;
    icount4 = 0;
    icount3 = 0;
    icount2 = 0;
    icount1 = 0;
    tcount5 = 0;
    tcount4 = 0;
    tcount3 = 0;
    tcount2 = 0;
    tcount1 = 0;
    for (int i = 0; i <= qn.docs.length - 1; i++) {
      //print(qn.docs[i].id);

      //for overall
      setState(() {
        //count++;
        if (qn.docs[i].get('userrating') == 5) {
          tcount5++;
        } else if (qn.docs[i].get('userrating') == 4) {
          tcount4++;
        } else if (qn.docs[i].get('userrating') == 3) {
          tcount3++;
        } else if (qn.docs[i].get('userrating') == 2) {
          tcount2++;
        } else {
          tcount1++;
        }
        //for individual
        if (qn.docs[i].get('wid') == wid) {
          //count++;
          if (qn.docs[i].get('userrating') == 5) {
            icount5++;
          } else if (qn.docs[i].get('userrating') == 4) {
            icount4++;
          } else if (qn.docs[i].get('userrating') == 3) {
            icount3++;
          } else if (qn.docs[i].get('userrating') == 2) {
            icount2++;
          } else {
            icount1++;
          }
        }
      });
    }
    itotal = icount5 + icount4 + icount3 + icount2 + icount1;
    irating =
        ((5 * icount5 + 4 * icount4 + 3 * icount3 + 2 * icount2 + 1 * icount1) /
            itotal);
    orating =
        ((5 * tcount5 + 4 * tcount4 + 3 * tcount3 + 2 * tcount2 + 1 * tcount1) /
            total);
    bayrating = ((itotal * irating) + (total * orating)) / (total + itotal);
    //print(count);
    // print("icount5");
    // print(icount5);
    // print("icount4");
    // print(icount4);
    // print("icount3");
    // print(icount3);
    // print("icount2");
    // print(icount2);
    // print("icount1");
    // print(icount1);
    // print("itotal");
    // print(itotal);
    // print("tcount5");
    // print(tcount5);
    // print("tcount4");
    // print(tcount4);
    // print("tcount3");
    // print(tcount3);
    // print("tcount2");
    // print(tcount2);
    // print("tcount1");
    // print(tcount1);
    // print("total");
    // print(total);
    print("irating");
    print(irating);
    print("orating");
    print(orating);
    print("bayrating");
    print(bayrating);
    return qn.docs;
  }

  // Future<void> getName() async {
  // DocumentSnapshot ds =
  //       await FirebaseFirestore.instance.collection('plumber').doc(wid).get();
  //   prating = ds.data()['rating'];
  // }

  @override
  void initState() {
    super.initState();
    getPlumber();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    wid = args;
    //  print("Args");
    //print(args);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: <Widget>[
            SizedBox(
              width: 15,
            ),
            Text(
              'Thank You for Rating',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          RaisedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('plumber')
                  .doc(wid)
                  .set({'bayrating': bayrating, 'jobcount': jobcount},
                      SetOptions(merge: true));
              Navigator.pushNamedAndRemoveUntil(context, FinalPlumberRatingScreen.id, (r) => false,
                  arguments: wid);
            },
            child: Text('Ok'),
          )
        ],
      ),
    );
    // Center(
    //   child: GestureDetector(
    //       child: Container(
    //         alignment: Alignment.centerRight,
    //         child: Text(
    //           'Thank You for the rating',
    //           style: TextStyle(
    //             color: Colors.yellow.shade800,
    //           ),
    //         ),
    //       ),
    //       onTap: () async {
    //         await FirebaseFirestore.instance
    //             .collection('plumber')
    //             .doc(wid)
    //            .set({'bayrating': bayrating,'jobcount':jobcount}, SetOptions(merge: true));
    //         Navigator.pushNamed(context, FinalPlumberRatingScreen.id,
    //             arguments: wid);
    //       }),
    // );
  }
}
