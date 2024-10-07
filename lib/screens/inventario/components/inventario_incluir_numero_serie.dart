import 'package:flutter/material.dart';
import 'package:inventaris/screens/common_widgets/app_text_field.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
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
  int initTemNumeroSerieValue = 1;
  String initSetorName = '';

  // final _controller = TextEditingController();
  final _controller1 = TextEditingController();

  void _printLatestValue() {
    setState(() {
      // Globals().inventario.numero_serie = _controller.text;
      Globals().inventario.numero_serie = _controller1.text;
      widget.refreshStatusSteps();
    });
  }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed from the
  //   // widget tree.
  //   _controller.dispose();
  //   super.dispose();
  // }
  //
  @override
  void initState() {
    super.initState();
    Globals().inventario.tem_numero_serie = false;
    // _controller.addListener(_printLatestValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  initialLabelIndex: initTemNumeroSerieValue,
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
                      initTemNumeroSerieValue = index!;
                      Globals().inventario.tem_numero_serie =
                          index == 1 ? false : true!;
                      if (index! == 1) {
                        Globals().inventario.numero_serie = "";
                        _controller1.text = "";
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
                      textEditingController: _controller1,
                      title: "Qual o número de série?",
                      hint: "",
                      isListSelected: false,
                    ),
                    // const StepTitle(
                    //     title: "Qual o número de série do bem?"),
                    // CustomTextField(
                    //   label: "",
                    //   controller: _controller,
                    //   keyboardType: TextInputType.number,
                    // ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
