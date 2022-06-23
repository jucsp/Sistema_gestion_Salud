import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_cesf/vistas/login.dart';
import 'package:app_cesf/vistas/home.dart';
import 'package:app_cesf/vistas/agendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cesfam app',
      theme: ThemeData(
          fontFamily: 'RobotoMono',
        primaryColor:  Colors.deepPurpleAccent,
        //rimaryColorLight: Colors.deepPurpleAccent,
        //accentColor: Color.fromRGBO(196, 135, 198, 1),
        colorScheme: ColorScheme.light(primary: Colors.deepPurpleAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      debugPrint("Hay un token guardaddo");
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      debugPrint("Llama al home");
      child = Home();
    } else {
      debugPrint("Llama al login");
      child = Login();
    }
    return Scaffold(
      body: child,
    );
  }
}
