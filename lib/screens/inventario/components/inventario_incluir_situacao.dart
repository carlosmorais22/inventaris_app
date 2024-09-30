import 'dart:convert' as convert;

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventaris/entities/setor.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/shared/globals.dart';

enum SingingCharacter { sim, nao, outro }

class InventarisIncluirSituacao extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirSituacao(
      {super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirSituacao> createState() {
    return _InventarisIncluirSituacaoState();
  }
}

class _InventarisIncluirSituacaoState extends State<InventarisIncluirSituacao> {
  String host = "192.168.1.3:5009";
  SingingCharacter? _character = SingingCharacter.sim;
  String initSetorName = "";

  late Future<List> _carregarBens;

  _refreshValue() {
    int value = 0;
    switch (_character) {
      case SingingCharacter.sim:
        value = 1;
        break;
      case SingingCharacter.nao:
        value = 2;
        break;
      case SingingCharacter.outro:
        value = 3;
        break;
      default:
        break;
    }
    if (value > 0) {
      setState(() {
        Globals().inventario.situacao = value;
        widget.refreshStatusSteps();
      });
    }
  }

  @override
  void initState() {
    _carregarBens = _refreshSetores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> suggestions = [];
    List<Setor> setores = [];

    _carregarBens.then((list) {
      for (Map<String, dynamic> map in list) {
        Setor setor = Setor.fromMap(map);
        Globals().inventario!.situacao_observacao ??= setor.sigla;
        setores.add(setor);
        suggestions.add(setor.sigla);
      }
    });

    return Container(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.normal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StepTitle(
                title: "O bem foi localizado?" +
                    Globals().inventario.situacao.toString()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Radio<SingingCharacter>(
                        value: SingingCharacter.sim,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                            _refreshValue();
                          });
                        }),
                    const Text('Sim'),
                    Radio<SingingCharacter>(
                        value: SingingCharacter.outro,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                            _refreshValue();
                          });
                        }),
                    const Text('Sim, Mas em outro setor'),
                    Radio<SingingCharacter>(
                        value: SingingCharacter.nao,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          _character = value;
                          _refreshValue();
                        }),
                    const Text('Não'),
                  ],
                ),
              ],
            ),
            Globals().inventario.situacao == 3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StepTitle(title: "Em qual setor o bem foi localizado?"),
                      EasyAutocomplete(
                          initialValue: initSetorName,
                          suggestions: suggestions,
                          inputTextStyle:
                              Theme.of(context).textTheme.titleMedium!,
                          suggestionBuilder: (data) {
                            return Container(
                                margin: EdgeInsets.all(1),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
                                child: Text(data,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium));
                          },
                          onChanged: (value) =>
                              print('onChanged value: $value'),
                          onSubmitted: (value) {
                            setState(() {
                              Globals().inventario.situacao_observacao = value;
                            });
                            print(Globals().inventario.situacao_observacao);
                            widget.refreshStatusSteps();
                          }),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  // retorna bens para o tipo e texto do filtro
  Future<List> _refreshSetores() async {
    var endPoint = '/api/setor';
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
}
