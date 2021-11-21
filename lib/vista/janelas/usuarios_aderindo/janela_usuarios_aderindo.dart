import 'dart:ui';

import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/vista/componentes/item_app.dart';
import 'package:loja_apps_adm/vista/componentes/item_usuario.dart';

import 'janela_usuarios_aderindo_c.dart';

class JanelaUsuariosAderindo extends StatelessWidget {
  late JanelaUsuariosAderindoC _c;
  JanelaUsuariosAderindo() {
    _c = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  _c.irParaJanelaCadastro();
                },
                child: Text(
                  "Usuarios Aderindo",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  _c.irParaJanelaUsuariosCadastrados();
                },
                child: Icon(
                  Icons.people,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CampoTexto(
                icone: Icon(Icons.search),
                campoBordado: false,
                dicaParaCampo: "Pesquisar",
                metodoChamadoNaInsersao: (valor) async {},
              ),
            ),
            Expanded(child: Obx(() {
              if (_c.lista.value == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (_c.lista.value!.isEmpty) {
                return Center(
                    child: Column(
                  children: [
                    Text("Sem dados!"),
                    InkWell(
                      onTap: () async {
                        await _c.encomendarDescargaUsuariosAderindo();
                      },
                      child: Icon(Icons.sync),
                    )
                  ],
                ));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await _c.encomendarDescargaUsuariosAderindo();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 10,
                      children: _c.lista.value!
                          .map((element) => ModeloItemLista(
                                itemAceitavel: true,
                                itemRemovivel: true,
                                tituloItem: element.nome,
                                subTituloItem: element.email,
                                metodoChamadoAoRemoverItem: () {},
                                metodoChamadoAoAceitarItem: () async {
                                  _c.gerarDialogoParaRemocaoUsuario(element);
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            }))
          ],
        ));
  }
}
