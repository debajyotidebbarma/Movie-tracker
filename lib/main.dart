import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/get_started_page.dart';
import 'package:movie_tracker/screens/login_page.dart';
import 'package:movie_tracker/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    Widget widget;
    if (firebaseUser != null) {
      widget = MainScreenPage();
    } else {
      widget = LoginPage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/',
      // routes: {
      //   '/':(context)=>GetStarted(),
      //   '/main':(context)=>MainScreenPage(),
      //   '/login':(context)=>LoginPage(),
      // },
      home:widget,
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return RouteController(settingName: settings.name);
      //     },
      //   );
      // },
    );
  }
}

// class RouteController extends StatelessWidget {
//   final String? settingName;
//   const RouteController({Key? key, required this.settingName})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final userSignedIn = Provider.of<User>(context);

//     if (settingName == '/') {
//       return GetStarted();
//     } else if (settingName == '/login') {
//       return LoginPage();
//     } else if (settingName == '/main') {
//       return MainScreenPage();
//     } else {
//       // return PageNotFound();
//     }
//     return LoginPage();
//   }
// }
