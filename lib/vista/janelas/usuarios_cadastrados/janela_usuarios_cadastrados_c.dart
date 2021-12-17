import 'dart:math';

import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:loja_apps/dominio/modelos/erros/erro_existencia_rota.dart';
import 'package:loja_apps/vista/dialogos/dialogos.dart';
import 'package:loja_apps/vista/janelas/area_usuario/janela_painel_usuario_c.dart';
import 'package:loja_apps/dominio/casos_uso/autenticacao_usuario.dart';
import 'package:loja_apps/vista/contratos/manipulacao_usuario_i.dart';
import 'package:loja_apps/dominio/casos_uso/manipular_usuario.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps/provedores/provedor_usuarios.dart';
import 'package:loja_apps/vista/contratos/autenticacao_usuario_i.dart';
import 'package:componentes_visuais/componentes/nova_texto.dart';

class JanelaUsuariosCadastradosC extends GetxController {
  Rx<List<Usuario>?> lista = Rx<List<Usuario>?>(null);
  late AutenticacaoUsuarioI _autenticacaoUsuarioI;
  late ManipularUsuarioI _manipularUsuario;

  @override
  void onInit() async {
    super.onInit();
    inicializarDependencia();
  }

  void inicializarDependencia() {
    _manipularUsuario = ManipularUsuario();
    ProvedorUsuarios provedorUsuarios = Get.find();
    _autenticacaoUsuarioI = AutenticacaoUsuario(provedorUsuarios);
  }

  void mudarValorLista(List<Usuario>? dados) {
    lista.value = dados;
  }

  Future<void> encomendarDescargaUsuariosCadastrados() async {
    mudarValorLista(null);
    await _autenticacaoUsuarioI.pegarListaUsuariosCadastrados();
  }

  Future<void> encomendarRemocaoUsuarioCadastrado(Usuario usuario) async {
    lista.value!.removeWhere((element) => element.email == usuario.email);
    actualizarEstado();
    await _autenticacaoUsuarioI.removerUsuarioCadastrado(usuario);
  }

  void actualizarEstado() {
    var novaLista = <Usuario>[];
    novaLista.addAll(lista.value!);
    mudarValorLista(novaLista);
  }

  void irParaJanelaLogin() async {}

  gerarDialogoParaRemocaoUsuario(Usuario usuario) {
    fecharDialogoCasoAberto();
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutConfirmacaoAccao(
          "Deseja remover este usuario?",
          accaoAoCancelar: () {
            fecharDialogoCasoAberto();
          },
          accaoAoConfirmar: () async {
            await encomendarRemocaoUsuarioCadastrado(usuario);
            fecharDialogoCasoAberto();
          },
        ));
  }

  gerarDialogoParaAdicionarRota(Usuario usuario) {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutNovoTexto(
          this,
          label: "Área do usuário",
          accaoAoFinalizar: (String rota) async {
            await adicionarRota(rota, usuario);
          },
        ));
  }

  gerarDialogoParaMudarEstadoUsuario(Usuario usuario) {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutNovoTexto(
          this,
          textoPadrao: usuario.estado == null ? null : "${usuario.estado}",
          tipoCampoTexto: TipoCampoTexto.numero,
          label: "Estado do Usuário",
          accaoAoFinalizar: (String valor) async {
            int estado = -1;
            try {
              estado = int.parse(valor);
              await adicionarEstado(estado, usuario);
            } catch (e) {
              mostrarToast("Estado inválido!");
            }
          },
        ));
  }

  gerarDialogoParaAdicionarServidorArquivoDisponivel(Usuario usuario) {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutNovoTexto(
          this,
          label: "Rota do Servidor",
          accaoAoFinalizar: (String rota) async {
            await adicionarNovaRotaServidorDisponivel(rota, usuario);
          },
        ));
  }

  Future<void> adicionarRota(String rota, Usuario usuario) async {
    if (usuario.rotaPrincipal == null) {
      usuario =
          _manipularUsuario.adicionarRotaPincipalParaUsuario(rota, usuario);
      await _autenticacaoUsuarioI
          .actualizarrUsuarioCadastrado(usuario.toJson());
    } else {
      mostrarDialogoDeInformacao(
          "O Usuário já possui uma rota Principal", true);
    }
  }

  Future<void> adicionarEstado(int estado, Usuario usuario) async {
    Usuario novo = _manipularUsuario.adicionarEstadoUsuario(estado, usuario);
    await _autenticacaoUsuarioI.actualizarrUsuarioCadastrado(novo.toJson());
  }

  Future<void> adicionarNovaRotaServidorDisponivel(
      String rota, Usuario usuario) async {
    JanelaPainelUsuarioC c;
    try {
      c = Get.find();
      c.usuario = usuario;
    } catch (e) {
      c = JanelaPainelUsuarioC(usuario);
      Get.put(c);
    }

    try {
      await c.adicionarNovaRotaServidorArquivo(rota);
    } catch (e) {
      if ((e is ErroExistenciaRota)) {
        mostrarDialogoDeInformacao(e.mensagem);
      }
    }
  }
}
