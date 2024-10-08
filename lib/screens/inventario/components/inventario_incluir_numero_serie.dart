import 'package:flutter/material.dart';
import 'package:inventaris/screens/common_widgets/app_text_field.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

class InventarisIncluirNumeroSerie extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirNumeroSerie(
      {super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirNumeroSerie> createState() {
    return _InventarisIncluirNumeroSerieState();
  }
}

class _InventarisIncluirNumeroSerieState
    extends State<InventarisIncluirNumeroSerie> {
  // late int initTemNumeroSerieValue;

  List<String> _listaSituacoes = [kSim, kNao];
  final _controller = TextEditingController();

  void _printLatestValue() {
    setState(() {
      Globals().inventario.numero_serie = _controller.text;
      widget.refreshStatusSteps();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_printLatestValue);
    if (Globals().inventario.numero_serie != null)
      _controller.text = Globals().inventario.numero_serie!;
  }

  @override
  Widget build(BuildContext context) {
    double _sizeWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          BuildDadosBem(),
          StepTitle(title: "O bem tem Número de Série?"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ToggleSwitch(
                  initialLabelIndex:
                      Globals().inventario.tem_numero_serie != null &&
                              Globals().inventario.tem_numero_serie!
                          ? 0
                          : 1,
                  totalSwitches: 2,
                  customWidths: [_sizeWidth * .4, _sizeWidth * .4],
                  inactiveBgColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  activeBgColor: [Theme.of(context).colorScheme.primary],
                  labels: _listaSituacoes,
                  customTextStyles: [
                    Theme.of(context).textTheme.displayMedium!
                  ],
                  onToggle: (index) {
                    setState(() {
                      // initTemNumeroSerieValue = index!;
                      Globals().inventario.tem_numero_serie =
                          index == 1 ? false : true!;
                      if (index! == 1) {
                        Globals().inventario.numero_serie = "";
                        _controller.text = "";
                      }
                    });
                    widget.refreshStatusSteps();
                  },
                ),
              ),
            ],
          ),
          Globals().inventario.tem_numero_serie != null &&
                  Globals().inventario.tem_numero_serie!
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      textEditingController: _controller,
                      title: "Qual o número de série?",
                      hint: "",
                      isListSelected: false,
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
