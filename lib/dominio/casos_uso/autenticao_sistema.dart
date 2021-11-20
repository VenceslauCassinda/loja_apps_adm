import 'package:dartz/dartz.dart';
import 'package:loja_apps_adm/dominio/contratos/provedor_autenticacao_i.dart';
import 'package:loja_apps_adm/dominio/modelos/falhas/falha_autenticacao.dart';
import 'package:loja_apps_adm/vista/contratos/autenticao_sistema_i.dart';

class AutenticaoSistema implements AutenticaoSistemaI {
  late ProvedorAutenticacaoI _provedorAutenticacaoI;

  AutenticaoSistema(this._provedorAutenticacaoI);
  @override
  Future<Either<FalhaAutenticacao, Map>> autenticarSistema(Function(Object dadoRequisitado) accaoNaDevolucaoDadoRequisitado) async {
    return await _provedorAutenticacaoI.autenticarSistema(accaoNaDevolucaoDadoRequisitado);
  }
}
