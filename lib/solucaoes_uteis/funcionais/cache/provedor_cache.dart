import 'package:get/get.dart';
import 'package:loja_apps_adm/dominio/contratos/provedor_cache_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvedorCache implements ProvedorCacheI {
  Future<SharedPreferences> pegarSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<String?> pegarDadosDaChave(String chave) async {
    var resultado = (await pegarSharedPreferences()).get(chave);
    if (resultado is String) {
      return resultado;
    }
    if ((resultado as Map).isEmpty) {
      return "";
    }

    return null;
  }

  @override
  Future<void> actualizarDadosDaChave(String dados, String chave) async {
    await (await pegarSharedPreferences()).setString(chave, dados);
  }

  @override
  Future<void> inserirDadosDeChave(String chave, String dados) async {
    await ((await pegarSharedPreferences()).setString(chave, dados));
  }

  @override
  Future<void> removerDadosDaChave(String chave) async {
    await ((await pegarSharedPreferences()).remove(chave));
  }

  @override
  Future<bool> existeChave(String chave) async {
    var chaveEncontrada = ((await pegarSharedPreferences())
        .getKeys()
        .firstWhere((element) => element == chave, orElse: () => ""));
    return chaveEncontrada.isNotEmpty;
  }

  @override
  Future<void> limparDados() async {
    await (await pegarSharedPreferences()).clear();
  }
}
