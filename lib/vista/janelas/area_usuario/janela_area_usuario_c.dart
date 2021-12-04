import 'dart:async';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:loja_apps/dominio/modelos/area_usuario.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps/provedores/provedor_area_usuario.dart';
import 'package:loja_apps/vista/contratos/manipulacao_area_usuario_i.dart';
import 'package:loja_apps/dominio/casos_uso/manipulacao_area_usuario.dart';
import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';
import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';

class JanelaAreaUsuarioC extends GetxController {
  Rx<AreaUsuario?> _areaUsuario = Rx<AreaUsuario?>(null);

  late Usuario usuario;

  late ManipulacaoAreaUsuarioI _manipulacaoAreaUsuarioI;

  JanelaAreaUsuarioC();

  @override
  void onInit() async {
    inicializarDependencias();
    super.onInit();
  }

  void inicializarDependencias() {
    _manipulacaoAreaUsuarioI =
        ManipulacaoAreaUsuario(ProvedorAreaUsuario(usuario.rotaPrincipal!));
  }

  Future<void> orientarDescargaDadosUsuario() async {
    await _manipulacaoAreaUsuarioI.pegarDadosDaAreaUsuario(
        accaoNaFinalizacao: (resposta) async {
      if ((resposta is Erro)) {
        mostrarDialogoDeInformacao(resposta.mensagem);
      } else {
        mudarValorObservavel(resposta);
      }
    });
  }

  void mudarValorObservavel(AreaUsuario? dados) {
    _areaUsuario.value = dados;
  }

  Future<void> adicionarNovaRotaServidorArquivo(String rota) async {
    if (_areaUsuario.value != null) {
      AreaUsuario? areaUsuario;
      try {
        areaUsuario =
            await _manipulacaoAreaUsuarioI.adicionarNovaRotaServidorArquivo(
          rota,
          _areaUsuario.value!,
        );
        await _manipulacaoAreaUsuarioI.actualizarAreaUsuario(areaUsuario,
            accaoNaFinalizacao: (resposta) {});
      } catch (e) {
        mostrarDialogoDeInformacao((e as Erro).mensagem);
      }
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
