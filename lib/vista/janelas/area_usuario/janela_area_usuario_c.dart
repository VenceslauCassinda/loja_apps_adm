import 'dart:async';

import 'package:get/get.dart';
import 'package:loja_apps/dominio/modelos/area_usuario.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps/provedores/provedor_area_usuario.dart';
import 'package:loja_apps/vista/contratos/manipulacao_area_usuario_i.dart';
import 'package:loja_apps/dominio/casos_uso/manipulacao_area_usuario.dart';
import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';

class JanelaAreaUsuarioC extends GetxController {
  Rx<AreaUsuario?> _areaUsuario = Rx<AreaUsuario?>(null);

  late Usuario _usuario;

  late ManipulacaoAreaUsuarioI _manipulacaoAreaUsuarioI;
  String? rota;

  JanelaAreaUsuarioC({this.rota});

  @override
  void onInit() async {
    inicializarDependencias();
    super.onInit();
  }

  void inicializarDependencias() {
    _usuario = Get.find();
    _manipulacaoAreaUsuarioI = ManipulacaoAreaUsuario(
        ProvedorAreaUsuario(rota ?? _usuario.rotaPrincipal!));
  }

  Future<void> orientarDescargaDadosUsuario() async {
    await _manipulacaoAreaUsuarioI.pegarDadosDaAreaUsuario(
        accaoNaFinalizacao: (resposta) async {
      if (!(resposta is Erro)) {
        mudarValorObservavel(resposta);
      } else {}
    });
  }

  void mudarValorObservavel(AreaUsuario? dados) {
    _areaUsuario.value = dados;
  }

  Future<void> adicionarNovaRotaServidorArquivo(String rota) async {
    if (_areaUsuario.value != null) {
      _manipulacaoAreaUsuarioI.adicionarNovaRotaServidorArquivo(
          rota, _areaUsuario.value!);
    } else {
      await orientarDescargaDadosUsuario();
      executarAccaoAoTerminarDescargaDadosUsuario(() async {
        await adicionarNovaRotaServidorArquivo(rota);
      });
    }
  }

  void executarAccaoAoTerminarDescargaDadosUsuario(Function accao) {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_areaUsuario.value != null) {
        accao();
        timer.cancel();
      }
    });
  }
}
