import 'dart:core' as prefix0;

import 'dart:core';

class Item {
  String title;
  bool done;

//Construtor sem parametro
  Item({this.title, this.done});

  //conversões -- recebe um objeto no formato string com o Map
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  //Retornar o Map String
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}
