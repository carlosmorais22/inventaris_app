import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Situacao extends StatefulWidget {
  const Situacao({super.key, required this.title});

  final String title;

  @override
  State<Situacao> createState() => _SituacaoState();
}

class _SituacaoState extends State<Situacao> {

  int _counter = 0;
  // String host = "127.0.0.2:5001";
  String host = "10.97.150.102:5009";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  initState() {
    print("initState situacao");
    _atualizarSituacaoSenhas();
    super.initState();
    // _executar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // _exibirSenhasChamadas(){
  //   String lista = "";
  //   for (var senha in senhasChamadas) {
  //     lista += senha.tipo_senha.abreviacao;
  //   }
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       for(var element in senhasChamadas.reversed) ...[
  //         Padding(
  //           padding: const EdgeInsets.only(left: 40.0, right: 40.0),
  //           child: Column(
  //               children: [
  //                 Text(
  //                     element.guiche.nome,
  //                     style: const TextStyle(height: 2, fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)
  //                 ),
  //                 Text(
  //                     element.tipo_senha.abreviacao+element.senha.toString(),
  //                     style: const TextStyle(height: 1, fontSize: 100, fontWeight: FontWeight.w900, color: Colors.white)
  //                 ),
  //               ]
  //           ),
  //         ),
  //       ],
  //     ],
  //   );
  // }

  Future<void> _atualizarSituacaoSenhas() async {

    var endPoint = '/api/situation';
    var url = Uri.http(host, endPoint, {'q': ''});

    print("try get url " + host + endPoint);
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print(response.body);
      var item = convert.jsonDecode(response.body) as List<dynamic>;
      print(item);
    }
    else {
      print('Request failed with status: ${response.statusCode}.');
      // throw Exception('Erro ao tentar acessar servidor externo');
    }
  }
}
