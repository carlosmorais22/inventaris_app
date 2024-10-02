import 'package:flutter/material.dart';
import 'package:inventaris/shared/globals.dart';

class BuildDadosBem extends StatelessWidget {
  const BuildDadosBem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          // StepTitle(title: "Dados do bem"),
          Table(columnWidths: {
            0: FixedColumnWidth((MediaQuery.of(context).size.width - 40) * 0.2),
            1: FixedColumnWidth((MediaQuery.of(context).size.width - 40) * 0.8),
          }, children: [
            TableRow(
              children: [
                Text("Tombo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(Globals().bem.tombo),
              ], // Pass the widgets to be set as the row content.
            ),
            TableRow(
              children: [
                Text("Descrição",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Wrap(children: [Text(Globals().bem.descricao)]),
              ], // Pass the widgets to be set as the row content.
            ),
            TableRow(
              children: [
                Text("Setor",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(Globals().bem.setor),
              ], // Pass the widgets to be set as the row content.
            ),
            TableRow(
              children: [
                Text("Estado",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(Globals().bem.estado_descricao!),
              ], // Pass the widgets to be set as the row content.
            )
          ]),
        ],
      ),
    );
  }
}
