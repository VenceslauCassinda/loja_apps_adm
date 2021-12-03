import 'package:loja_apps/dominio/modelos/usuario.dart';

abstract class ManipularUsuarioI {
  Usuario adicionarRotaPincipalParaUsuario(String rota, Usuario usuario);
  Usuario adicionarEstadoUsuario(int estado, Usuario usuario);
}