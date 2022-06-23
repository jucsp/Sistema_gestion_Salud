// To parse this JSON data, do
//
//     final cita = citaFromJson(jsonString);

import 'dart:convert';

List<Cita> citaFromJson(String str) =>
    List<Cita>.from(json.decode(str).map((x) => Cita.fromJson(x)));

String citaToJson(List<Cita> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cita {
  Cita({
    this.idCitaMedica,
    this.nroEspera,
    this.fechaInicio,
    this.fechaFinal,
    this.observacion,
    this.estado,
    this.especialidadCesfamId,
    this.salaId,
    this.pacienteId,
    this.createdAt,
    this.updatedAt,
    this.idEspecialidadCesfam,
    this.cupo,
    this.especialidadId,
    this.cesfamId,
    this.idEspecialidad,
    this.nombreEspecialidad,
    this.sala,
  });

  int idCitaMedica;
  int nroEspera;
  DateTime fechaInicio;
  DateTime fechaFinal;
  String observacion;
  String estado;
  int especialidadCesfamId;
  int salaId;
  int pacienteId;
  DateTime createdAt;
  dynamic updatedAt;
  int idEspecialidadCesfam;
  int cupo;
  int especialidadId;
  int cesfamId;
  int idEspecialidad;
  String nombreEspecialidad;
  Sala sala;

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
        idCitaMedica: json["id_cita_medica"],
        nroEspera: json["nro_espera"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFinal: DateTime.parse(json["fecha_final"]),
        observacion: json["observacion"] == null ? null : json["observacion"],
        estado: json["estado"],
        especialidadCesfamId: json["especialidad_cesfam_id"],
        salaId: json["sala_id"],
        pacienteId: json["paciente_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        idEspecialidadCesfam: json["id_especialidad_cesfam"],
        cupo: json["cupo"],
        especialidadId: json["especialidad_id"],
        cesfamId: json["cesfam_id"],
        idEspecialidad: json["id_especialidad"],
        nombreEspecialidad: json["nombre_especialidad"],
        sala: Sala.fromJson(json["sala"]),
      );

  Map<String, dynamic> toJson() => {
        "id_cita_medica": idCitaMedica,
        "nro_espera": nroEspera,
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_final": fechaFinal.toIso8601String(),
        "observacion": observacion == null ? null : observacion,
        "estado": estado,
        "especialidad_cesfam_id": especialidadCesfamId,
        "sala_id": salaId,
        "paciente_id": pacienteId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "id_especialidad_cesfam": idEspecialidadCesfam,
        "cupo": cupo,
        "especialidad_id": especialidadId,
        "cesfam_id": cesfamId,
        "id_especialidad": idEspecialidad,
        "nombre_especialidad": nombreEspecialidad,
        "sala": sala.toJson(),
      };
}

class Sala {
  Sala({
    this.idSala,
    this.nombreSala,
    this.nombrePabellon,
    this.especialidadCesfamId,
    this.createdAt,
    this.updatedAt,
  });

  int idSala;
  String nombreSala;
  String nombrePabellon;
  int especialidadCesfamId;
  DateTime createdAt;
  dynamic updatedAt;

  factory Sala.fromJson(Map<String, dynamic> json) => Sala(
        idSala: json["id_sala"],
        nombreSala: json["nombre_sala"],
        nombrePabellon: json["nombre_pabellon"],
        especialidadCesfamId: json["especialidad_cesfam_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_sala": idSala,
        "nombre_sala": nombreSala,
        "nombre_pabellon": nombrePabellon,
        "especialidad_cesfam_id": especialidadCesfamId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
