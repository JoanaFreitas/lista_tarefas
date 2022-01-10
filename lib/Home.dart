import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  Map<String, dynamic> _ultimoTarefaRemovida = Map();

  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = textoDigitado;
    tarefa['realizada'] = false;
    setState(
      () => _listaTarefas.add(tarefa),
    );

    _salvarArquivo();
    _controllerTarefa.text = '';
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
    // print('caminho' + diretorio.path);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return 'Algo deu errado'; //null
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = jsonDecode(dados);
      });
    });
  }

//
  Widget criarItemLista(context, index) {
    return Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          //recuperaultimo excluido
          _ultimoTarefaRemovida = _listaTarefas[index];
          //remove item da lista
          _listaTarefas.removeAt(index);
           _salvarArquivo();

          //snackbar
          final snackbar = SnackBar(
            backgroundColor: Theme.of(context).backgroundColor,
            duration: Duration(seconds: 5),
            content: Text('Tarefa removida!!'),
            action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () {
                //insere novamente item removido
                setState(()=> _listaTarefas.insert(index, _ultimoTarefaRemovida));
                                   _salvarArquivo();
                }),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        },
        background: Container(
          color: Theme.of(context).errorColor,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          ),
        ),
        child: CheckboxListTile(
            title: Text(_listaTarefas[index]['titulo']),
            value: _listaTarefas[index]['realizada'],
            onChanged: (valorAlterado) {
              setState(() => _listaTarefas[index]['realizada'] = valorAlterado);
              _salvarArquivo();
            }));
  }

  //

  @override
  Widget build(BuildContext context) {
    //_salvarArquivo();
    //print('item: ' + DateTime.now().microsecondsSinceEpoch.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Adicionar tarefa'),
                    content: TextField(
                      controller: _controllerTarefa,
                      decoration:
                          InputDecoration(labelText: 'Digite sua tarefa'),
                      onChanged: (text) {},
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar')),
                      TextButton(
                          onPressed: () {
                            //salvar
                            _salvarTarefa();
                            Navigator.pop(context);
                          },
                          child: Text('Salvar'))
                    ],
                  );
                });
          }),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: criarItemLista,
              /* return ListTile(
                      title: Text(_listaTarefas[index]['titulo']),
                    );*/
            ),
          ),
        ],
      ),
    );
  }
} //aula112
