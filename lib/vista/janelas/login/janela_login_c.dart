import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/dominio/casos_uso/autenticacao_usuario.dart';
import 'package:loja_apps_adm/provedores/provedor_usuarios.dart';
import 'package:loja_apps_adm/vista/contratos/autenticacao_usuario_i.dart';
import 'package:loja_apps_adm/vista/janelas/cadastro/janela_cadastro.dart';

class JanelaLoginC extends GetxController {
  bool repositorioWebPreparado = false;
  late AutenticacaoUsuarioI _autenticacaoUsuarioI;

  JanelaLoginC();

  @override
  void onInit() async {
    ProvedorUsuarios provedorUsuarios = Get.find();
    _autenticacaoUsuarioI = AutenticacaoUsuario(provedorUsuarios);
    super.onInit();
  }

  mostrarDialogo(BuildContext context) {
    Get.dialog(Container(
      width: MediaQuery.of(context).size.width * .7,
      height: 200,
      child: CircularProgressIndicator(),
    ));
  }

  mostrarImagem(BuildContext context, File arquivo) {
    Get.dialog(Container(
      width: MediaQuery.of(context).size.width * .7,
      child: Image.file(arquivo),
    ));
  }

  Future<void> pegarListaUsuario() async {}

  void irParaJanelaCadastro() {
    Get.to(()=>JanelaCadastro());
  }
}
