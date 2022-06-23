import 'dart:convert';

List<Enfermedad> enfermedadFromJson(String str) =>
    List<Enfermedad>.from(json.decode(str).map((x) => Enfermedad.fromJson(x)));

String enfermedadToJson(List<Enfermedad> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Enfermedad {
  Enfermedad({
    this.idEnfermedad,
    this.nombreEnfermedad,
    this.fechaInicio,
  });

  int idEnfermedad;
  String nombreEnfermedad;
  DateTime fechaInicio;

  factory Enfermedad.fromJson(Map<String, dynamic> json) => Enfermedad(
    idEnfermedad: json["id_enfermedad"],
    nombreEnfermedad: json["nombre_enfermedad"],
    fechaInicio: DateTime.parse(json["fecha_inicio"]),
  );

  Map<String, dynamic> toJson() => {
    "id_enfermedad": idEnfermedad,
    "nombre_enfermedad": nombreEnfermedad,
    "fecha_inicio": fechaInicio.toIso8601String(),
  };
}