import 'dart:convert';
import 'package:app_cesf/controller/api.dart';
import 'package:app_cesf/vistas/covid.dart';
import 'package:app_cesf/vistas/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'perfil.dart';

class NavDrawer extends StatefulWidget {
  final String correo;
  NavDrawer(this.correo);
  @override
  State<StatefulWidget> createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>  {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Color(0xffAE3DDC),
    return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(widget.correo,style: TextStyle(fontSize: 16)),
              accountName:  Text("Javiera Jara Salas",style: TextStyle(fontSize: 16)),
              currentAccountPicture:  CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://i.ibb.co/3Y7Hm0B/abuela.png"),
              ),
              decoration: new BoxDecoration(
                  color: Colors.pink,
                  image: new DecorationImage(
                      image: NetworkImage("https://i.ibb.co/6gkFGJQ/coronavirus-covid-2019-sobre-fondo-morado-181623-43.jpg"),
                      fit: BoxFit.fill)),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.calendarPlus,color: Color(0xff837E7E)),
                    title: Text('Citas Médicas',style: TextStyle(fontSize: 16,color: Color(0xff837E7E)),),
                    onTap: () => {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Home()))
                    },
                  ),
                  new Divider(),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.notesMedical,color: Color(0xff837E7E),),
                    title: Text('Perfil médico',style: TextStyle(color: Color(0xff837E7E),fontSize: 16),),
                    onTap: () => {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Perfil()))
                    },
                  ),
                  new Divider(),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.virus,color: Color(0xff837E7E),),
                    title: Text('Covid-19',style: TextStyle(color: Color(0xff837E7E),fontSize: 16),),
                    onTap: () => {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Covid()))
                    },
                  ),
                  new Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app,color:  Color(0xff837E7E),),
                    title: Text('Salir',style: TextStyle(color: Color(0xff837E7E),fontSize: 16),),
                    onTap: () => {
                      borrarDatos(context),
                      Navigator.of(context).pop(),
                    },
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }

  void borrarDatos(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    debugPrint("user y token borrados del almacenamiento");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

// Future builder
  void logout(context) async {
    var res = await Network().getData('v1/auth/logout');
    debugPrint(res.toString());
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      debugPrint("user y token borrados del almacenamiento");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      debugPrint('No se puedo deslogear');
    }
  }
}
