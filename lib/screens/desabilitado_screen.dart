import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:back_pressed/back_pressed.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/bem.dart';
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/inventario_incluir_screen.dart';
import 'package:inventaris/utils/app_alert.dart';
import 'package:inventaris/utils/constants.dart';

enum SingingCharacter { setor, tombo, descricao }

class DesabilitadoTab extends StatefulWidget {
  final Map<String, dynamic> dadosDispositivo;

  const DesabilitadoTab({super.key, required this.dadosDispositivo});

  @override
  State<DesabilitadoTab> createState() => _DesabilitadoTabState();
}

class _DesabilitadoTabState extends State<DesabilitadoTab> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  late Future<List> _carregarBens;
  late bool carregouBens = false;

  int tamanhoTextoDescricao = 75;
  List<double> larguraColunas = [0.06, 0.26, 0.46, 0.22];

  final TextEditingController _controller = TextEditingController();
  String textoDaPesquisa = "";

  SingingCharacter? _character = SingingCharacter.setor;

  void _printLatestValue() {
    setState(() {
      _carregarBens = _refreshBens();
    });
  }

  List<TableRow> rowTableBens = [];

  _registrarBemNaoLocalizado(int idBem) {
    var endPoint = '/api/inventario';
    var url = Uri.http(kHost, endPoint, {'q': ''});

    print("try url " + kHost + endPoint);

    Inventario inventario = Inventario(
        ano: 2024,
        bem: idBem,
        situacao: 3,
        cadastrado_por: 1,
        situacao_observacao: "");

    var body = convert.json.encode(inventario);
    print(body);
    var response = http.post(url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
        body: body);

    response.then((resposta) {
      print(resposta.statusCode);
      if (resposta.statusCode == 200) {
        print(resposta.body);
        // widget.callback(widget.bem.id, true);
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
    print(widget.dadosDispositivo);
    print(widget.dadosDispositivo['id']);
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(kTitulo),
        ),
        // drawer: MyDrawer(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              StepTitle(
                title: "Seu celular não esta habilitado.",
                subTitle:
                    "Favor entrar em contato com o administrador e informe os dados abaixo.",
              ),
              SizedBox(
                height: 20,
              ),
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.normal),
                child: Column(children: [
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "ID",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.dadosDispositivo['id'],
                            maxLines: 10, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "MODELO",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.dadosDispositivo['model'],
                            maxLines: 10, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "FABRICANTE",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.dadosDispositivo['manufacturer'],
                            maxLines: 10, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )
                ]),
              ),
            ],
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
    var url = Uri.http(kHost, endPoint, {'q': ''});

    print("try url " + kHost + endPoint);

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
