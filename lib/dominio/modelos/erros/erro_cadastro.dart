import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';

class ErroCadastro extends Erro implements Exception {
  ErroCadastro(String mensagem) : super(mensagem);
}
