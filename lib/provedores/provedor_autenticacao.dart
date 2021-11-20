import 'package:dartz/dartz.dart';
import 'package:dependencias_loja_apps/dependencias/configuracao_loja_apps.dart';
import 'package:loja_apps_adm/dominio/contratos/provedor_autenticacao_i.dart';
import 'package:loja_apps_adm/dominio/modelos/falhas/falha_autenticacao.dart';
import 'package:oku_sanga_mediador_funcional/paradgma/auttenticacao/accoes_autenticacao.dart';

class ProvedorAutenticacao extends ProvedorAutenticacaoI {
  late AccoesAutenticacao _accoesAutenticacao;

  ProvedorAutenticacao() {
    _accoesAutenticacao = AccoesAutenticacao(ID_CONFIGURACAO_SISTEMA);
  }

  @override
  Future<Either<FalhaAutenticacao, Map>> autenticarSistema(
      Function(Object dadoRequisitado) accaoNaDevolucaoDadoRequisitado) async {
    await _accoesAutenticacao.prepararMediador(
        accaoNaDevolucaoDadoRequisitado: (dado) {
      if (dado is List) {
        dado.removeWhere((element) {
          if (element is Map) {
            if (element["estado"] == 0) {
              return true;
            }
          }
          return false;
        });
      }
      accaoNaDevolucaoDadoRequisitado(dado);
    });
    return Right({});
  }
}
