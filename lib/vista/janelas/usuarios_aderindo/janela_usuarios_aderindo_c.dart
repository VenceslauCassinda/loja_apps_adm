import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/vista/janelas/cadastro/janela_cadastro.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_cadastrados/janela_usuarios_cadastrados.dart';
import 'package:modulo_autenticacao/casos_uso/autenticacao_usuario.dart';
import 'package:modulo_autenticacao/modelos/usuario.dart';
import 'package:modulo_autenticacao/provedores/provedor_usuarios.dart';
import '../../aplicacao_c.dart';

class JanelaUsuariosAderindoC extends GetxController {
  Rx<List<Usuario>?> lista = Rx<List<Usuario>?>(null);
  late AutenticacaoUsuario _autenticacaoUsuarioI;

  JanelaUsuariosAderindoC() {}

  @override
  void onInit() async {
    super.onInit();
    _autenticacaoUsuarioI = AutenticacaoUsuario(ProvedorUsuarios());
  }

  void mudarValorLista(List<Usuario>? dados) {
    lista.value = dados;
  }

  Future<void> encomendarDescargaUsuariosAderindo() async {
    mudarValorLista(null);
    AplicacaoC aplicacaoC = Get.find();
    _autenticacaoUsuarioI.aplicacaoC = aplicacaoC;
    await _autenticacaoUsuarioI.pegarListaUsuariosAderindo((await pegarAplicacaoC().pegarRotaUsuarioAderindo()),
        accaoNaFinalizacao: (resposta) {
      mudarValorLista(resposta);
    });
  }

  Future<void> encomendarAutorizacaoCadastroUsuario(Usuario usuario) async {
    await _autenticacaoUsuarioI.autorizarCadastroUsuario((await pegarAplicacaoC().pegarRotaUsuarioCadastrados()), usuario,
        accaoNaFinalizacao: (erro) {
      if (erro != null) {
        mostrarDialogoDeInformacao(erro.mensagem);
      } else {
        fecharDialogoCasoAberto();
      }
    });
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
    await _autenticacaoUsuarioI.removerUsuarioAderindo((await pegarAplicacaoC().pegarRotaUsuarioAderindo()), usuario,
        accaoNaFinalizacao: (erro) {
      if (erro != null) {
        mostrarDialogoDeInformacao(erro.mensagem);
      }
    });
  }

  void actualizarEstado() {
    var novaLista = <Usuario>[];
    novaLista.addAll(lista.value!);
    mudarValorLista(novaLista);
  }
}
