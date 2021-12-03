import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps_adm/vista/contratos/manipulacao_usuario.dart';
import 'package:oku_sanga_mediador_funcional/recursos/constantes.dart';

class ManipularUsuario implements ManipularUsuarioI {
  @override
  Usuario adicionarRotaPincipalParaUsuario(String rota, Usuario usuario) {
    usuario.rotaPrincipal = rota.replaceAll(URL_BASE_SISTEMA, "");
    return usuario;
  }

  @override
  Usuario adicionarEstadoUsuario(int estado, Usuario usuario) {
    usuario.estado = estado;
    return usuario;
  }
}
