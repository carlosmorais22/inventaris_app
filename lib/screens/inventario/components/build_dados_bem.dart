import 'package:flutter/material.dart';
import 'package:inventaris/shared/globals.dart';
import 'package:inventaris/utils/constants.dart';

class BuildDadosBem extends StatelessWidget {
  const BuildDadosBem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // StepTitle(title: "Dados do bem"),
        SizedBox(height: 5),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Table(columnWidths: {
            0: FixedColumnWidth((MediaQuery.of(context).size.width - 40) * 0.25),
            1: FixedColumnWidth((MediaQuery.of(context).size.width - 40) * 0.75),
          }, children: [
            TableRow(
              children: [
                Text(kBemTombo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(Globals().bem.tombo),
              ], // Pass the widgets to be set as the row content.
            ),
            TableRow(
              children: [
                Text(kBemDescricao,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Wrap(children: [Text(Globals().bem.descricao)]),
              ], // Pass the widgets to be set as the row content.
            ),
            TableRow(
              children: [
                Text(kBemSetor,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(Globals().bem.setor),
              ], // Pass the widgets to be set as the row content.
            ),
            TableRow(
              children: [
                Text(kBemEstado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(Globals().bem.estado_descricao!),
              ], // Pass the widgets to be set as the row content.
            )
          ]),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
