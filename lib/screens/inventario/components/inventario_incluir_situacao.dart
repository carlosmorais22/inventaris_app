import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:inventaris/entities/setor.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
import 'package:inventaris/utils/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  String initSetorName = "";

  late Future<List> _carregarSetores;
  List<String> _listaSituacoes = [kSetorOrigem, kOutroSetor];

  @override
  void initState() {
    // Globals().inventario.situacao = 1;
    _carregarSetores = _refreshSetores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> suggestions = [];
    List<Setor> setores = [];

    _carregarSetores.then((list) {
      for (Map<String, dynamic> map in list) {
        Setor setor = Setor.fromMap(map);
        Globals().inventario!.situacao_observacao ??= setor.sigla;
        setores.add(setor);
        suggestions.add(setor.sigla);
      }
    });

    double _sizeWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BuildDadosBem(),
          StepTitle(title: kTelaSituacaoLocalizado),
          Center(
            child: ToggleSwitch(
              initialLabelIndex: Globals().inventario.situacao - 1,
              totalSwitches: 2,
              customWidths: [_sizeWidth * .4, _sizeWidth * .4],
              inactiveBgColor: Theme.of(context).colorScheme.onSurfaceVariant,
              activeBgColor: [Theme.of(context).colorScheme.primary],
              labels: _listaSituacoes,
              customTextStyles: [Theme.of(context).textTheme.titleMedium!],
              onToggle: (index) {
                setState(() {
                  Globals().inventario.situacao = index! + 1;
                  Globals().inventario_situacao = _listaSituacoes[index];
                  if (index! == 0) {
                    Globals().inventario.situacao_observacao = "";
                  }
                });
                widget.refreshStatusSteps();
              },
            ),
          ),
          Globals().inventario.situacao == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StepTitle(title: kTelaSituacaoQualSetor),
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium));
                        },
                        onChanged: (value) => print('onChanged value: $value'),
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
    );
  }

  // retorna bens para o tipo e texto do filtro
  Future<List> _refreshSetores() async {
    var endPoint = '/api/setor';
    return AppHttp.list(endPoint);
  }
}
