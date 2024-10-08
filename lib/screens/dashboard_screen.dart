import 'dart:convert' as convert;
import 'dart:io';

import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/screens/common_widgets/custom_text_field.dart';
import 'package:inventaris/screens/common_widgets/custon_elevated_button.dart';
import 'package:inventaris/screens/inventario/inventario_incluir_screen.dart';
import 'package:inventaris/utils/app_alert.dart';

enum SingingCharacter { setor, tombo, descricao }

class DashoardTab extends StatefulWidget {
  const DashoardTab({super.key});

  @override
  State<DashoardTab> createState() => _DashoardTabState();
}

class _DashoardTabState extends State<DashoardTab> {
  late Future<List> _carregarBens;
  late bool carregouBens = false;

  String host = "app-inventario.uerr.edu.br";

  int tamanhoTextoDescricao = 55;

  final TextEditingController _controller = TextEditingController();
  String textoDaPesquisa = "";

  SingingCharacter? _character = SingingCharacter.setor;

  void _printLatestValue() {
    setState(() {
      _carregarBens = _refreshBens();
    });
  }

  List<TableRow> rowTableBens = [];

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
    List<double> larguraColunas = [0.06, 0.26, 0.46, 0.22];
    return OnBackPressed(
      perform: () {
        AppAlert.confirm(
            title: "Atenção!!!",
            text: "Deseja realmente sair?",
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
            title: Text("Dashboard"),
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
                            text: 'enviar', onClickBtnTap: _printLatestValue)
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
                            List<TableRow> rows = [];

                            rows.add(TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              // key: ValueKey(operation.observation),
                              children: [
                                _buildTableCell(context, "x", true, "C"),
                                _buildTableCell(context, "Tombo", true, "C"),
                                _buildTableCell(
                                    context, "Descrição", true, "C"),
                                _buildTableCell(context, "Setor", true, "C"),
                              ], // Pass the widgets to be set as the row content.
                            ));
                            for (Map<String, dynamic> item in list) {
                              Bem bem = Bem.fromMap(item);
                              String descricao = bem.descricao;
                              if (descricao.length >= tamanhoTextoDescricao) {
                                descricao = descricao.substring(
                                        0, tamanhoTextoDescricao) +
                                    "...";
                                bem.descricao = descricao;
                              }
                              rows.add(_buildTableRow(bem, list.indexOf(item)));
                              bens.add(bem);
                            }
                            return DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.normal),
                                child: Table(columnWidths: {
                                  0: FixedColumnWidth(
                                      MediaQuery.of(context).size.width *
                                          larguraColunas[0]),
                                  1: FixedColumnWidth(
                                      MediaQuery.of(context).size.width *
                                          larguraColunas[1]),
                                  2: FixedColumnWidth(
                                      MediaQuery.of(context).size.width *
                                          larguraColunas[2]),
                                  3: FixedColumnWidth(
                                      MediaQuery.of(context).size.width *
                                          larguraColunas[3]),
                                }, children: rows));
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

  TableRow _buildTableRow(Bem bem, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isOdd
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.tertiary,
      ),
      // key: ValueKey(operation.observation),
      children: [
        bem.inventariado != null && bem.inventariado!
            ? Icon(
                Icons.verified,
                color: Colors.green,
                size: 18.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )
            : SizedBox(),
        GestureDetector(
            onDoubleTap: () {
              _inventariar(bem);
            },
            child: _buildTableCell(context, bem.tombo, false, "L")),
        GestureDetector(
          onDoubleTap: () {
            _inventariar(bem);
          },
          child: _buildTableCell(context, bem.descricao, false, "L"),
        ),
        GestureDetector(
          onDoubleTap: () {
            _inventariar(bem);
          },
          child: _buildTableCell(context, bem.setor, false, "C"),
        ),
      ], // Pass the widgets to be set as the row content.
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

  Widget _buildTableCell(BuildContext context, String descricao, bool ehTitulo,
      String alinhamento) {
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
    _printLatestValue();
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
    var url = Uri.http(host, endPoint, {'q': ''});

    print("try url " + host + endPoint);

    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print(response.body);
      return convert.jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }
}
