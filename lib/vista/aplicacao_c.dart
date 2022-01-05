import 'dart:developer';

import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:componentes_visuais/dialogo/toast.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/dominio/casos_uso/manipulacao_cache.dart';
import 'package:loja_apps_adm/solucaoes_uteis/funcionais/cache/provedor_cache.dart';
import 'package:loja_apps_adm/solucaoes_uteis/funcionais/execucao_funcoes.dart';
import 'package:modulo_autenticacao/casos_uso/autenticao_sistema.dart';
import 'package:modulo_autenticacao/contratos/autenticao_sistema_i.dart';
import 'package:modulo_autenticacao/provedores/provedor_autenticacao.dart';
import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';
import 'package:oku_sanga_mediador_funcional/utils/mensagens_sistema.dart';
import 'package:oku_sanga_mediador_funcional/cotratos/contratos_por_interface.dart';
import 'janelas/usuarios_aderindo/janela_usuarios_aderindo_c.dart';

class AplicacaoC extends GetxController {
  String chaveCacheConfiguracaoApp = "configuracao_app";
  bool sistemaAutenticado = false;
  late AutenticaoSistemaI autenticaoSistemaI;
  late ManipulacaoCacheI manipulacaoCacheI;

  @override
  Future<void> onInit() async {
    super.onInit();

    autenticaoSistemaI = AutenticaoSistema(ProvedorAutenticacao());
    manipulacaoCacheI = ManipulacaoCache(ProvedorCache());

    await autenticarSistema();
  }

  Future<void> autenticarSistema() async {
    executarAccaoNoTempoEmMilissegundos(1000, () {
      try {
        mostrarCarregandoDialogoDeInformacao("Autenticando o Sistema");
      } catch (e) {
        executarAccaoNoTempoEmMilissegundos(500, () {
          mostrarCarregandoDialogoDeInformacao("Autenticando o Sistema");
        });
      }
    });
    await autenticaoSistemaI.autenticarSistema((dadoRequisitado) async {
      fecharDialogoCasoAberto();
      if (dadoRequisitado is Erro) {
        mostrarDialogoDeInformacao(dadoRequisitado.mensagem, false, () async {
          await _repetirAutenticacao();
        });
        if (dadoRequisitado is ErroAutenticacao) {
          mostrarToast("A autenticação será repetida em 2 segundos!");
          executarAccaoNoTempoEmMilissegundos(2000, () async {
            await _repetirAutenticacao();
          });
        }
        mostrar(dadoRequisitado);
      } else {
        await manipulacaoCacheI.inserirDadosDeChave({
          "$chaveCacheConfiguracaoApp": (dadoRequisitado as List)[0]
              ["configuracao"]
        }, chaveCacheConfiguracaoApp);
        JanelaUsuariosAderindoC janelaUsuariosAderindoC = Get.find();
        await janelaUsuariosAderindoC.encomendarDescargaUsuariosAderindo();
      }
    });
  }

  Future<void> _repetirAutenticacao() async {
    autenticaoSistemaI = AutenticaoSistema(ProvedorAutenticacao());
    await autenticarSistema();
  }

  Future<String> pegarRotaUsuarioAderindo() async {
    Map configuracao = (await manipulacaoCacheI.pegarDadosDaChave(
        chaveCacheConfiguracaoApp))![chaveCacheConfiguracaoApp];
    return configuracao["rotas"]["usuarios_aderindo"];
  }

  Future<String> pegarRotaUsuarioCadastrados() async {
    Map configuracao = (await manipulacaoCacheI.pegarDadosDaChave(
        chaveCacheConfiguracaoApp))![chaveCacheConfiguracaoApp];
    return configuracao["rotas"]["usuarios_cadastrados"];
  }
}

AplicacaoC pegarAplicacaoC() {
  return Get.find();
}
