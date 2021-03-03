import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/final_painter_ratings.dart';
import 'package:flutter_app/screens/final_plumber_ratings.dart';
import 'package:flutter_app/screens/forget_password.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/list_painter.dart';
import 'package:flutter_app/screens/list_plumber.dart';
import 'package:flutter_app/screens/painter_bayesian_rating.dart';
import 'package:flutter_app/screens/plumber_bayesian_rating.dart';


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
  runApp(Tghs());
}


class Tghs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AuthScreen.id,
      routes: {
          AuthScreen.id: (context) => AuthScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        ForgetPasswordScreen.id: (context) => ForgetPasswordScreen(),
       ListPlumberScreen.id: (context) => ListPlumberScreen(),
        ListPainterScreen.id: (context) => ListPainterScreen(),
        PlumberBayesianScreen.id:(context)=>PlumberBayesianScreen(),
        PainterBayesianScreen.id:(context)=>PainterBayesianScreen(),
        FinalPainterRatingScreen.id:(context)=>FinalPainterRatingScreen(),
        FinalPlumberRatingScreen.id:(context)=>FinalPlumberRatingScreen(),
      },
    );
  }
}
