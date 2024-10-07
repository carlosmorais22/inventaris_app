import 'dart:convert' as convert;

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/setor.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';

class InventarisIncluirSumary extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirSumary({super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirSumary> createState() {
    return _InventarisIncluirSumaryState();
  }
}

class _InventarisIncluirSumaryState extends State<InventarisIncluirSumary> {
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

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BuildDadosBem(),
            StepTitle(title: "O inventário deste bem está correto?"),
            Globals().inventario.situacao == 3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StepTitle(title: "Em qual setor o bem foi localizado?"),
                      EasyAutocomplete(
                          initialValue: initSetorName,
                          suggestions: suggestions,
                          inputTextStyle:
                              Theme.of(context).textTheme.titleMedium!,
                          suggestionBuilder: (data) {
                            return Container(
                                margin: EdgeInsets.all(1),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
                                child: Text(data,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium));
                          },
                          onChanged: (value) =>
                              print('onChanged value: $value'),
                          onSubmitted: (value) {
                            setState(() {
                              Globals().inventario.situacao_observacao = value;
                            });
                            print(Globals().inventario.situacao_observacao);
                            widget.refreshStatusSteps();
                          }),
                    ],
                  )
                : SizedBox(),
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
}
