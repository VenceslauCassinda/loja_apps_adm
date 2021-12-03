import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:dependencias_loja_apps/usuarios/provedor_usuarios_i.dart';
import 'package:loja_apps/vista/dialogos/dialogos.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps_adm/vista/aplicacao_c.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_aderindo/janela_usuarios_aderindo_c.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_cadastrados/janela_usuarios_cadastrados_c.dart';
import 'package:oku_sanga_mediador_funcional/oku_sanga_mediador_funcional.dart';
import 'package:oku_sanga_mediador_funcional/entidades/operacao_crud_repositorio.dart';
import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';

class ProvedorUsuarios implements ProvedorUsuariosI {

  @override
  Future<List<Map>> pegarListaUsuariosAderindo() async {
    MediadorCrud _mediadorCrudAderindo =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosAderindo(),
            accaoNaIndisponibilidadeServidor: () async {
      await pegarListaUsuariosAderindo();
    });
    _mediadorCrudAderindo.contruirMediador(
        accaoNaFinalizacaoPreparo: (mediador) async {
      JanelaUsuariosAderindoC janelaUsuariosAderindoC = Get.find();
      await decarregar(janelaUsuariosAderindoC, mediador);
    });
    return [];
  }

  Future<void> decarregar(var janelaUsuarios, MediadorCrud mediador) async {
    var listaRepositorios = await mediador.pegarListaSubRepositorios();
    listaRepositorios!.removeWhere((element) {
      if (element is Map) {
        if (element["estado"] == 0) {
          return true;
        }
      }
      return false;
    });

    var lista = [];

    for (var cadaMapa in listaRepositorios) {
      if (cadaMapa["lista"] is List) {
        var listaAppCadaRepositorio = cadaMapa["lista"] as List;
        if (listaAppCadaRepositorio.isNotEmpty) {
          lista.addAll(listaAppCadaRepositorio);
        }
      }
    }
    janelaUsuarios
        .mudarValorLista(lista.map((e) => Usuario.fromJson(e)).toList());
  }

  @override
  Future<void> autorizarCadastroUsuario(Map usuario, {Function(Erro? erro)? accaoNaFinalizacao}) async {
    MediadorCrud _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () async {
      await autorizarCadastroUsuario(usuario);
    });
    _mediadorCrudCadastrados.accaoNoFimDeTodaSubmissao = () async {
      JanelaUsuariosAderindoC aderindoC = Get.find();
      await aderindoC
          .encomendarRemocaoUsuarioAderindo(Usuario.fromJson(usuario));
    };
    await _mediadorCrudCadastrados.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(
          usuario, listaSubRepositoriosAntiga, true, "email", () {
        mostrarDialogoDeInformacao(
            "Já existe um usuario com este email!", true);
      }, OperacaoCrudEmRepositorio.adicionar);
    });
  }

  @override
  Future<List<Map>> pegarListaUsuariosCadastrados() async {
    MediadorCrud _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () async {
      pegarListaUsuariosCadastrados();
    });
    _mediadorCrudCadastrados.contruirMediador(
        accaoNaFinalizacaoPreparo: (mediador) async {
      JanelaUsuariosCadastradosC janelaUsuariosCadastradosC = Get.find();
      await decarregar(janelaUsuariosCadastradosC, mediador);
    });
    return [];
  }

  AplicacaoC pegarAplicacaoC() {
    return Get.find();
  }

  @override
  Future<void> removerUsuarioCadastrado(Map usuario, {Function(Erro? erro)? accaoNaFinalizacao}) async {
    MediadorCrud _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () {
      mostrarDialogoDeInformacao("Servidor indisponível de momento!", true, () {
        JanelaUsuariosCadastradosC cadastradosC = Get.find();
        cadastradosC.gerarDialogoParaRemocaoUsuario(Usuario.fromJson(usuario));
      });
    });

    _mediadorCrudCadastrados.accaoNoFimDeTodaSubmissao = () async {
      mostrarToast("Usuário eliminado!");
      mostrar("USUARIO REMOVIDO DOS ADERINDO");
    };

    _mediadorCrudCadastrados.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(usuario, listaSubRepositoriosAntiga,
          true, "email", () {}, OperacaoCrudEmRepositorio.remover);
    });
  }

  @override
  Future<void> removerUsuarioAderindo(Map usuario, {Function(Erro? erro)? accaoNaFinalizacao}) async {
    MediadorCrud _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosAderindo(),
            accaoNaIndisponibilidadeServidor: () {
      mostrarDialogoDeInformacao("Servidor indisponível de momento!", true, () {
        JanelaUsuariosAderindoC aderindoC = Get.find();
        aderindoC.gerarDialogoParaRemocaoUsuario(Usuario.fromJson(usuario));
      });
    });
    _mediadorCrudCadastrados.accaoNoFimDeTodaSubmissao = () {
      fecharDialogoCasoAberto();
    };
    _mediadorCrudCadastrados.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(usuario, listaSubRepositoriosAntiga,
          true, "email", () {}, OperacaoCrudEmRepositorio.remover);
    });
  }

  @override
  Future<void> adicionarUsuarioAderindo(Map usuario, {Function(Erro? erro)? accaoNaFinalizacao}) {
    // TODO: implement adicionarUsuarioAderindo
    throw UnimplementedError();
  }

  @override
  Future<void> actualizarrUsuarioCadastrado(Map usuario, {Function(Erro? erro)? accaoNaFinalizacao}) async {
    MediadorCrud _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () async {
      await actualizarrUsuarioCadastrado(usuario);
    });
    _mediadorCrudCadastrados.accaoNoFimDeTodaSubmissao = () async {
      fecharDialogoCasoAberto();
      JanelaUsuariosCadastradosC c = Get.find();
      await c.encomendarDescargaUsuariosCadastrados();
      mostrarToast("Usuário actualizado!");
    };
    _mediadorCrudCadastrados.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(usuario, listaSubRepositoriosAntiga,
          true, "email", () {}, OperacaoCrudEmRepositorio.editar);
    });
  }

  @override
  Future<Map?> fazerLogin(String rota, String email, String senha, {Function(Map? usuario)? accaoNaFinalizacao}) {
    // TODO: implement fazerLogin
    throw UnimplementedError();
  }
}
