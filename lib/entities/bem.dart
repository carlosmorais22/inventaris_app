class Bem {
  final int id;
  final String setor;
  final String tombo;
  String descricao;
  final int conta;
  final int? estado;
  final String valor;
  final String? valor_remanescente;
  final String numero_serie;
  final String? data;
  final String data_aquisicao;
  final int ativo;

  Bem(
      {required this.id,
      required this.setor,
      required this.tombo,
      required this.descricao,
      required this.conta,
      required this.estado,
      required this.valor,
      required this.valor_remanescente,
      required this.numero_serie,
      required this.data,
      required this.data_aquisicao,
      required this.ativo});

  factory Bem.fromMap(Map<String, dynamic> map) => Bem(
        id: map["id"],
        setor: map["setor"],
        tombo: map["tombo"],
        descricao: map["descricao"],
        conta: map["conta"],
        estado: map["estado"],
        valor: map["valor"],
        valor_remanescente: map["valor_remanescente"],
        numero_serie: map["numero_serie"],
        data: map["data"],
        data_aquisicao: map["data_aquisicao"],
        ativo: map["ativo"],
      );
}
