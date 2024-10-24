import 'package:flutter/material.dart';
import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/screens/common_widgets/form_step_screen.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_observacao.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_plaqueta_estado.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_resumo.dart';
import 'package:inventaris/screens/inventario/components/inventario_incluir_situacao.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
import 'package:inventaris/utils/app_toast_notification.dart';
import 'package:inventaris/utils/constants.dart';

class InventarioIncluirScreen extends StatefulWidget {
  final Function(int, bool) callback;
  final Bem bem;

  const InventarioIncluirScreen(
      {super.key, required this.callback, required this.bem});

  @override
  InventarioIncluirScreenState createState() => InventarioIncluirScreenState();
}

class InventarioIncluirScreenState extends State<InventarioIncluirScreen> {
  List<bool> listStatus = [true, false, true, false];
  int numberSteps = 5;

  @override
  void initState() {
    Globals().inventario = Inventario(
        ano: 2024,
        bem: widget.bem.id,
        situacao: 1,
        situacao_observacao: "",
        estado: widget.bem.estado,
        tem_numero_serie: false,
        plaqueta: false,
        numero_serie: "",
        dispositivo: Globals().esteDispositivo.id,
        cadastrado_por: Globals().esteDispositivo.cpf);
    Globals().inventario_situacao = kSim;
    Globals().bem = widget.bem;
    Globals().inventario_estado = widget.bem.estado_descricao!;
    Globals().inventario_tem_numero_serie = kNao;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int activeStep = 0;
    return FormStepScreen(
      title: "Inventariar Bem",
      openScreen: _openScreen,
      listStatus: listStatus,
      callbackRegister: _registrar,
      numberSteps: 4,
      stepControlView: true,
      activeStep: activeStep,
    );
  }

  refreshStatusSteps() {
    Inventario inventario = Globals().inventario;
    setState(() {
      int situacao = inventario.situacao;
      String situacao_observacao = inventario.situacao_observacao!;
      listStatus[0] =
          situacao != null && (situacao == 1 || situacao_observacao != "");

      // // ###################################################
      // bool? tem_numero_serie = inventario.tem_numero_serie;
      // String? numero_serie = inventario.numero_serie;
      // listStatus[1] = tem_numero_serie != null &&
      //     numero_serie != null &&
      //     (tem_numero_serie == false || numero_serie != "");
      //
      // ###################################################
      bool? tem_plaqueta = inventario.plaqueta;
      int? estadoBem = inventario.estado;
      listStatus[1] =
          tem_plaqueta != null && estadoBem != null; // && estadoBem != "";

      // ###################################################
      listStatus[2] = true;

      // ###################################################
      listStatus[3] =
          listStatus[0] && listStatus[1] && listStatus[2] && listStatus[3];
    });
  }

  _registrar() {
    var response = AppHttp.post('/api/inventario', Globals().inventario);

    response.then((resposta) {
      print(resposta.statusCode);
      if (resposta.statusCode == 200) {
        widget.callback(widget.bem.id, true);
        AppToastNotification.success(text: kMsgInventarioOk, context: context);
        Navigator.pop(context);
      } else {
        if (resposta.statusCode == 404) {
          print("resposta vazia");
        } else {
          print('Request failed with status: ${resposta.statusCode}.');
          throw Exception('Erro ao tentar acessar servidor externo ${resposta.body}');
        }
      }
    });
  }

  _openScreen(int id) {
    switch (id) {
      case 0:
        return InventarisIncluirSituacao(
            refreshStatusSteps: refreshStatusSteps);
      // case 1:
      //   if (Globals().inventario.tem_numero_serie == null) {
      //     Globals().inventario.tem_numero_serie = false;
      //   } else {
      //     listStatus[1] = true;
      //   }
      //   return InventarisIncluirNumeroSerie(
      //       refreshStatusSteps: refreshStatusSteps);
      case 1:
        if (Globals().inventario.plaqueta == null) {
          Globals().inventario.plaqueta = false;
        }
        listStatus[1] = true;
        return InventarisIncluirPlaquetaEstado(
            refreshStatusSteps: refreshStatusSteps);
      case 2:
        if (Globals().inventario.observacao == null) {
          Globals().inventario.observacao = '';
        }
        return InventarisIncluirObservacao(
            refreshStatusSteps: refreshStatusSteps);
      case 3:
        listStatus[3] = listStatus[0] && listStatus[1] && listStatus[2];
        return InventarisIncluirResumo(refreshStatusSteps: refreshStatusSteps);
    }
  }
}
