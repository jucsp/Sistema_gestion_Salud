class User {
  User({
    this.id,
    this.tipoUser,
    this.rut,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String tipoUser;
  String rut;
  String email;
  DateTime emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    tipoUser: json["tipo_user"],
    rut: json["rut"],
    email: json["email"],
    emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tipo_user": tipoUser,
    "rut": rut,
    "email": email,
    "email_verified_at": emailVerifiedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
