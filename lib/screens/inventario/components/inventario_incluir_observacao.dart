import 'package:flutter/material.dart';
import 'package:inventaris/entities/estado.dart';
import 'package:inventaris/screens/common_widgets/app_text_field.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';

class InventarisIncluirObservacao extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirObservacao(
      {super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirObservacao> createState() {
    return _InventarisIncluirObservacaoState();
  }
}

class _InventarisIncluirObservacaoState
    extends State<InventarisIncluirObservacao> {
  /// This is list of city which will pass to the drop down.
  final TextEditingController _observacaoController = TextEditingController();

  String host = "app-inventario.uerr.edu.br";
  int initTemPlaquetaValue = 0;

  void _observacaoControllerEvent() {
    setState(() {
      Globals().inventario.observacao = _observacaoController.text;
      widget.refreshStatusSteps();
    });
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _observacaoController.addListener(_observacaoControllerEvent);
  }

  @override
  Widget build(BuildContext context) {
    List<Estado> estados = [];

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildDadosBem(),
            AppTextField(
              textEditingController: _observacaoController,
              title:
                  "Informe abaixo apenas informações divergentes da descrição do bem",
              hint: "",
              isListSelected: false,
              voidCallback: _observacaoControllerEvent,
              minLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
