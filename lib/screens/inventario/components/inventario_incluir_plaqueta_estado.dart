import 'dart:convert' as convert;

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/estado.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:toggle_switch/toggle_switch.dart';

class InventarisIncluirPlaquetaEstado extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirPlaquetaEstado(
      {super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirPlaquetaEstado> createState() {
    return _InventarisIncluirPlaquetaEstadoState();
  }
}

class _InventarisIncluirPlaquetaEstadoState
    extends State<InventarisIncluirPlaquetaEstado> {
  String host = "192.168.1.3:5009";
  int initTemPlaquetaValue = 0;
  String initEstadoNome = '';

  final _controller = TextEditingController();

  late Future<List> _carregarEstados;

  void _printLatestValue() {
    setState(() {
      Globals().inventario.numero_serie = _controller.text;
      widget.refreshStatusSteps();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _controller.addListener(_printLatestValue);
    _carregarEstados = _refreshEstados();
  }

  @override
  Widget build(BuildContext context) {
    List<String> suggestions = [];
    List<Estado> estados = [];

    _carregarEstados.then((list) {
      for (Map<String, dynamic> map in list) {
        Estado estado = Estado.fromMap(map);
        Globals().inventario!.estado ??= estado.id;
        estados.add(estado);
        suggestions.add(estado.descricao);
      }
    });

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.normal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BuildDadosBem(),
              SizedBox(
                height: 10,
              ),
              StepTitle(title: "O bem tem Plaqueta?"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ToggleSwitch(
                      initialLabelIndex: initTemPlaquetaValue,
                      totalSwitches: 2,
                      minWidth: (MediaQuery.of(context).size.width - 40) * .3,
                      activeBgColor: [Theme.of(context).colorScheme.primary!],
                      labels: ["Sim", "Não"],
                      customTextStyles: [
                        Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.background!),
                      ],
                      onToggle: (index) {
                        setState(() {
                          initTemPlaquetaValue = index!;
                          Globals().inventario.plaqueta =
                              index == 1 ? false : true!;
                        });
                        widget.refreshStatusSteps();
                      },
                    ),
                  ),
                  StepTitle(title: "Qual o estado do bem?"),
                  EasyAutocomplete(
                      initialValue: initEstadoNome,
                      suggestions: suggestions,
                      inputTextStyle: Theme.of(context).textTheme.titleMedium!,
                      suggestionBuilder: (data) {
                        return Container(
                            margin: EdgeInsets.all(1),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            child: Text(data,
                                style:
                                    Theme.of(context).textTheme.titleMedium));
                      },
                      onChanged: (value) => print('onChanged value: $value'),
                      onSubmitted: (value) {
                        setState(() {
                          // Globals().inventario.estado =
                          //     suggestions.in;
                        });
                        print(Globals().inventario.situacao_observacao);
                        widget.refreshStatusSteps();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // retorna bens para o tipo e texto do filtro
  Future<List> _refreshEstados() async {
    var endPoint = '/api/estado';
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
