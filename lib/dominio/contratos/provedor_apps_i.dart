import 'package:loja_apps_adm/dominio/modelos/erros/erro_descarga.dart';
import 'package:dartz/dartz.dart';
import 'package:loja_apps_adm/vista/janelas/usuarios_aderindo/janela_usuarios_aderindo_c.dart';
import 'package:oku_sanga_mediador_funcional/oku_sanga_mediador_funcional.dart';

abstract class ProvedorAppsI {
  Future<Either<ErroDescarga, List<Map>>> pegarListaApps();
  Future<void> decarregar(
      JanelaUsuariosAderindoC janelaMercadoC, MediadorCrud mediador);
}
