import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:componentes_visuais/componentes/novo_texto.dart';
import 'package:modulo_autenticacao/casos_uso/autenticacao_usuario.dart';
import 'package:modulo_autenticacao/casos_uso/manipulacao_area_usuario.dart';
import 'package:modulo_autenticacao/casos_uso/manipular_usuario.dart';
import 'package:modulo_autenticacao/contratos/autenticacao_usuario_i.dart';
import 'package:modulo_autenticacao/contratos/manipulacao_area_usuario_i.dart';
import 'package:modulo_autenticacao/contratos/manipulacao_usuario_i.dart';
import 'package:modulo_autenticacao/modelos/usuario.dart';
import 'package:modulo_autenticacao/provedores/provedor_usuarios.dart';
import 'package:modulo_autenticacao/provedores/provedor_area_usuario.dart';
import '../../aplicacao_c.dart';

class JanelaUsuariosCadastradosC extends GetxController {
  Rx<List<Usuario>?> lista = Rx<List<Usuario>?>(null);
  late AutenticacaoUsuarioI _autenticacaoUsuarioI;
  late ManipularUsuarioI _manipularUsuario;
  late ManipulacaoAreaUsuarioI _manipulacaoAreaUsuarioI;

  @override
  void onInit() async {
    super.onInit();
    inicializarDependencia();
  }

  Future<void> inicializarDependencia() async {
    _manipularUsuario = ManipularUsuario();
    _autenticacaoUsuarioI = AutenticacaoUsuario(ProvedorUsuarios());
    _manipulacaoAreaUsuarioI = ManipulacaoAreaUsuario(ProvedorAreaUsuario());
    await encomendarDescargaUsuariosCadastrados();
  }

  void mudarValorLista(List<Usuario>? dados) {
    lista.value = dados;
  }

  Future<void> encomendarDescargaUsuariosCadastrados() async {
    mudarValorLista(null);
    await _autenticacaoUsuarioI.pegarListaUsuariosCadastrados(
        (await pegarAplicacaoC().pegarRotaUsuarioCadastrados()),
        accaoNaFinalizacao: (resposta) {
      mudarValorLista(resposta);
    });
  }

  Future<void> encomendarRemocaoUsuarioCadastrado(Usuario usuario) async {
    lista.value!.removeWhere((element) => element.email == usuario.email);
    actualizarEstado();
    await _autenticacaoUsuarioI.removerUsuarioCadastrado(
        (await pegarAplicacaoC().pegarRotaUsuarioCadastrados()), usuario,
        accaoNaFinalizacao: (erro) {});
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

  gerarDialogoParaAdicionarRotaAreaUsuario(Usuario usuario) {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutNovoTexto(
          this,
          label: "Área do usuário",
          accaoAoFinalizar: (String rota) async {
            await adicionarRotaAreaUsuario(rota, usuario);
          },
        ));
  }

  gerarDialogoParaMudarEstadoUsuario(Usuario usuario) {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutNovoTexto(
          this,
          areaOuCampoTexto: false,
          textoPadrao: usuario.estado == null ? null : "${usuario.estado}",
          tipoCampoTexto: TipoCampoTexto.numero,
          label: "Estado do Usuário",
          accaoAoFinalizar: (String valor) async {
            int estado = -1;
            try {
              estado = int.parse(valor);
              await mudarEstadoUsuario(estado, usuario);
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
          label: "Rota do Servidor Arquivo Disponível",
          accaoAoFinalizar: (String rota) async {
            await adicionarNovaRotaServidorDisponivel(rota, usuario);
          },
        ));
  }

  gerarDialogoParaAdicionarRepositorioApp(Usuario usuario) {
    Get.defaultDialog(
        barrierDismissible: true,
        title: "",
        content: LayoutNovoTexto(
          this,
          label: "Rota do Repositório de App",
          accaoAoFinalizar: (String rota) async {
            await adicionarNovaRotaRepositorioApp(rota, usuario);
          },
        ));
  }

  Future<void> adicionarRotaAreaUsuario(String rota, Usuario usuario) async {
    if (usuario.rotaPrincipal == null) {
      usuario =
          _manipularUsuario.adicionarRotaPincipalParaUsuario(rota, usuario);
      await _autenticacaoUsuarioI.actualizarrUsuarioCadastrado(
          await pegarAplicacaoC().pegarRotaUsuarioCadastrados(),
          usuario.toJson(), accaoNaFinalizacao: (erro) {
        mostrarToast("Rota Principal do usuario ${usuario.nome} mudada!");
      });
    } else {
      mostrarDialogoDeInformacao(
          "O Usuário já possui uma rota Principal", true);
    }
  }

  Future<void> copiarNomeSenhaParaAreaUsuario(Usuario usuario) async {
    await _manipulacaoAreaUsuarioI.pegarDadosDaAreaUsuario(
        usuario.rotaPrincipal!, accaoNaFinalizacao: (resposta) async {
      var nova =
          _manipulacaoAreaUsuarioI.mudarNomeUsuario(usuario.nome!, resposta);
      nova =
          _manipulacaoAreaUsuarioI.mudarSenhaUsuario(usuario.senha!, resposta);
      await _manipulacaoAreaUsuarioI.actualizarAreaUsuario(
          usuario.rotaPrincipal!, nova);
    });
  }

  Future<void> mudarEstadoUsuario(int estado, Usuario usuario) async {
    Usuario novo = _manipularUsuario.mudarEstadoUsuario(estado, usuario);
    await _autenticacaoUsuarioI.actualizarrUsuarioCadastrado(
        await pegarAplicacaoC().pegarRotaUsuarioCadastrados(), novo.toJson(),
        accaoNaFinalizacao: (erro) {
      mostrarToast("Estado do usuario ${usuario.nome} mudado para $estado");
    });
  }

  Future<void> adicionarNovaRotaRepositorioApp(
      String rota, Usuario usuario) async {
    _manipulacaoAreaUsuarioI.pegarDadosDaAreaUsuario(usuario.rotaPrincipal!,
        accaoNaFinalizacao: (areaUsuario) async {
      if (areaUsuario.listaRepositoriosApps == null) {
        areaUsuario.listaRepositoriosApps = [];
      }
      areaUsuario.listaRepositoriosApps!.add(rota);
      await _manipulacaoAreaUsuarioI.actualizarAreaUsuario(
          usuario.rotaPrincipal!, areaUsuario);
    });
  }

  Future<void> adicionarNovaRotaServidorDisponivel(
      String rota, Usuario usuario) async {
    _manipulacaoAreaUsuarioI.pegarDadosDaAreaUsuario(usuario.rotaPrincipal!,
        accaoNaFinalizacao: (areaUsuario) async {
      if (areaUsuario.listaServidoresArquivo == null) {
        areaUsuario.listaServidoresArquivo = [];
      }
      areaUsuario.listaRepositoriosApps!.add(rota);
      await _manipulacaoAreaUsuarioI.actualizarAreaUsuario(
          usuario.rotaPrincipal!, areaUsuario);
    });
  }
}
