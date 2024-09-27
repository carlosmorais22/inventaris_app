import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SituationScreen extends StatefulWidget {
  const SituationScreen({super.key, required this.title});

  final String title;

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {

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
    print("initState SituationScreen");
    _atualizarSituationScreenSenhas();
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

  Future<void> _atualizarSituationScreenSenhas() async {

    var endPoint = '/api/situation';
    var url = Uri.http(host, endPoint, {'q': ''});

    print("try get url " + host + endPoint);
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print(response.body);
      var item = convert.jsonDecode(response.body) as List<dynamic>;
      print(item);
      // TipoSenha tipoSenha = TipoSenha(item['tipo_senha']['id'], item['tipo_senha']['abreviacao'], item['tipo_senha']['descricao'], item['tipo_senha']['ordem'], item['tipo_senha']['status']);
      // Guiche guiche = Guiche(id: item['guiche']['id'], ip: item['guiche']['ip'], nome: item['guiche']['nome'], status: item['guiche']['status']);
      // setState(() {
      //
      //   List<String> countries = ["Nepal", "India", "Pakistan", "USA", "Canada", "China"];
      //   if(countries.contains("Nepal")){
      //     print("SIM");
      //   }else{
      //     print("NÃO");
      //   }
      //
      //   atendimento = Atendimento(item['id'], item['senha'], tipoSenha, item['atendente'], guiche as Guiche?, item['data_cadastro'],  item['status']);
      //   bool existe = false;
      //   for (var temp in senhasChamadas){
      //     if(temp.id == atendimento!.id){
      //       existe = true;
      //     }
      //   }
      //
      //   if(!existe){
      //     senhasChamadas.add(atendimento);
      //     print("SIM");
      //   }
      //   if (senhasChamadas.length > 6){
      //     senhasChamadas.remove(senhasChamadas.first);
      //   }
      //   exibirSenha = true;
      // });
    }
    else {
      print('Request failed with status: ${response.statusCode}.');
      // throw Exception('Erro ao tentar acessar servidor externo');
    }
  }
}
