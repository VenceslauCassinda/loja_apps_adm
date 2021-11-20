import 'package:get/get.dart';
import 'package:loja_apps_adm/dominio/contratos/provedor_usuarios_i.dart';
import 'package:loja_apps_adm/dominio/modelos/usuario.dart';
import 'package:loja_apps_adm/vista/aplicacao_c.dart';
import 'package:loja_apps_adm/vista/dialogos/dialogos.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_aderindo/janela_usuarios_aderindo_c.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_cadastrados/janela_usuarios_cadastrados_c.dart';
import 'package:oku_sanga_mediador_funcional/oku_sanga_mediador_funcional.dart';
import 'package:oku_sanga_mediador_funcional/entidades/operacao_crud_repositorio.dart';

class ProvedorUsuarios implements ProvedorUsuariosI {
  MediadorCrud? _mediadorCrudAderindo;
  MediadorCrud? _mediadorCrudCadastrados;

  ProvedorUsuarios() {}

  @override
  Future<List<Map>> pegarListaUsuariosAderindo() async {
    _mediadorCrudAderindo =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosAderindo(),
            accaoNaIndisponibilidadeServidor: () async {
      await pegarListaUsuariosAderindo();
    });
    _mediadorCrudAderindo!.contruirMediador(
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
  Future<void> autorizarCadastroUsuario(Map usuario) async {
    _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () async {
      await autorizarCadastroUsuario(usuario);
    });
    _mediadorCrudCadastrados!.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(
          usuario, listaSubRepositoriosAntiga, true, "email", () {
        mostrarDialogoDeInformacao(
            "Já existe um usuario com este email!", false);
      }, OperacaoCrudEmRepositorio.adicionar);
    });
  }

  @override
  Future<List<Map>> pegarListaUsuariosCadastrados() async {
    _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () async {
      pegarListaUsuariosCadastrados();
    });
    _mediadorCrudCadastrados!.contruirMediador(
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
  Future<void> removerUsuarioCadastrado(Map usuario) async {
    _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosCadastrados(),
            accaoNaIndisponibilidadeServidor: () {
      mostrarDialogoDeInformacao("Servidor indisponível de momento!", true, () {
        JanelaUsuariosCadastradosC cadastradosC = Get.find();
        cadastradosC.gerarDialogoParaRemocaoUsuario(Usuario.fromJson(usuario));
      });
    });
    _mediadorCrudCadastrados!.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(usuario, listaSubRepositoriosAntiga,
          true, "email", () {}, OperacaoCrudEmRepositorio.remover);
    });
  }

  @override
  Future<void> removerUsuarioAderindo(Map usuario) async {
    _mediadorCrudCadastrados =
        MediadorCrud(await pegarAplicacaoC().pegarRotaUsuariosAderindo(),
            accaoNaIndisponibilidadeServidor: () {
      mostrarDialogoDeInformacao("Servidor indisponível de momento!", true, () {
        JanelaUsuariosAderindoC aderindoC = Get.find();
        aderindoC.gerarDialogoParaRemocaoUsuario(Usuario.fromJson(usuario));
      });
    });
    _mediadorCrudCadastrados!.contruirMediador(
        accaoNaFinalizacaoPreparo: (m) async {
      var listaSubRepositoriosAntiga = (await m.pegarListaSubRepositorios())!;
      await m.submeterRepositorioCompleto(usuario, listaSubRepositoriosAntiga,
          true, "email", () {}, OperacaoCrudEmRepositorio.remover);
    });
  }
}
