import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'janela_usuarios_cadastrados_c.dart';

class JanelaUsuariosCadastrados extends StatelessWidget {
  late JanelaUsuariosCadastradosC _c;
  JanelaUsuariosCadastrados() {
    _c = Get.put(JanelaUsuariosCadastradosC());
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
                context: context,
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
                                    itemComMenu: true,
                                    metodoChamadoAoClicarItem: () {},
                                    metodoChamadoAoRemoverItem: () {
                                      _c.gerarDialogoParaRemocaoUsuario(
                                          element);
                                    },
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      PopupMenuButton(
                                        padding:
                                            EdgeInsets.only(top: 30, right: 10),
                                        itemBuilder: (context) {
                                          return [
                                            "Novo Servidor Disponível",
                                            "Novo Repositório App",
                                            "Mudar Estado",
                                            "Copiar Nome e Senha",
                                          ]
                                              .map((e) => PopupMenuItem(
                                                    child: Text(e),
                                                    value: e,
                                                  ))
                                              .toList();
                                        },
                                        onSelected: (String opcao) {
                                          if (opcao.contains("Servidor")) {
                                            _c.gerarDialogoParaAdicionarServidorArquivoDisponivel(
                                                element);
                                            return;
                                          }
                                          if (opcao.contains("Estado")) {
                                            _c.gerarDialogoParaMudarEstadoUsuario(
                                                element);
                                            return;
                                          }
                                          if (opcao.contains("Copiar")) {
                                            _c.copiarNomeSenhaParaAreaUsuario(
                                                element);
                                            return;
                                          }
                                          if (opcao.contains("Repositório")) {
                                            _c.gerarDialogoParaAdicionarRepositorioApp(
                                                element);
                                            return;
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30, right: 80),
                                        child: InkWell(
                                            onTap: () {
                                              _c.gerarDialogoParaAdicionarRotaAreaUsuario(
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
