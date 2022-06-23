import 'package:app_cesf/cesfam.dart';
import 'package:app_cesf/vistas/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_cesf/controller/api.dart';
import 'package:app_cesf/Animacion/Fade.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as fecha;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class Formulario extends StatefulWidget {
  final String rut;
  final String correo;
  final String tipoUser;
  final String pass;

  Formulario(this.correo, this.rut, this.tipoUser, this.pass);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  fecha.DateFormat formatterF = fecha.DateFormat('dd-MM-yyyy');
  List<Cesfam> _cesfams;
  List<String> sexoData;
  List<String> grupoSData;
  List<String> sistemaSData;
  var _sexoItemSelected = 'Femenino';
  var _sistemaSItemSelected = 'Isapre';
  var _grupoSItemSelected = 'A+';
  int _cesfamItemSelected = 0;
  DateTime _dateTime;
  bool _isLoading = false;

  var nombres;
  var apellidos;
  DateTime fecha_nacimiento;
  var lugar_nacimiento;
  var direccion;
  var nacionalidad;
  var telefono_celular;
  var telefono_casa;
  Cesfam cesfamSelected;
  String sexo = '';

  var textoNombres = TextEditingController();
  var textoApellidos = TextEditingController();
  var textoFecha = TextEditingController();
  var textoLugarNacimiento = TextEditingController();
  var textoDireccion = TextEditingController();
  var textoNacionalidad = TextEditingController();
  var textoTelefonoCasa = TextEditingController();
  var textoTelefonoCelular = TextEditingController();

  int _currentStep = 0;
  StepperType _stepperType = StepperType.horizontal;
  StepState _estadoPersonal = StepState.indexed;
  StepState _estadoMedico = StepState.indexed;



  @override
  void initState() {
    super.initState();
    _getColumnas();
    getCesfam().then((cesfams) {
      setState(() {
        _cesfams = cesfams;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Registrarse"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              //key: Key(Random.secure().nextDouble().toString()),
              steps: _stepper(),
              physics: ClampingScrollPhysics(),
              currentStep: this._currentStep,
              type: _stepperType,
              onStepTapped: (stop) {
                setState(() {
                  this._currentStep = stop;
                });
              },
              onStepContinue: () {
                setState(() {
                  if (this._currentStep < this._stepper().length - 1) {
                    if (_formKeys[_currentStep].currentState.validate()) {
                      this._currentStep = this._currentStep + 1;
                    }
                  } else {
                    if (_formKeys[_currentStep].currentState.validate()) {
                      _register();
                    }
                    print("Complete");
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (this._currentStep > 0) {
                    this._currentStep = this._currentStep - 1;
                  } else {
                    this._currentStep = 0;
                  }
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchStepType,
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.swap_horizontal_circle, color: Colors.white),
      ),
    );
  }

  switchStepType() {
    setState(() => _stepperType == StepperType.horizontal
        ? _stepperType = StepperType.vertical
        : _stepperType = StepperType.horizontal);
  }

  List<Step> _stepper() {
    List<Step> _steps = [
      Step(
          title: Text("Datos de usuario"),
          content: Form(
              key: _formKeys[0],
              child: Column(
                children: [
                  TextFormField(
                    controller: textoNombres,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: "Nombres",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (nombresValue) {
                      if (nombresValue.isEmpty) {
                        return 'Ingresar Nombres ';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        nombres = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textoApellidos,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: "Apellidos",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (apellidosValue) {
                      if (apellidosValue.isEmpty) {
                        return 'Ingresar Apellidos ';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        apellidos = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textoTelefonoCelular,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.phone_android),
                        hintText: "Telefono celular",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingresar telefono celular';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        telefono_celular = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textoTelefonoCasa,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.phone),
                        hintText: "Telefono casa",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingresar contraseña';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        telefono_casa = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  sexoData != null
                      ? FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                icon: const FaIcon(FontAwesomeIcons.venusMars),
                                labelText: 'Sexo',
                              ),
                              isEmpty: _sexoItemSelected == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: _sexoItemSelected,
                                  isDense: true,
                                  onChanged: (String newValueSelected) {
                                    setState(() {
                                      this._sexoItemSelected = newValueSelected;
                                      state.didChange(newValueSelected);
                                    });
                                  },
                                  items: sexoData.map((String value) {
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: textoFecha,
                          decoration: InputDecoration(
                              enabled: false,
                              disabledBorder: InputBorder.none,
                              icon: const Icon(Icons.calendar_today),
                              hintText: "Ingresar fecha de nacimiento",
                              hintStyle: TextStyle(color: Colors.grey)),
                          validator: (tcValue) {
                            if (tcValue.isEmpty) {
                              textoFecha.text = "Ingresar fecha de nacimiento";
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: IconButton(
                          color: Colors.deepPurpleAccent,
                          tooltip: 'Fecha de nacimiento',
                          icon: Icon(Icons.date_range),
                          onPressed: () => {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now()
                                        .subtract(Duration(days: 0)))
                                .then((date) {
                              setState(() {
                                if (date == null) {
                                  print("Sin fecha seleccionada");
                                } else {
                                  _dateTime = date;
                                  fecha_nacimiento = _dateTime;
                                  textoFecha.text =
                                      formatterF.format(_dateTime);
                                }
                              });
                            })
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textoNacionalidad,
                    decoration: InputDecoration(
                        icon: const FaIcon(FontAwesomeIcons.flag),
                        hintText: "Nacionalidad",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (nacionalidadVale) {
                      if (nacionalidadVale.isEmpty) {
                        return 'Ingresar su nacionalidad ';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        nacionalidad = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textoLugarNacimiento,
                    decoration: InputDecoration(
                        icon: const FaIcon(FontAwesomeIcons.globeAmericas),
                        hintText: "Lugar de nacimiento",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (nacimientoVale) {
                      if (nacimientoVale.isEmpty) {
                        return 'Ingresar lugar de nacimiento ';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        lugar_nacimiento = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textoDireccion,
                    decoration: InputDecoration(
                        icon: const FaIcon(FontAwesomeIcons.mapMarkerAlt),
                        hintText: "Direccion",
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (direccionValue) {
                      if (direccionValue.isEmpty) {
                        return 'Ingresar direccion ';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        direccion = val;
                      });
                    },
                  ),
                ],
              )),
          isActive: _currentStep >= 0,
          state: StepState.indexed),
      Step(
          title: Text("Antecedentes medicos"),
          content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  sistemaSData != null
                      ? FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                icon: const FaIcon(
                                    FontAwesomeIcons.solidPlusSquare),
                                labelText: 'Sistema de salud',
                              ),
                              isEmpty: _sistemaSItemSelected == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: _sistemaSItemSelected,
                                  isDense: true,
                                  onChanged: (String newValueSelected) {
                                    setState(() {
                                      this._sistemaSItemSelected =
                                          newValueSelected;
                                      state.didChange(newValueSelected);
                                    });
                                  },
                                  items: sistemaSData.map((String value) {
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  grupoSData != null
                      ? FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                icon: const FaIcon(FontAwesomeIcons.tint),
                                labelText: 'Grupo Sanguineo',
                              ),
                              isEmpty: _grupoSItemSelected == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: _grupoSItemSelected,
                                  isDense: true,
                                  onChanged: (String newValueSelected) {
                                    setState(() {
                                      this._grupoSItemSelected =
                                          newValueSelected;
                                      state.didChange(newValueSelected);
                                    });
                                  },
                                  items: grupoSData.map((String value) {
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  _cesfams != null
                      ? FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                icon: const FaIcon(
                                    FontAwesomeIcons.solidHospital),
                                labelText: 'Cesfam',
                              ),
                              isEmpty: cesfamSelected == "",
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: cesfamSelected,
                                  isDense: true,
                                  onChanged: (Cesfam newValueSelected) {
                                    setState(() {
                                      this.cesfamSelected = newValueSelected;
                                      state.didChange(newValueSelected);
                                    });
                                  },
                                  items: _cesfams.map((Cesfam value) {
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(value.nombreCesfam),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ],
              )),
          isActive: _currentStep >= 1,
          state: StepState.indexed),
    ];
    return _steps;
  }

  Future<List<Cesfam>> getCesfam() async {
    try {
      var response = await Network().getData('listarCesfam/');
      print(response.toString());
      if (200 == response.statusCode) {
        List<Cesfam> cesfams = cesfamFromJson(response.body);
        return cesfams;
      } else {
        return List<Cesfam>();
      }
    } catch (e) {
      return List<Cesfam>();
    }
  }

  void _getColumnas() async {
    var response = await Network().getData('listarColumnas');
    var jsonPaciente = null;

    if (response.statusCode == 200) {
      jsonPaciente = json.decode(response.body);
      setState(() {
        sexoData = List<String>.from(jsonPaciente[0]);
        grupoSData = List<String>.from(jsonPaciente[1]);
        sistemaSData = List<String>.from(jsonPaciente[2]);
      });
    } else {
      setState(() {
        sexoData = null;
        grupoSData = null;
        sistemaSData = null;
      });
    }
  }

  calculateAge(DateTime birthDate) {
    print(birthDate.toIso8601String());

    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  void _register() async {
    debugPrint("Se va agregar " + widget.correo);
    debugPrint("rut " + widget.rut);
    debugPrint("pass  " + widget.pass);
    var body = {
      "usuario": {
        "tipo_user": widget.tipoUser,
        "rut": widget.rut,
        'email': widget.correo,
        'password': widget.pass,
      },
      "paciente": {
        'nombres': this.nombres,
        'apellidos': this.apellidos,
        'fecha_nacimiento': this.fecha_nacimiento.toIso8601String(),
        'edad': calculateAge(this.fecha_nacimiento),
        'sexo': this._sexoItemSelected,
        'direccion': this.direccion,
        'nacionalidad': this.nacionalidad,
        'lugar_nacimiento': this.lugar_nacimiento,
        'telefono_celular': this.telefono_celular,
        'telefono_casa': this.telefono_casa,
        'sistema_salud': this._sistemaSItemSelected,
        'grupo_sanguineo': this._grupoSItemSelected,
        'cesfam_id': this.cesfamSelected.idCesfam
      }
    };
    var response = await Network().authData(body, 'createPaciente');
    if (response.statusCode == 200) {
      Navigator.push(context,new MaterialPageRoute(builder: (context) => Login()),);
    } else {
      _showMsg("Error! Usuario no creado");
    }
  }

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

}
