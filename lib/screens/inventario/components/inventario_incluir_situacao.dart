import 'dart:convert' as convert;

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/setor.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:toggle_switch/toggle_switch.dart';

class InventarisIncluirSituacao extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirSituacao(
      {super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirSituacao> createState() {
    return _InventarisIncluirSituacaoState();
  }
}

class _InventarisIncluirSituacaoState extends State<InventarisIncluirSituacao> {
  String host = "192.168.1.3:5009";
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
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.normal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BuildDadosBem(),
              SizedBox(
                height: 10,
              ),
              StepTitle(title: "O bem foi localizado?"),
              Center(
                child: ToggleSwitch(
                  initialLabelIndex: initSituacaoValue,
                  totalSwitches: 3,
                  minWidth: (MediaQuery.of(context).size.width - 40) * .3,
                  activeBgColor: [Theme.of(context).colorScheme.primary!],
                  labels: ["Sim", "Não", "Outro Setor"],
                  customTextStyles: [
                    Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.background!),
                  ],
                  onToggle: (index) {
                    setState(() {
                      initSituacaoValue = index!;
                      Globals().inventario.situacao = index! + 1;
                      if (index! + 1 != 3) {
                        Globals().inventario.situacao_observacao = "";
                      }
                    });
                    widget.refreshStatusSteps();
                  },
                ),
              ),
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
                                Globals().inventario.situacao_observacao =
                                    value;
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
