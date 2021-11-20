import 'package:get/get.dart';
import 'package:loja_apps_adm/dominio/casos_uso/autenticacao_usuario.dart';
import 'package:loja_apps_adm/dominio/modelos/usuario.dart';
import 'package:loja_apps_adm/provedores/provedor_usuarios.dart';
import 'package:loja_apps_adm/vista/contratos/autenticacao_usuario_i.dart';
import 'package:loja_apps_adm/vista/dialogos/dialogos.dart';
import 'package:loja_apps_adm/vista/layouts/layout_carregando_circualr.dart';

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
    ProvedorUsuarios provedorUsuarios = Get.find();
    _autenticacaoUsuarioI = AutenticacaoUsuario(provedorUsuarios);
  }

  Future<void> prepararAmbineteMediacao() async {}

  Future<void> orientarRealizacaoCadastro(
      String nome, String email, String palavraPasse) async {
    await _autenticacaoUsuarioI.adicionarUsuarioAderindo(Usuario(
      nome: "NomeUsuarioTeste",
      email: "e11"
    ));
  }

  _gerarDialogoPedido() {
    fecharDialogoCasoAberto();
    Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        content: LayoutCarregandoCircrular("Enviando pedido!"));
  }
}
