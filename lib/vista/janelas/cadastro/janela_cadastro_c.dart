import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/vista/aplicacao_c.dart';
import 'package:loja_apps_adm/vista/layouts/layout_carregando_circualr.dart';
import 'package:modulo_autenticacao/casos_uso/autenticacao_usuario.dart';
import 'package:modulo_autenticacao/contratos/autenticacao_usuario_i.dart';
import 'package:modulo_autenticacao/modelos/usuario.dart';
import 'package:modulo_autenticacao/provedores/provedor_usuarios.dart';

class JanelaCadastroC extends GetxController {
  late AutenticacaoUsuarioI _autenticacaoUsuarioI;
  JanelaCadastroC() {
    iniciarDependencias();
  }

  @override
  void onInit() async {
    super.onInit();
  }

  void iniciarDependencias() async {
    _autenticacaoUsuarioI = AutenticacaoUsuario(ProvedorUsuarios());
  }

  Future<void> prepararAmbineteMediacao() async {}

  Future<void> orientarRealizacaoCadastro(
      String nome, String email, String palavraPasse) async {
    await _autenticacaoUsuarioI.adicionarUsuarioAderindo((await pegarAplicacaoC().pegarRotaUsuarioAderindo()),
        Usuario(nome: "NomeUsuarioTeste", email: "e11"),
        accaoNaFinalizacao: (erro) {});
  }

  _gerarDialogoPedido() {
    fecharDialogoCasoAberto();
    Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        content: LayoutCarregandoCircrular("Enviando pedido!"));
  }
}
