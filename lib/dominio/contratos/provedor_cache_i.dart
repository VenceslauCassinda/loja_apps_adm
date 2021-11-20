abstract class ProvedorCacheI {
  Future<String?> pegarDadosDaChave(String chave);
  Future<bool> existeChave(String chave);
  Future<void> removerDadosDaChave(String chave);
  Future<void> actualizarDadosDaChave(String dados, String chave);
  Future<void> inserirDadosDeChave(String dados, String chave);
  Future<void> limparDados();
}