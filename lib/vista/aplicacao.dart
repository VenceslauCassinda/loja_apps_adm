import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'aplicacao_c.dart';
import 'janelas/usuarios_aderindo/janela_usuarios_aderindo.dart';

class Aplicacao extends StatelessWidget {
  late AplicacaoC _controlador;

  Aplicacao() {
    _controlador = Get.put(AplicacaoC());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          accentColor: Colors.pink,
          colorScheme:
              ThemeData().colorScheme.copyWith(secondary: Colors.pink)),
      debugShowCheckedModeBanner: false,
      home: JanelaUsuariosAderindo(),
    );
  }
}
