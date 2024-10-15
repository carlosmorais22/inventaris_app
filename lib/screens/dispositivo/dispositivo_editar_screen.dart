import 'package:flutter/material.dart';
import 'package:inventaris/entities/dispositivo.dart';
import 'package:inventaris/screens/common_widgets/app_text_field.dart';
import 'package:inventaris/screens/common_widgets/custon_elevated_button.dart';
import 'package:inventaris/screens/common_widgets/custon_outlined_button.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/app_alert.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
import 'package:inventaris/utils/constants.dart';
import 'package:keyboard_service/keyboard_service.dart';

class DispositivoEditarScreen extends StatefulWidget {
  final Function(String, bool) callback;
  final Dispositivo dispositivo;

  const DispositivoEditarScreen(
      {super.key, required this.callback, required this.dispositivo});

  @override
  DispositivoEditarScreenState createState() => DispositivoEditarScreenState();
}

class DispositivoEditarScreenState extends State<DispositivoEditarScreen> {
  final _controllerNome = TextEditingController();
  final _controllerCpf = TextEditingController();

  void _refreshNome() {
    setState(() {
      Globals().dispositivo.nome = _controllerNome.text;
    });
  }

  void _refreshCpf() {
    setState(() {
      Globals().dispositivo.cpf = _controllerCpf.text;
    });
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerCpf.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Globals().dispositivo = widget.dispositivo;
    if (Globals().dispositivo.nome == null) Globals().dispositivo.nome = "";
    _controllerNome.text = Globals().dispositivo.nome ?? "";
    if (Globals().dispositivo.cpf == null) Globals().dispositivo.cpf = "";
    _controllerCpf.text = Globals().dispositivo.cpf ?? "";
    super.initState();
    _controllerNome.addListener(_refreshNome);
    _controllerCpf.addListener(_refreshCpf);
  }

  @override
  Widget build(BuildContext context) {
    int activeStep = 0;
    return KeyboardAutoDismiss(
        scaffold: Scaffold(
      appBar: AppBar(
          leading: activeStep > 0
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      activeStep--;
                    });
                  },
                )
              : SizedBox(),
          titleSpacing: 0,
          title: Text(kTtuloDispositivoEditar,
              style: TextStyle(color: Theme.of(context).colorScheme.surface)),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _cancelar();
              },
            ),
          ]),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.normal),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // StepTitle(title: "Dados do bem"),
              SizedBox(height: 15),
              Container(
                color: Theme.of(context).colorScheme.secondary,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Table(columnWidths: {
                  0: FixedColumnWidth(
                      (MediaQuery.of(context).size.width - 40) * 0.25),
                  1: FixedColumnWidth(
                      (MediaQuery.of(context).size.width - 40) * 0.75),
                }, children: [
                  TableRow(
                    children: [
                      Text(kDispositivoId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(Globals().dispositivo.id),
                    ], // Pass the widgets to be set as the row content.
                  ),
                  TableRow(
                    children: [
                      Text(kDispositivoNome,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(Globals().dispositivo.nome ?? ""),
                    ], // Pass the widgets to be set as the row content.
                  ),
                  TableRow(
                    children: [
                      Text(kDispositivoCpf,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(Globals().dispositivo.cpf ?? ""),
                    ], // Pass the widgets to be set as the row content.
                  ),
                  TableRow(
                    children: [
                      Text(kDispositivoModelo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(Globals().dispositivo.modelo),
                    ], // Pass the widgets to be set as the row content.
                  ),
                  TableRow(
                    children: [
                      Text(kDispositivoFabricante,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(Globals().dispositivo.fabricante),
                    ], // Pass the widgets to be set as the row content.
                  ),
                  TableRow(
                    children: [
                      Text(kDispositivoStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(Globals().dispositivo.status ? "Ativo" : "Inativo"),
                    ], // Pass the widgets to be set as the row content.
                  ),
                ]),
              ),
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // BuildDadosBem(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextField(
                            textEditingController: _controllerNome,
                            title: "Qual o nome do usuário do dispositivo?",
                            hint: "",
                            isListSelected: false,
                          ),
                          AppTextField(
                            textEditingController: _controllerCpf,
                            title:
                                "Qual o cpf do usuário responsável pelo inventário?",
                            hint: "",
                            isListSelected: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustonOutlinedButton(
                        text: kVoltar,
                        onClickBtnTap: () {
                          setState(() {
                            KeyboardService.dismiss();
                            activeStep--;
                          });
                        }),
                    SizedBox(width: 15),
                    CustonElevatedButton(
                        text: kRegistrar,
                        onClickBtnTap: Globals().dispositivo.nome!.isNotEmpty &&
                                Globals().dispositivo.cpf!.isNotEmpty
                            ? () {
                                _registrar();
                              }
                            : null)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
    ;
  }

  _cancelar() {
    AppAlert.confirm(
        title: kAtencao,
        text: kMsgDesejaSair,
        context: context,
        onConfirmBtnTap: () async {
          Navigator.pop(context);
        });
  }

  _registrar() {
    AppAlert.confirm(
        title: kAtencao,
        text: kMsgConfirmaEdicao,
        context: context,
        onConfirmBtnTap: () async {
          var response = AppHttp.put('/api/dispositivo', Globals().dispositivo);

          response.then((resposta) {
            print(resposta.statusCode);
            if (resposta.statusCode == 200) {
              widget.callback(widget.dispositivo.id!, true);
              AppAlert.info(
                  title: kSucesso,
                  text: kMsgDispositivoOk,
                  context: context,
                  onConfirmBtnTap: () async {
                    Navigator.pop(context);
                  });
            } else {
              if (resposta.statusCode == 404) {
                print("resposta vazia");
              } else {
                print('Request failed with status: ${resposta.statusCode}.');
                throw Exception('Erro ao tentar acessar servidor externo');
              }
            }
          });
        });
  }
}
