import 'package:flutter/material.dart';
import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/screens/common_widgets/form_step_screen.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_numero_serie.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_observacao.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_plaqueta_estado.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_situacao.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_resumo.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/constants.dart';

class InventarioIncluirScreen extends StatefulWidget {
  final VoidCallback callback;
  final Bem bem;

  const InventarioIncluirScreen(
      {super.key, required this.callback, required this.bem});

  @override
  InventarioIncluirScreenState createState() => InventarioIncluirScreenState();
}

class InventarioIncluirScreenState extends State<InventarioIncluirScreen> {
  List<bool> listStatus = [true, false, false, true, false];
  int numberSteps = 5;

  @override
  void initState() {
    Globals().inventario = Inventario(
        ano: 2024, bem: widget.bem.id, situacao: 1, estado: widget.bem.estado, tem_numero_serie: false, plaqueta: false, numero_serie: "");
    Globals().inventario_situacao = kSim;
    Globals().bem = widget.bem;
    Globals().inventario_estado = widget.bem.estado_descricao!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int activeStep = 0;
    return FormStepScreen(
      title: "Inventariar Bem",
      openScreen: _openScreen,
      listStatus: listStatus,
      callbackRegister: _register,
      numberSteps: 5,
      stepControlView: true,
      activeStep: activeStep,
    );
  }

  refreshStatusSteps() {
    Inventario loan = Globals().inventario;
    setState(() {
      int situacao = Globals().inventario.situacao;
      String situacao_observacao = Globals().inventario.situacao_observacao!;
      listStatus[0] =
          situacao != null && (situacao != 3 || situacao_observacao != "");

      bool? tem_numero_serie = Globals().inventario.tem_numero_serie;
      String? numero_serie = Globals().inventario.numero_serie;
      listStatus[1] =
          tem_numero_serie != null && (!tem_numero_serie || numero_serie != "");

      bool? tem_plaqueta = Globals().inventario.plaqueta;
      int? estadoBem = Globals().inventario.estado;
      listStatus[2] =
          tem_plaqueta != null && estadoBem != null; // && estadoBem != "";
      listStatus[3] = true;
      listStatus[4] = listStatus[0] && listStatus[1] && listStatus[2] && listStatus[3];
    });
  }

  _register() {}

  _openScreen(int id) {
    switch (id) {
      case 0:
        return InventarisIncluirSituacao(
            refreshStatusSteps: refreshStatusSteps);
      case 1:
        if (Globals().inventario.tem_numero_serie == null) {
          Globals().inventario.tem_numero_serie = false;
        }
        listStatus[1] = true;
        return InventarisIncluirNumeroSerie(
            refreshStatusSteps: refreshStatusSteps);
      case 2:
        if (Globals().inventario.plaqueta == null) {
          Globals().inventario.plaqueta = false;
        }
        listStatus[2] = true;
        return InventarisIncluirPlaquetaEstado(
            refreshStatusSteps: refreshStatusSteps);
      case 3:
        if (Globals().inventario.observacao == null) {
          Globals().inventario.observacao = '';
        }
        return InventarisIncluirObservacao(
            refreshStatusSteps: refreshStatusSteps);
      case 4:
        listStatus[4] = listStatus[0] && listStatus[1] && listStatus[2] && listStatus[3];
        return InventarisIncluirResumo(refreshStatusSteps: refreshStatusSteps);
    }
  }
}
