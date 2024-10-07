import 'dart:convert' as convert;

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/entities/setor.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';

import 'package:inventaris/utils/constants.dart';

class InventarisIncluirResumo extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirResumo({super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirResumo> createState() {
    return _InventarisIncluirResumoState();
  }
}

class _InventarisIncluirResumoState extends State<InventarisIncluirResumo> {
  String host = "app-inventario.uerr.edu.br";
  int initSituacaoValue = 0;
  String initSetorName = "";

  late Future<List> _carregarBens;

  List<double> larguraDasColunas = [0.3, 0.7];

  @override
  void initState() {
    _carregarBens = _refreshSetores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> suggestions = [];
    List<Setor> setores = [];

    _carregarBens.then((list) {
      for (Map<String, dynamic> map in list) {
        Setor setor = Setor.fromMap(map);
        Globals().inventario!.situacao_observacao ??= setor.sigla;
        setores.add(setor);
        suggestions.add(setor.sigla);
      }
    });

    Inventario inventario = Globals().inventario;
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BuildDadosBem(),
            StepTitle(title: "O inventário deste bem está correto?"),
            Container(
              color: Theme.of(context).colorScheme.onBackground,
              child: Column(
                children: [
                  _buildPadding(context, kSituacao,
                      Globals().inventario_situacao),
                  _buildPadding(context, kTemNumeroSerie,
                  inventario.tem_numero_serie != null
                      ? Globals().inventario_tem_numero_serie
                      : kNaoInformado),
                  _buildPadding(context, kNumeroSerie,
                      inventario.tem_numero_serie != null && inventario.numero_serie != null
                          ? inventario.numero_serie!
                          : "- - -"),
                  _buildPadding(context, kPlaqueta,
                       inventario.plaqueta == true ? kSim : kNao),
                  _buildPadding(context, "Estado",
                      Globals().inventario_estado),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // retorna bens para o tipo e texto do filtro
  Future<List> _refreshSetores() async {
    var endPoint = '/api/setor';
    var url = Uri.http(host, endPoint, {'q': ''});

    print("try url " + host + endPoint);
    var response = await http.get(url);
    if (response.statusCode == 201) {
      return convert.jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  Padding _buildPadding(BuildContext context, String titulo, String amount) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("$titulo:",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            )),
        Text(amount, style: Theme.of(context).textTheme.bodyLarge!),
      ]),
    );
  }

}
