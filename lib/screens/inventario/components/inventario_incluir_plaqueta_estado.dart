import 'dart:convert' as convert;

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/estado.dart';
import 'package:inventaris/screens/common_widgets/app_text_field.dart';
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
  /// This is list of city which will pass to the drop down.
  List<SelectedListItem> _listaDeEstados = [];
  List<Estado> _estados = [];
  final TextEditingController _estadoController = TextEditingController();

  String host = "app-inventario.uerr.edu.br";
  int initTemPlaquetaValue = 0;
  String initEstadoNome = '';

  // final _controller = TextEditingController();

  late Future<List> _carregarEstados;

  void _estadoControllerEvent() {
    print("------------------------------------");
    print(_estados.length);
    print("------------------------------------");
    if (_estados.length > 0) {
      var estadoSelecionado =
          _estados.firstWhere((x) => x.descricao == _estadoController.text);

      setState(() {
        Globals().inventario.estado = estadoSelecionado.id;
        widget.refreshStatusSteps();
      });
    }
  }

  @override
  void dispose() {
    _estadoController.dispose();
    // _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _estadoController.addListener(_estadoControllerEvent);
    _carregarEstados = _refreshEstados();
    _estadoController.text = Globals().bem.estado_descricao!;
  }

  @override
  Widget build(BuildContext context) {
    List<Estado> estados = [];

    _listaDeEstados = [];
    _estados = [];
    _carregarEstados.then((list) {
      for (Map<String, dynamic> map in list) {
        Estado estado = Estado.fromMap(map);
        Globals().inventario!.estado ??= estado.id;
        estados.add(estado);
        _estados.add(estado);
        _listaDeEstados.add(
          SelectedListItem(
            name: estado.descricao,
            value: estado.id.toString(),
          ),
        );
      }
    });

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          BuildDadosBem(),
          StepTitle(title: "O bem tem plaqueta de metal?"),
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
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                textEditingController: _estadoController,
                title: "Qual o estado físico atual do bem?",
                hint: "",
                readOnly: true,
                isListSelected: true,
                list: _listaDeEstados,
                voidCallback: _estadoControllerEvent,
              ),
            ],
          )
        ],
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
