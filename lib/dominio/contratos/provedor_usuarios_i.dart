abstract class ProvedorUsuariosI {
  Future<List<Map>> pegarListaUsuariosAderindo();
  Future<List<Map>> pegarListaUsuariosCadastrados();
  Future<void> removerUsuarioCadastrado(Map usuario);
  Future<void> autorizarCadastroUsuario(Map usuario);
  Future<void> removerUsuarioAderindo(Map usuario);
}
