import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutCarregandoCircrular extends StatelessWidget{

  String informacao;

  LayoutCarregandoCircrular(this.informacao);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(informacao),
          )
        ],
      ),
    );
  }

}