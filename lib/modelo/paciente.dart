import 'dart:convert';
import 'package:app_cesf/modelo/user.dart';

Paciente pacienteFromJson(String str) => Paciente.fromJson(json.decode(str));

String pacienteToJson(Paciente data) => json.encode(data.toJson());

class Paciente {
  Paciente({
    this.idPaciente,
    this.nombres,
    this.apellidos,
    this.fechaNacimiento,
    this.edad,
    this.sexo,
    this.nacionalidad,
    this.lugarNacimiento,
    this.direccion,
    this.telefonoCelular,
    this.telefonoCasa,
    this.sistemaSalud,
    this.grupoSanguineo,
    this.cesfamId,
    this.userId,
   this.createdAt,
    this.updatedAt,
    this.user,
  });

  int idPaciente;
  String nombres;
  String apellidos;
  DateTime fechaNacimiento;
  int edad;
  String sexo;
  String nacionalidad;
  String lugarNacimiento;
  String telefonoCelular;
  String telefonoCasa;
  String sistemaSalud;
  String grupoSanguineo;
  String direccion;
  int cesfamId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
    idPaciente: json["id_paciente"],
    nombres: json["nombres"],
    apellidos: json["apellidos"],
    fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
    edad: json["edad"],
    sexo: json["sexo"],
    nacionalidad: json["nacionalidad"],
    lugarNacimiento: json["lugar_nacimiento"],
    direccion: json["direccion"],
    telefonoCelular: json["telefono_celular"],
    telefonoCasa: json["telefono_casa"],
    sistemaSalud: json["sistema_salud"],
    grupoSanguineo: json["grupo_sanguineo"],
    cesfamId: json["cesfam_id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id_paciente": idPaciente,
    "nombres": nombres,
    "apellidos": apellidos,
    "fecha_nacimiento": "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
    "edad": edad,
    "sexo": sexo,
    "nacionalidad": nacionalidad,
    "lugar_nacimiento": lugarNacimiento,
    "direccion": direccion,
    "telefono_celular": telefonoCelular,
    "telefono_casa": telefonoCasa,
    "sistema_salud": sistemaSalud,
    "grupo_sanguineo": grupoSanguineo,
    "cesfam_id": cesfamId,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}