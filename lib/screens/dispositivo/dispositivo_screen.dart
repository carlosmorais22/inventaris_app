import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventaris/entities/dispositivo.dart';
import 'package:inventaris/screens/dispositivo/dispositivo_editar_screen.dart';
import 'package:inventaris/utils/app_alert.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
import 'package:inventaris/utils/constants.dart';

class DispositivoScreen extends StatefulWidget {
  const DispositivoScreen({super.key});

  @override
  State<DispositivoScreen> createState() => _DispositivoScreenState();
}

class _DispositivoScreenState extends State<DispositivoScreen> {
  late Future<List> _carregarDispositivos;
  late bool carregouDispositivos = false;

  int tamanhoTextoDescricao = 75;
  List<double> larguraColunas = [0.25, 0.36, 0.15, 0.12];

  void _atualizar() {
    setState(() {
      _carregarDispositivos = _refreshDispositivos();
    });
  }

  List<TableRow> rowTable = [];

  @override
  void initState() {
    _carregarDispositivos = _refreshDispositivos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(kTtuloDispositivoListar),
        ),
        // drawer: MyDrawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.normal),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: FutureBuilder(
                      future: _carregarDispositivos,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List list = snapshot.data;

                          List<Dispositivo> dispositivos = [];
                          List<Widget> rows = [];

                          List<dynamic> dados = ["ID", "Nome", "CPF", "Status"];
                          rows.add(_buildRow(dados, 0, true));
                          for (Map<String, dynamic> item in list) {
                            Dispositivo dispositivo = Dispositivo.fromMap(item);
                            String status = "Ativo";
                            if (!dispositivo.status) status = "Inativo";
                            dados = [
                              dispositivo.id,
                              dispositivo.nome,
                              dispositivo.cpf,
                              status
                            ];
                            rows.add(
                              GestureDetector(
                                onDoubleTap: () {
                                  _editarDispositivo(dispositivo);
                                },
                                child: Slidable(
                                    key: const ValueKey(0),
                                    startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        dismissible:
                                            DismissiblePane(onDismissed: () {}),
                                        dragDismissible: false,
                                        children: [
                                          !dispositivo.status
                                              ? SlidableAction(
                                                  onPressed: (context) {
                                                    _habilitar(dispositivo);
                                                  },
                                                  backgroundColor: Colors.green,
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  icon: Icons.done,
                                                  label: "Habilitar",
                                                  spacing: 5,
                                                  padding: EdgeInsets.zero)
                                              : SlidableAction(
                                                  onPressed: (context) {
                                                    _desabilitar(dispositivo);
                                                  },
                                                  backgroundColor: Colors.red,
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  icon: Icons.remove_done,
                                                  label: "Desabilitar",
                                                  spacing: 5,
                                                  padding: EdgeInsets.zero)
                                        ]),
                                    // The child of the Slidable is what the user sees when the component is not dragged.
                                    child: _buildRow(
                                        dados, list.indexOf(item), false)),
                              ),
                            );
                            dispositivos.add(dispositivo);
                          }
                          return DefaultTextStyle(
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.normal),
                              child: Column(children: rows));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<dynamic> lista, int index, bool ehTitulo) {
    return Container(
      constraints: BoxConstraints(
          minHeight: ehTitulo ? 10 : 45, minWidth: double.infinity),
      // width: double.infinity,
      color: ehTitulo
          ? Theme.of(context).colorScheme.secondary
          : index.isOdd
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          _buildCell(context, lista[0], ehTitulo, ehTitulo ? "C" : 'L', 0),
          Expanded(
            child: _buildCell(
                context, lista[1] ?? "", ehTitulo, ehTitulo ? "C" : "L", -1),
          ),
          _buildCell(
              context, lista[2] ?? "", ehTitulo, ehTitulo ? "C" : "L", 2),
          _buildCell(context, lista[3], ehTitulo, ehTitulo ? "C" : "C", 3),
        ],
      ),
    );
  }

  _desabilitar(Dispositivo dispositivo) {
    AppAlert.confirm(
        title: kAtencao,
        text: kMsgConfirmaDesabilitarDispositivo,
        context: context,
        onConfirmBtnTap: () async {
          dispositivo.status = false;
          _atualizarStatus(dispositivo);
        });
  }

  _habilitar(Dispositivo dispositivo) {
    AppAlert.confirm(
        title: kAtencao,
        text: kMsgConfirmaHabilitarDispositivo,
        context: context,
        onConfirmBtnTap: () async {
          dispositivo.status = true;
          _atualizarStatus(dispositivo);
        });
  }

  _atualizarStatus(Dispositivo dispositivo) {
    var response = AppHttp.put(
        '/api/dispositivo',
        {"Content-Type": "application/json", "accept": "application/json"},
        convert.json.encode(dispositivo));

    response.then((resposta) {
      print(resposta.statusCode);
      if (resposta.statusCode == 200) {
        // widget.callback(widget.dispositivo.id!, true);
        AppAlert.info(
            title: kSucesso,
            text: kMsgDispositivoOk,
            context: context,
            onConfirmBtnTap: () async {
              setState(() {
                _carregarDispositivos = _refreshDispositivos();
              });
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
  }

  _editarDispositivo(Dispositivo dispositivo) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DispositivoEditarScreen(
              callback: _atualizarDispositivo, dispositivo: dispositivo)),
    );
  }

  Widget _buildCell(BuildContext context, String descricao, bool ehTitulo,
      String alinhamento, int index) {
    TextStyle textStyle = Theme.of(context).textTheme.labelSmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.normal);
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    if (ehTitulo) {
      textStyle = Theme.of(context).textTheme.displaySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold);
      mainAxisAlignment = MainAxisAlignment.center;
    }
    if (alinhamento == "R") {
      crossAxisAlignment = CrossAxisAlignment.end;
    } else {
      if (alinhamento == "C") {
        crossAxisAlignment = CrossAxisAlignment.center;
      }
    }

    return Container(
      width: index >= 0
          ? MediaQuery.of(context).size.width * larguraColunas[index]
          : double.infinity,
      padding: EdgeInsets.only(top: 3, bottom: 2),
      // height: 40,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.max,
        children: [
          Wrap(
            children: [
              Text(
                descricao,
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _atualizarDispositivo(String id, bool resposta) {
    if (resposta)
      print('Dispositivo com o id ' + id + ' foi realizado com sucesso');
    _atualizar();
  }

  // retorna dispositivos para o tipo e texto do filtro
  Future<List> _refreshDispositivos() async {
    var endPoint = '/api/dispositivo';
    return AppHttp.list(endPoint);
  }
}
