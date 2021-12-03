import 'package:flutter/material.dart';
import 'package:loja_apps/vista/janelas/mercado/janela_app/janela_app.dart';
import 'package:loja_apps_adm/vista/janelas/area_usuario/janela_area_usuario_c.dart';
import 'package:get/get.dart';

class JanelaAreaUsuario extends StatelessWidget {
  late JanelaAreaUsuarioC _c;

  JanelaAreaUsuario() {
    _c = Get.put(JanelaAreaUsuarioC());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImagemNet(link: "link"),
        Row(
          children: [
            
          ],
        )
      ],
    );
  }
}
