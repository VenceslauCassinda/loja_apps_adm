import 'package:oku_sanga_mediador_funcional/entidades/erros/todos_erros.dart';

class ErroDescarga extends Erro implements Exception {
  ErroDescarga(String mensagem) : super(mensagem);
}
