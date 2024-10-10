import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:inventaris/entities/estado.dart';
import 'package:inventaris/screens/common_widgets/app_text_field.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
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

  int initTemPlaquetaValue = 0;
  String initEstadoNome = '';

  // final _controller = TextEditingController();

  late Future<List> _carregarEstados;

  void _estadoControllerEvent() {
    if (_estados.length > 0) {
      var estadoSelecionado =
          _estados.firstWhere((x) => x.descricao == _estadoController.text);

      setState(() {
        Globals().inventario.estado = estadoSelecionado.id;
        Globals().inventario_estado = estadoSelecionado.descricao;
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
    _carregarEstados = AppHttp.list('/api/estado');
    _estadoController.text = Globals().bem.estado_descricao!;
    Globals().inventario_estado = Globals().bem.estado_descricao!;
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
}
