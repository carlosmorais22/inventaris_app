import 'package:flutter/material.dart';
import 'package:inventaris/entities/inventario.dart';
import 'package:inventaris/entities/setor.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/screens/inventario/components/build_dados_bem.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/app_http.dart' as AppHttp;
import 'package:inventaris/utils/constants.dart';

class InventarisIncluirResumo extends StatefulWidget {
  final VoidCallback refreshStatusSteps;

  const InventarisIncluirResumo({super.key, required this.refreshStatusSteps});

  @override
  State<InventarisIncluirResumo> createState() {
    return _InventarisIncluirResumoState();
  }
}

class _InventarisIncluirResumoState extends State<InventarisIncluirResumo> {
  int initSituacaoValue = 0;
  String initSetorName = "";

  late Future<List> _carregarBens;

  List<double> larguraDasColunas = [0.3, 0.7];

  @override
  void initState() {
    _carregarBens = AppHttp.list('/api/setor');
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

    Inventario inventario = Globals().inventario;
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BuildDadosBem(),
            StepTitle(title: "O inventário deste bem está correto?"),
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  _buildPadding(
                      context: context,
                      label: kSituacao,
                      conteudo: Globals().inventario_situacao,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary),
                  inventario.situacao == 2
                      ? _buildPadding(
                          context: context,
                          label: kSituacaoDescricao,
                          conteudo: inventario.situacao_observacao!)
                      : SizedBox(),
                  _buildPadding(
                      context: context,
                      label: kTemNumeroSerie,
                      conteudo: inventario.tem_numero_serie != null &&
                              Globals().inventario_tem_numero_serie != null
                          ? Globals().inventario_tem_numero_serie
                          : kNaoInformado,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary),
                  _buildPadding(
                      context: context,
                      label: kNumeroSerie,
                      conteudo: inventario.tem_numero_serie != null &&
                              inventario.numero_serie != null
                          ? inventario.numero_serie!
                          : "- - -"),
                  _buildPadding(
                      context: context,
                      label: kPlaqueta,
                      conteudo: inventario.plaqueta == true ? kSim : kNao,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary),
                  _buildPadding(
                      context: context,
                      label: "Estado",
                      conteudo: Globals().inventario_estado),
                  _buildPadding(
                      context: context,
                      label: "Observação",
                      conteudo: inventario.observacao!,
                      textArea: true,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPadding(
      {required BuildContext context,
      required String label,
      required String conteudo,
      bool textArea = false,
      Color backgroundColor = Colors.white}) {
    return Container(
      padding: EdgeInsets.only(top: 4.0),
      color: backgroundColor,
      child: !textArea
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("$label:",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              Text(conteudo, style: Theme.of(context).textTheme.bodyLarge!),
            ])
          : Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$label:",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  Text(conteudo, style: Theme.of(context).textTheme.bodyLarge!),
                ],
              ),
            ),
    );
  }
}
