import 'dart:convert';
import 'package:oku_sanga_mediador_funcional/cotratos/contratos_por_interface.dart';
import 'package:loja_apps_adm/dominio/contratos/provedor_cache_i.dart';
import 'package:oku_sanga_mediador_funcional/utils/mensagens_sistema.dart';

class ManipulacaoCache implements ManipulacaoCacheI {
  final ProvedorCacheI _provedorCacheI;

  ManipulacaoCache(this._provedorCacheI);

  @override
  Future<Map?> pegarDadosDaChave(String chave) async {
    var resultado = await _provedorCacheI.pegarDadosDaChave(chave);
    if (resultado == null) {
      return null;
    }
    try {
      return json.decode(resultado);
    } catch (e) {
      if (resultado is String) {
        return {"valor": resultado};
      }
      return json.decode(resultado);
    }
  }

  @override
  Future<void> actualizarDadosDaChave(Map dados, String chave) async {
    await _provedorCacheI.actualizarDadosDaChave(
        chave, dados.isEmpty ? "" : json.encode(dados));
  }

  @override
  Future<void> inserirDadosDeChave(Map dados, String chave) async {
    await _provedorCacheI.inserirDadosDeChave(chave, json.encode(dados));
  }

  @override
  Future<void> inserirStringDeChave(String dados, String chave) async {
    await _provedorCacheI.inserirDadosDeChave(chave, dados);
  }

  @override
  Future<void> removerDadosDaChave(String chave) async {
    await _provedorCacheI.removerDadosDaChave(chave);
  }

  @override
  Future<bool> existeChave(String chave) async {
    return await _provedorCacheI.existeChave(chave);
  }

  @override
  Future<bool> existeDadosNaChave(String chave) async {
    if ((await _provedorCacheI.pegarDadosDaChave(chave)) != null) {
      return false;
    }
    return false;
  }

  @override
  Future<void> limparDados() async {
    await _provedorCacheI.limparDados();
  }

  @override
  Future<String?> pegarLinkUsuariosAderindo(String inicialEmailUsuario) async {
    Map? mapa = await pegarDadosDaChave("rotas0");
    mostrar("===============> $mapa");
    if (mapa != null) {
      List listaLinks = (mapa["repositorios_usuarios_aderindo"]);
      if (listaLinks.length == 1) {
        return listaLinks[0] as String;
      } else {
        int indice =
            pegarIndiceDorepositorioParaEmailDeInicial(inicialEmailUsuario);
        if (indice != -1) {
          return listaLinks[indice] as String;
        }
      }
    }
  }

  @override
  int pegarIndiceDorepositorioParaEmailDeInicial(String inicialEmailUsuario) {
    String abcedario = "abcdefghijklmnopqrstuvwxyz";
    int indice = -1;
    int i = 0;
    for (var item in abcedario.split("")) {
      if (item == inicialEmailUsuario) {
        indice = i;
        break;
      }
      i++;
    }
    return indice;
  }

  @override
  Future<String> pegarStringDaChave(String chave) async {
    var resultado = await _provedorCacheI.pegarDadosDaChave(chave);
    if (resultado == null) {
      return "";
    }
    return resultado;
  }
}
