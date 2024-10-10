class Dispositivo {
  late String id;
  late String? nome;
  late String? cpf;
  late String modelo;
  late String fabricante;
  late bool status;
  late bool? is_adm;

  Dispositivo(
      {required this.id,
      this.nome,
      this.cpf,
      required this.modelo,
      required this.fabricante,
      required this.status,
      this.is_adm});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['modelo'] = this.modelo;
    data['fabricante'] = this.fabricante;
    data['status'] = this.status;
    data['is_adm'] = this.is_adm;
    return data;
  }

  factory Dispositivo.fromMap(Map<String, dynamic> map) => Dispositivo(
        id: map["id"],
        nome: map["nome"],
        cpf: map["cpf"],
        modelo: map["modelo"],
        fabricante: map["fabricante"],
        status: map["status"],
        is_adm: map["is_adm"],
      );
}
