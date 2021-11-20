import 'package:flutter/material.dart';
import 'package:loja_apps_adm/dominio/modelos/app.dart';

class ItemApp extends StatelessWidget {
  final App app;
  final Function? accaoAoClicarItem;

  const ItemApp(this.app, {this.accaoAoClicarItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (accaoAoClicarItem != null) {
          accaoAoClicarItem!();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ContentorImageApp(app: app),
          SizedBox(
            height: 10,
          ),
          Text(
            app.nome,
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "${app.tamanho}MB",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class ContentorImageApp extends StatelessWidget {
  const ContentorImageApp({
    Key? key,
    required this.app,
  }) : super(key: key);

  final App app;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3))
          ]),
      child: ImagemNetApp(app: app),
      width: (MediaQuery.of(context).size.width - 80) / 3,
      height: (MediaQuery.of(context).size.width - 80) / 3,
    );
  }
}

class ImagemNetApp extends StatelessWidget {
  const ImagemNetApp({
    Key? key,
    required this.app,
  }) : super(key: key);

  final App app;

  @override
  Widget build(BuildContext context) {
    if (app.imagem.isEmpty) {
      return Center(child: Text("Sem Imagem"));
    }
    var imagem = Image.network(
      app.imagem,
      fit: BoxFit.fill,
      loadingBuilder: (x, y, z) {
        if (z != null) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          );
        }
        return y;
      },
    );

    return ClipRRect(
      child: imagem,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
