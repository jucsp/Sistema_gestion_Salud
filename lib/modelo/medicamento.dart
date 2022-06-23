import 'dart:convert';

List<Medicamento> medicamentoFromJson(String str) => List<Medicamento>.from(
    json.decode(str).map((x) => Medicamento.fromJson(x)));

String enfermedadToJson(List<Medicamento> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Medicamento {
  Medicamento({
    this.idEnfermedad,
    this.nombreEnfermedad,
    this.idMedicamento,
    this.nombreMedicamento,
    this.indicacion,
  });

  int idEnfermedad;
  String nombreEnfermedad;
  int idMedicamento;
  String nombreMedicamento;
  String indicacion;

  factory Medicamento.fromJson(Map<String, dynamic> json) => Medicamento(
        idEnfermedad: json["id_enfermedad"],
        nombreEnfermedad: json["nombre_enfermedad"],
        idMedicamento: json["id_enmedicamento"],
        nombreMedicamento: json["nombre_medicamento"],
        indicacion: json["indicacion"],
      );

  Map<String, dynamic> toJson() => {
        "id_enfermedad": idEnfermedad,
        "nombre_enfermedad": nombreEnfermedad,
        "id_enmedicamento": idMedicamento,
        "nombre_medicamento": nombreMedicamento,
        "indicacion": indicacion,
      };
}
