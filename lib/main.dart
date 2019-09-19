import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  //Cria uma lista de Itens
  var items = new List<Item>();

  //Adiciona os Itens na HomePage com o construtor chamando o item da Lista List
  HomePage() {
    items = [];
    // items.add(Item(title: "Banana", done: false));
    // items.add(Item(title: "Abacate", done: true));
    // items.add(Item(title: "Laranja", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //controlador de texto de um textField, limpar texto, ler texto, setar um texto, etc...
  var newTaskCtrl = TextEditingController();

  //Cria um item novo com esse método chamando a newTaskCtrl.text
  void add() {
    if (newTaskCtrl.text.isEmpty)
      return; //valida para se clicar no botão + ele não faz nada, não retorna nada
    setState(() {
      widget.items.add(
        Item(title: newTaskCtrl.text, done: false),
      );
      newTaskCtrl.text = "";
      save(); // salva sempre que adiciona um item
    });
  }

  //Remove o item usando o Dismiss
  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save(); //sempre que remover salva
    });
  }

  //Função Assíncrona, toda vez que se usa uma biblioteca para acesso a dados nunca será em tempo real
  //Sempre retorna uma promessa ! (promisses por exemplo, ou wait)
  // Para retornar um await precisa ser um método async (assíncrono)
  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    //Ler as informações dele -- sempre chave x valor
    var data = prefs.getString('data');

    //Se tiver alguma informação execute o comando
    //Iterable é uma coluna onde pode existir iterações -- loop - e é uma lista genérica.
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      // o map percorre todos os itens e o toList converte o item para uma lista usando o fromJson
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  //Método Save, transformando o widget.items em uma lista de string
  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  //Chama o construtor da HomePageState pra chamar o load();
  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Dentro do AppBar colocamos o TextformField que é um textbox na tela
          title: TextFormField(
            controller: newTaskCtrl,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            //Com o decoration colocamos o Título na AppBar com os estilos
            decoration: InputDecoration(
              labelText: 'Nova Tarefa',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        //ListView.builder controla os itens que aparecem e desaparecem na tela usando ItemCount e itemBuilder
        body: ListView.builder(
          itemCount: widget
              .items.length, //o builder constrói baseado no tamanho dos itens
          //index é o índice que ele percorre dentro do Array para mostrar o title na tela
          itemBuilder: (BuildContext ctxt, int index) {
            final item = widget.items[index];
            //Remove os itens da tela arrastando para o lado, porém não os remove completamente
            return Dismissible(
              child: CheckboxListTile(
                //Cria um checkbox para a lista colocada na tela
                title: Text(item.title),
                value: item.done, //valor só pode ser true or false pq é boolean
                //O setState permite a alteração dentro do build que é estático, e só é usado no Stateful
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                }, //ao mudar *clicar, ele recebe o valor
              ),
              key: Key(item.title), //Chave única ficando fora do Checkbox
              background: Container(
                color: Colors.red.withOpacity(0.2),
              ),
              onDismissed: (direction) {
                print(direction);
                //remove(index);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ));
  }
}
