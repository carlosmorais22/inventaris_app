class Estado {
  final int id;
  final String descricao;

  Estado({required this.id, required this.descricao});

  factory Estado.fromMap(Map<String, dynamic> map) => Estado(
        id: map["id"],
        descricao: map["descricao"],
      );
}
