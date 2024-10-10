import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/entities/dispositivo.dart';
import 'package:inventaris/entities/inventario.dart';

class Globals {
  static final Globals _instance = Globals._internal();

  // passes the instantiation to the _instance object
  factory Globals() => _instance;

  //initialize variables in here
  Globals._internal() {}

  late Dispositivo esteDispositivo;

  late Inventario inventario;
  late String inventario_situacao;
  late String inventario_tem_numero_serie;
  late String inventario_estado;
  late Bem bem;
  late Dispositivo dispositivo;
}
