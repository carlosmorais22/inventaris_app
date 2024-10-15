import 'dart:io';

import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/screens/common_widgets/step_title.dart';
import 'package:inventaris/utils/app_alert.dart';
import 'package:inventaris/utils/constants.dart';

enum SingingCharacter { setor, tombo, descricao }


class DesabilitadoTab extends StatefulWidget {
  final Map<String, dynamic> dadosDispositivo;
  final String titulo;
  final String mensagem;

  const DesabilitadoTab({super.key, required this.dadosDispositivo, required this.titulo, required this.mensagem});

  @override
  State<DesabilitadoTab> createState() => _DesabilitadoTabState();
}

class _DesabilitadoTabState extends State<DesabilitadoTab> {
  @override
  void initState() {
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
                title: widget.titulo,
                subTitle:
                    widget.mensagem,
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
}
