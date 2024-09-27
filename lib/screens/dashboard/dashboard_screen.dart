import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/screens/common_widgets/custom_text_field.dart';
import 'package:inventaris/screens/common_widgets/custon_elevated_button.dart';

import 'package:inventaris/utils/my_alert.dart';
import 'package:inventaris/shared/translate_app.dart';

enum SingingCharacter { setor, tombo, descricao }

class DashoardTab extends StatefulWidget {
  const DashoardTab({super.key});

  @override
  State<DashoardTab> createState() => _DashoardTabState();
}

class _DashoardTabState extends State<DashoardTab> {
  late Future<List> _carregarBens;

  String host = "10.97.150.102:5009";
  final TextEditingController _controller = TextEditingController();
  String textoDaPesquisa = "";

  SingingCharacter? _character = SingingCharacter.setor;

  void _printLatestValue() {
    // String opcao = "setor";
    // switch (_character) {
    //   case SingingCharacter.setor:
    //     opcao = "setor";
    //     break;
    //   case SingingCharacter.tombo:
    //     opcao = "tombo";
    //     break;
    //   case SingingCharacter.descricao:
    //     opcao = "descricao";
    //     break;
    //   default:
    //     opcao = "setor";
    // }
    setState(() {
      // textoDaPesquisa = opcao + " = " + _controller.text;
      _carregarBens = _refreshBens();
    });
  }

  @override
  void dispose() {
    // Limpar controlador da árvore
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
        MyAlert.confirm(
            title: TranslateApp(context).text("alert_attention"),
            text: TranslateApp(context).text("msg_confirm_exit_app"),
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
            title: Text("Dashboard"),
          ),
          // drawer: MyDrawer(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal),
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
                    Text(textoDaPesquisa),
                    Container(
                      child: FutureBuilder(
                        future: _carregarBens,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List situations = snapshot.data;

                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: situations.length,
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                itemBuilder: (context, index) {
                                  int tamanhoTextoDescricao = 30;
                                  String tombo = situations[index]["tombo"];//;
                                  String descricao = situations[index]["descricao"];//;
                                  if (descricao.length >= tamanhoTextoDescricao)
                                    descricao = descricao.substring(0,tamanhoTextoDescricao);
                                  return Card(
                                    shadowColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    surfaceTintColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    elevation: 0,
                                    child: DefaultTextStyle(
                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.normal),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(tombo),
                                            SizedBox(width: 5,),
                                            Expanded(child: Text(descricao))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  // return cardEmprestimo(context, _emprestimos[index], _atualizarListaEmprestimos);
                                });
                          } else {
                            return Text(
                              "",
                              style: TextStyle(color: Colors.red),
                            );
                            // Center(
                            //   child: CircularProgressIndicator(),
                            // );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                print('--------------------------------------');
                print('Abrir tela de versão premium');
                print('--------------------------------------');
              })),
    );
  }

  // returns loans from the current period
  Future<List> _refreshBens() async {

    if (_controller.text.isEmpty){
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
    print(response);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print(response.body);
      return convert.jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  // returns loans from the current period
  Future<List> _refreshBens1() async {
    var endPoint = '/api/bem/setor/dti';
    var url = Uri.http(host, endPoint, {'q': ''});

    print("try url " + host + endPoint);
    var response = await http.get(url);
    print(response);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print(response.body);
      return convert.jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }

    // return list;
  }
}
