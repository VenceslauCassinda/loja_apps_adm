import 'package:dependencias_loja_apps/usuarios/provedor_usuarios_i.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';
import 'package:loja_apps_adm/vista/contratos/autenticacao_usuario_i.dart';

class AutenticacaoUsuario implements AutenticacaoUsuarioI {
  final ProvedorUsuariosI _provedorUsuariosI;
  AutenticacaoUsuario(this._provedorUsuariosI);

  @override
  Future<List<Usuario>> pegarListaUsuariosAderindo() async {
    var resposta = await _provedorUsuariosI.pegarListaUsuariosAderindo();
    return resposta.map((e) => Usuario.fromJson(e)).toList();
  }

  @override
  Future<void> adicionarUsuarioAderindo(Usuario usuario) async {}

  @override
  Future<List<Usuario>> pegarListaUsuariosCadastrados() async {
    await _provedorUsuariosI.pegarListaUsuariosCadastrados();
    return [];
  }

  @override
  Future<void> autorizarCadastroUsuario(Usuario usuario) async {
    await _provedorUsuariosI.autorizarCadastroUsuario(usuario.toJson());
  }

  @override
  Future<void> removerUsuarioCadastrado(Usuario usuario) async {
    await _provedorUsuariosI.removerUsuarioCadastrado(usuario.toJson());
  }

  @override
  Future<void> removerUsuarioAderindo(Usuario usuario) async {
    await _provedorUsuariosI.removerUsuarioAderindo(usuario.toJson());
  }

  @override
  Future<void> actualizarrUsuarioCadastrado(Map usuario) async {
    await _provedorUsuariosI.actualizarrUsuarioCadastrado(usuario);
  }
}
