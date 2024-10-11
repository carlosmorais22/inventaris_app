import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/screens/common_widgets/custom_text_field.dart';
import 'package:inventaris/screens/common_widgets/custon_elevated_button.dart';
import 'package:inventaris/screens/dispositivo/dispositivo_screen.dart';
import 'package:inventaris/screens/inventario/inventario_incluir_screen.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/app_alert.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
import 'package:inventaris/utils/constants.dart';

enum SingingCharacter { setor, tombo, descricao }

class DashoardTab extends StatefulWidget {
  const DashoardTab({super.key});

  @override
  State<DashoardTab> createState() => _DashoardTabState();
}

class _DashoardTabState extends State<DashoardTab> {
  late Future<List> _carregarBens;

  int tamanhoTextoDescricao = 75;
  List<double> larguraColunas = [0.06, 0.26, 0.46, 0.22];

  final TextEditingController _controller = TextEditingController();
  String textoDaPesquisa = "";

  SingingCharacter? _character = SingingCharacter.setor;

  void _atualizarPagina() {
    setState(() {
      _carregarBens = _refreshBens();
    });
  }

  List<TableRow> rowTable = [];

  _registrarBemNaoLocalizado(int idBem) {
    var endPoint = '/api/inventario';

    Inventario inventario = Inventario(
        ano: 2024,
        bem: idBem,
        situacao: 3,
        cadastrado_por: Globals().esteDispositivo.cpf,
        situacao_observacao: "");

    var body = convert.json.encode(inventario);
    print(body);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "application/json"
    };
    var response = AppHttp.post(endPoint, headers, body);

    response.then((resposta) {
      print(resposta.statusCode);
      if (resposta.statusCode == 200) {
        print(resposta.body);
        AppAlert.info(
            title: kSucesso,
            text: kMsgInventarioNaoLocalizadoOk,
            context: context);
        setState(() {
          _carregarBens = _refreshBens();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _carregarBens = _refreshBens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackPressed(
      perform: () {
        AppAlert.confirm(
            title: kAtencao,
            text: kMsgDesejaSair,
            context: context,
            onConfirmBtnTap: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            });
      },
      child: KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(kTitulo),
            actions: <Widget>[
              Globals().esteDispositivo.is_adm!
                  ? IconButton(
                icon: Icon(
                  Icons.settings_cell,
                  color: Colors.white,
                ),
                onPressed: () {
                  _exibirDispositivos();
                },
              )
                  : SizedBox(),
            ],
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
                    Row(
                      children: [
                        Radio<SingingCharacter>(
                            value: SingingCharacter.setor,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                              });
                            }),
                        const Text('Setor: '),
                        Radio<SingingCharacter>(
                            value: SingingCharacter.tombo,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                              });
                            }),
                        const Text('Tombo: '),
                        Radio<SingingCharacter>(
                            value: SingingCharacter.descricao,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                              });
                            }),
                        const Text('Descrição: '),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Digite um valor:",
                            controller: _controller,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustonElevatedButton(
                            text: 'enviar', onClickBtnTap: _atualizarPagina)
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: FutureBuilder(
                        future: _carregarBens,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data;

                            List<Bem> bens = [];
                            List<Widget> rows = [];

                            List<dynamic> dados = [
                              "",
                              "Tombo",
                              "Descrição",
                              "Setor"
                            ];
                            rows.add(_buildRow(dados, 0, true));
                            for (Map<String, dynamic> item in list) {
                              Bem bem = Bem.fromMap(item);
                              String descricao = bem.descricao;
                              if (descricao.length >= tamanhoTextoDescricao) {
                                descricao = descricao.substring(
                                    0, tamanhoTextoDescricao) +
                                    "...";
                                bem.descricao = descricao;
                              }
                              dados = [
                                bem.inventariado,
                                bem.tombo,
                                bem.descricao,
                                bem.setor
                              ];
                              rows.add(
                                GestureDetector(
                                  onDoubleTap: () {
                                    _inventariar(bem);
                                  },
                                  child: Slidable(
                                      key: const ValueKey(0),
                                      startActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          dismissible: DismissiblePane(
                                              onDismissed: () {}),
                                          dragDismissible: false,
                                          children: [
                                            SlidableAction(
                                                onPressed: (context) {
                                                  AppAlert.confirm(
                                                      title: kAtencao,
                                                      text:
                                                      kMsgConfirmaBemNaoEncontraro,
                                                      context: context,
                                                      onConfirmBtnTap: () {
                                                        _registrarBemNaoLocalizado(
                                                            bem.id);
                                                      });
                                                  print(bem.id);
                                                },
                                                backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                                foregroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                icon: Icons.fmd_bad,
                                                label: kBemNaoLozalizado,
                                                spacing: 5,
                                                padding: EdgeInsets.zero)
                                          ]),
                                      // The child of the Slidable is what the user sees when the component is not dragged.
                                      child: _buildRow(
                                          dados, list.indexOf(item), false)),
                                ),
                              );
                              bens.add(bem);
                            };
                            int resgistrsEncontaados = list.length;
                            return DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.normal),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(resgistrsEncontaados > 0 ? resgistrsEncontaados.toString() + " registro(s) encontrado(s)" : "", style: Theme.of(context).textTheme.titleSmall,),
                                    Column(children: rows),
                                  ],
                                ));
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
          Container(
            width: MediaQuery.of(context).size.width * larguraColunas[0],
            child: ehTitulo
                ? Text("")
                : lista[0] != null
                ? lista[0]! == 3
                ? Icon(
              Icons.verified,
              color: Colors.deepOrange,
              size: 18.0,
            )
                : Icon(
              Icons.verified,
              color: Colors.green,
              size: 18.0,
            )
                : SizedBox(),
          ),
          _buildCell(context, lista[1], ehTitulo, "L", 1),
          Expanded(
            child: _buildCell(context, lista[2], ehTitulo, "L", -1),
          ),
          _buildCell(context, lista[3], ehTitulo, "C", 3),
        ],
      ),
    );
  }

  _inventariar(Bem bem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InventarioIncluirScreen(
              callback: _atualizarBemInventariado, bem: bem)),
    );
  }

  _exibirDispositivos() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DispositivoScreen(),
        ));
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
      width: index > 0
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

  _atualizarBemInventariado(int idBem, bool resposta) {
    if (resposta)
      print('Bem com o id ' + idBem.toString() + ' foi realizado com sucesso');
    _atualizarPagina();
  }

  // retorna bens para o tipo e texto do filtro
  Future<List> _refreshBens() async {
    if (_controller.text.isEmpty) {
      return [];
    }
    var endPoint = '';
    switch (_character) {
      case SingingCharacter.setor:
        endPoint = '/api/bem/setor/' + _controller.text;
        break;
      case SingingCharacter.tombo:
        endPoint = '/api/bem/tombo/' + _controller.text;
        break;
      case SingingCharacter.descricao:
        endPoint = '/api/bem/descricao/' + _controller.text;
        break;
      default:
        endPoint = '/api/bem/setor/' + _controller.text;
    }
    return AppHttp.list(endPoint);
  }
}
