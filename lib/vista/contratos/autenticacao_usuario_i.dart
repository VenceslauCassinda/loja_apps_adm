import 'package:loja_apps_adm/dominio/modelos/usuario.dart';

abstract class AutenticacaoUsuarioI {
  Future<List<Usuario>> pegarListaUsuariosAderindo();
  Future<List<Usuario>> pegarListaUsuariosCadastrados();
  Future<void> adicionarUsuarioAderindo(Usuario usuario);
  Future<void> autorizarCadastroUsuario(Usuario usuario);
  Future<void> removerUsuarioCadastrado(Usuario usuario);
  Future<void> removerUsuarioAderindo(Usuario usuario);
}
