import 'dart:async';

import 'package:flutter/material.dart';
import 'package:list_animation/listagem/listagem_card.dart';

class ListagemScreen extends StatefulWidget {
  @override
  _ListagemScreenState createState() => _ListagemScreenState();
}

class _ListagemScreenState extends State<ListagemScreen> {
  var listaController = StreamController<List<int>>();
  var lista = List.generate(50, (index) => index);

  @override
  void initState() {
    super.initState();
    listaController.add(List.generate(50, (index) => index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Animation")),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return ListagemCard(
            key: UniqueKey(),
            content: "${lista[index]}",
            onRemove: () {
              lista.removeAt(index);
              listaController.add(lista);
            },
          );
        },
      ),
    );
  }
}
