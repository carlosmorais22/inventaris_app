import 'package:inventaris/entities/inventario.dart';

class Globals {
  static final Globals _instance = Globals._internal();

  // passes the instantiation to the _instance object
  factory Globals() => _instance;

  //initialize variables in here
  Globals._internal() {}

  late Inventario inventario;
}
