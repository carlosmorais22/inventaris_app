class Setor {
  final int id;
  final String nome;
  final String sigla;

  Setor({required this.id, required this.nome, required this.sigla});

  factory Setor.fromMap(Map<String, dynamic> map) => Setor(
        id: map["id"],
        nome: map["nome"],
        sigla: map["sigla"],
      );
}
