import 'dart:ui';

import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'janela_usuarios_cadastrados_c.dart';
import 'package:oku_sanga_mediador_funcional/oku_sanga_mediador_funcional.dart';

class JanelaUsuariosCadastrados extends StatelessWidget {
  late JanelaUsuariosCadastradosC _c;
  JanelaUsuariosCadastrados() {
    _c = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Usuarios Cadstrados",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
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
                        await _c.encomendarDescargaUsuariosCadastrados();
                      },
                      child: Icon(Icons.sync),
                    )
                  ],
                ));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await _c.encomendarDescargaUsuariosCadastrados();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 10,
                      children: _c.lista.value!
                          .map((element) => Stack(
                                children: [
                                  ModeloItemLista(
                                    itemRemovivel: true,
                                    tituloItem: element.nome,
                                    subTituloItem: element.email,
                                    metodoChamadoAoClicarItem: () {
                                      
                                    },
                                    metodoChamadoAoRemoverItem: () {
                                      _c.gerarDialogoParaRemocaoUsuario(
                                          element);
                                    },
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30, right: 80),
                                        child: InkWell(
                                            onTap: () {
                                              _c.gerarDialogoParaAdicionarRota(
                                                  element);
                                            },
                                            child: Icon(Icons.add)),
                                      ),
                                    ],
                                  ),
                                ],
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
