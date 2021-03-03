import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/myDetails.dart';
import 'package:flutter_app/screens/update_user_details.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;

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
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.blueGrey[800],
        title: Text(
          'T G H S',
          style: TextStyle(
            fontSize: 45.0,
            color: Colors.yellow.shade800,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.yellow.shade800,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                _auth.signOut();
                Navigator.popAndPushNamed(context, AuthScreen.id);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:50.0,horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              /*  Text(
                  'H O M E of Worker',
                  style: TextStyle(
                    fontSize: 45.0,
                    color: Colors.yellow.shade800,
                    fontWeight: FontWeight.w900,
                  ),
                ),*/
            RaisedButton(
              color:Colors.yellow.shade800,
              padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:10),
              onPressed: () {
                Navigator.pushNamed(context, MyDetails.id);
              },
              child: Text(
                'My Details',
                style: TextStyle(color: Colors.white),
              ),

            ),
                SizedBox(height: 20,),
                RaisedButton(
                  color:Colors.yellow.shade800,
                  padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:10),
                  onPressed: () {
                    Navigator.pushNamed(context, UpdateFormScreen.id);
                  },
                  child: Text(
                    'Update Form',
                    style: TextStyle(color: Colors.white),
                  ),
              ),
          ],
        ),
      ),
      //
    );
  }
}
