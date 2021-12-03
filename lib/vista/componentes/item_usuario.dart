import 'package:flutter/material.dart';
import 'package:loja_apps/dominio/modelos/usuario.dart';

class ItemUsuario extends StatelessWidget {
  final Usuario usuario;

  ItemUsuario(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Text(usuario.nome!);
  }
}
