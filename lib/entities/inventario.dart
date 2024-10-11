class Inventario {
  late int? id;
  late int ano;
  late int bem;
  late int? estado;
  late int situacao;
  late bool? plaqueta;
  late String? observacao;
  late String? cadastrado_por;
  late String? situacao_observacao;
  late bool? tem_numero_serie;
  late String? numero_serie;
  late DateTime? created_at;
  late DateTime? updated_at;
  late DateTime? deleted_at;

  Inventario(
      {this.id,
      required this.ano,
      required this.bem,
      this.estado,
      required this.situacao,
      this.plaqueta,
      this.observacao,
      this.cadastrado_por,
      this.situacao_observacao,
      this.tem_numero_serie,
      this.numero_serie,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['ano'] = this.ano;
    data['bem'] = this.bem;
    data['estado'] = this.estado;
    data['situacao'] = this.situacao;
    data['plaqueta'] = this.plaqueta;
    data['observacao'] = this.observacao;
    data['cadastrado_por'] = this.cadastrado_por;
    data['situacao_observacao'] = this.situacao_observacao;
    data['tem_numero_serie'] = this.tem_numero_serie;
    data['numero_serie'] = this.numero_serie;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    data['deleted_at'] = this.deleted_at;
    return data;
  }

  factory Inventario.fromMap(Map<String, dynamic> map) => Inventario(
        id: map["id"],
        ano: map["ano"],
        bem: map["bem"],
        estado: map["estado"],
        situacao: map["situacao"],
        plaqueta: map["plaqueta"],
        observacao: map["observacao"],
        cadastrado_por: map["cadastrado_por"],
        situacao_observacao: map["situacao_observacao"],
        tem_numero_serie: map["tem_numero_serie"],
        numero_serie: map["numero_serie"],
        created_at: map["created_at"],
        updated_at: map["updated_at"],
        deleted_at: map["deleted_at"],
      );
}
