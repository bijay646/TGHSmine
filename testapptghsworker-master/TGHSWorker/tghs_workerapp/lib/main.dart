import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/forget_password.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/myDetails.dart';
import 'package:flutter_app/screens/update_user_details.dart';
import 'screens/user_form_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: FirebaseOptions(
      appId: '1:506256229626:android:f9e02cc06570a08fbdf543',
      apiKey: 'AIzaSyBXJZFx2ADbvQ5sKL8DXkI9kxwxwo9jR1Q',
      messagingSenderId: '297855924061',
      projectId: 'flutter-firebase-plugins',
      databaseURL: 'https://tghstestfinal-default-rtdb.firebaseio.com',
    ),
  );
  runApp(Tghsworker());
}


class Tghsworker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AuthScreen.id,
      routes: {
          AuthScreen.id: (context) => AuthScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          UserFormScreen.id: (context) => UserFormScreen(),
        UpdateFormScreen.id: (context) => UpdateFormScreen(),
        ForgetPasswordScreen.id: (context) => ForgetPasswordScreen(),
        MyDetails.id: (context) => MyDetails(),
      },
    );
  }
}
