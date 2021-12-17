import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:loja_apps/vista/janelas/cadastro/janela_cadastro.dart';
import 'package:loja_apps/dominio/casos_uso/autenticacao_usuario.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps/provedores/provedor_usuarios.dart';
import 'package:loja_apps/vista/contratos/autenticacao_usuario_i.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_cadastrados/janela_usuarios_cadastrados.dart';

class JanelaUsuariosAderindoC extends GetxController {
  Rx<List<Usuario>?> lista = Rx<List<Usuario>?>(null);
  late AutenticacaoUsuarioI _autenticacaoUsuarioI;

  JanelaUsuariosAderindoC() {}

  @override
  void onInit() async {
    super.onInit();
    ProvedorUsuarios provedorUsuarios = Get.find();
    _autenticacaoUsuarioI = AutenticacaoUsuario(provedorUsuarios);
  }

  void mudarValorLista(List<Usuario>? dados) {
    lista.value = dados;
  }

  Future<void> encomendarDescargaUsuariosAderindo() async {
    mudarValorLista(null);
    await _autenticacaoUsuarioI.pegarListaUsuariosAderindo();
  }

  Future<void> encomendarAutorizacaoCadastroUsuario(Usuario usuario) async {
    await _autenticacaoUsuarioI.autorizarCadastroUsuario(usuario);
  }

  void irParaJanelaUsuariosCadastrados() {
    Get.to(() => JanelaUsuariosCadastrados());
  }

  void irParaJanelaCadastro() {
    Get.to(() => JanelaCadastro());
  }

  gerarDialogoParaRemocaoUsuario(Usuario usuario) {
    fecharDialogoCasoAberto();
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutConfirmacaoAccao(
          "Deseja cadastrar este usuario?",
          accaoAoCancelar: () {
            fecharDialogoCasoAberto();
          },
          accaoAoConfirmar: () async {
            mostrarCarregandoDialogoDeInformacao("Cadastrando usuário!");
            // await encomendarRemocaoUsuarioAderindo(usuario);
            await encomendarAutorizacaoCadastroUsuario(usuario);
          },
        ));
  }

  Future<void> encomendarRemocaoUsuarioAderindo(Usuario usuario) async {
    lista.value!.removeWhere((element) => element.email == usuario.email);
    actualizarEstado();
    await _autenticacaoUsuarioI.removerUsuarioAderindo(usuario);
  }

  void actualizarEstado() {
    var novaLista = <Usuario>[];
    novaLista.addAll(lista.value!);
    mudarValorLista(novaLista);
  }
}
