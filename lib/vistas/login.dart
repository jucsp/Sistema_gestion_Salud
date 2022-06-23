import 'dart:convert';
import 'package:app_cesf/vistas/register.dart';
import 'package:flutter/material.dart';
import 'package:app_cesf/controller/api.dart';
import 'package:app_cesf/Animacion/Fade.dart';
import 'package:app_cesf/vistas/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var rut;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background-2.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                      top: 75,
                      height: 200,
                      width: width,
                      child: FadeAnimation(
                        1.3,
                        Container(
                            decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Logo.png'),
                          ),
                        )),
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Container(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                validator: (emailValue) {
                                  if (emailValue.isEmpty) {
                                    return 'Ingresar Email ';
                                  }
                                  email = emailValue;
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "RUT",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                validator: (rutValue) {
                                  if (rutValue.isEmpty) {
                                    return 'Ingresar Rut ';
                                  }
                                  rut = rutValue;
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                validator: (passwordValue) {
                                  if (passwordValue.isEmpty) {
                                    return 'Ingresar contraseña';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ))),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.7,
                      Center(
                          child: Text(
                        "Olvidaste tu contraseña?",
                        style:
                            TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),
                      ))),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.9,
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: FlatButton(
                            child: Center(
                              child: Text(
                                _isLoading ? 'Proccessing...' : 'Ingresar',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _login();
                              }
                            }),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                    2,
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Registro()),
                        );
                      },
                      child: Center(
                          child: Text(
                        "Registrarse",
                        style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
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

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'rut': rut, 'password': password};
    debugPrint(data.toString());
    var res = await Network().authData(data, 'v1/auth/login');
    var body = json.decode(res.body);
    debugPrint(body.toString());
    //estaba 'success'
    if (res.statusCode == 200) {
      debugPrint('coneccion reaizada');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

}
