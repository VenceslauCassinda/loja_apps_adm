import 'package:flutter/material.dart';

class LayoutInformacao extends StatelessWidget {
  String informacao;
  Function? accaoNaNovaTentativa;

  LayoutInformacao(this.informacao, [this.accaoNaNovaTentativa]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(informacao),
          ),
          Visibility(
            visible: accaoNaNovaTentativa != null,
            child: MaterialButton(
              onPressed: () => accaoNaNovaTentativa!(),
              child: Text("Tentar Novamente"),
            ),
          )
        ],
      ),
    );
  }
}
