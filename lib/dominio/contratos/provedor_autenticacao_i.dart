import 'package:dartz/dartz.dart';
import 'package:loja_apps_adm/dominio/modelos/falhas/falha_autenticacao.dart';

abstract class ProvedorAutenticacaoI {
  Future<Either<FalhaAutenticacao, Map>> autenticarSistema(Function(Object dadoRequisitado) accaoNaDevolucaoDadoRequisitado);
}