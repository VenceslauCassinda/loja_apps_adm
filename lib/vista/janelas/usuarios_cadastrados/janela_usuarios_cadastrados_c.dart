import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/dominio/casos_uso/autenticacao_usuario.dart';
import 'package:loja_apps_adm/dominio/modelos/usuario.dart';
import 'package:loja_apps_adm/provedores/provedor_usuarios.dart';
import 'package:loja_apps_adm/vista/contratos/autenticacao_usuario_i.dart';
import 'package:loja_apps_adm/vista/dialogos/dialogos.dart';
import 'package:oku_sanga_mediador_funcional/oku_sanga_mediador_funcional.dart';

class JanelaUsuariosCadastradosC extends GetxController {
  Rx<List<Usuario>?> lista = Rx<List<Usuario>?>(null);
  late AutenticacaoUsuarioI _autenticacaoUsuarioI;

  JanelaUsuariosCadastradosC() {}

  @override
  void onInit() async {
    super.onInit();
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
}
