import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/label_erros.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_apps_adm/vista/janelas/cadastro/janela_cadastro_c.dart';

class JanelaCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastrar",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: CorpoJanelaCadastro(),
    );
  }
}

class CorpoJanelaCadastro extends StatelessWidget {
  late ObservadorCampoTexto _observadorCampoTexto;
  late ObservadorCampoTexto _observadorCampoTexto2;
  late ObservadorButoes _observadorButoes = ObservadorButoes();

  late JanelaCadastroC _c;

  String nome = "",
      email = "",
      telefone = "",
      palavraPasse = "",
      confirmePalavraPasse = "",
      valorSeleccionadoMenuDropDown = "";
  late BuildContext context;

  CorpoJanelaCadastro() {
    _observadorCampoTexto = ObservadorCampoTexto();
    _observadorCampoTexto2 = ObservadorCampoTexto();
    _observadorButoes = ObservadorButoes();

    _c = JanelaCadastroC();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              context: context,
              campoBordado: false,
              icone: Icon(Icons.text_fields),
              dicaParaCampo: "Nome",
              metodoChamadoNaInsersao: (String valor) {
                nome = valor;
                _observadorCampoTexto.observarCampo(valor, TipoCampoTexto.nome);
                if (valor.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.nome);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  nome,
                  email,
                  telefone,
                  valorSeleccionadoMenuDropDown,
                  palavraPasse,
                  confirmePalavraPasse
                ], [
                  _observadorCampoTexto.valorNomeValido.value,
                  _observadorCampoTexto.valorEmailValido.value,
                  _observadorCampoTexto.valorPalavraPasseValido.value,
                  _observadorCampoTexto2.valorPalavraPasseValido.value
                ]);
              },
            ),
          ),
          Obx(() {
            return _observadorCampoTexto.valorNomeValido.value == true
                ? Container()
                : LabelErros(
                    sms: "Este Nome ainda é inválido!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              context: context,
              campoBordado: false,
              icone: Icon(Icons.email),
              dicaParaCampo: "Email",
              metodoChamadoNaInsersao: (String valor) {
                email = valor;
                _observadorCampoTexto.observarCampo(
                    valor, TipoCampoTexto.email);
                if (valor.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.email);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  nome,
                  email,
                  telefone,
                  valorSeleccionadoMenuDropDown,
                  palavraPasse,
                  confirmePalavraPasse
                ], [
                  _observadorCampoTexto.valorNomeValido.value,
                  _observadorCampoTexto.valorEmailValido.value,
                  _observadorCampoTexto.valorPalavraPasseValido.value,
                  _observadorCampoTexto2.valorPalavraPasseValido.value
                ]);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            return _observadorCampoTexto.valorEmailValido.value == true
                ? Container()
                : LabelErros(
                    sms: "Este email ainda é inválido!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              context: context,
              campoBordado: false,
              icone: Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.palavra_passe,
              dicaParaCampo: "Palavra-Passe",
              metodoChamadoNaInsersao: (String valor) {
                palavraPasse = valor;
                _observadorCampoTexto.observarCampo(
                    valor, TipoCampoTexto.palavra_passe);
                if (valor.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.palavra_passe);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  nome,
                  email,
                  telefone,
                  valorSeleccionadoMenuDropDown,
                  palavraPasse,
                  confirmePalavraPasse
                ], [
                  _observadorCampoTexto.valorNomeValido.value,
                  _observadorCampoTexto.valorEmailValido.value,
                  _observadorCampoTexto.valorPalavraPasseValido.value,
                  _observadorCampoTexto2.valorPalavraPasseValido.value
                ]);
              },
            ),
          ),
          Obx(() {
            return _observadorCampoTexto.valorPalavraPasseValido.value == true
                ? Container()
                : LabelErros(
                    sms: "A palavra-passe deve ter mais de 7 caracteres!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CampoTexto(
              context: context,
              campoBordado: false,
              icone: Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.palavra_passe,
              dicaParaCampo: "Confirmar Palavra-Passe",
              metodoChamadoNaInsersao: (String valor) {
                confirmePalavraPasse = valor;
                _observadorCampoTexto2.observarCampo(
                    valor, TipoCampoTexto.palavra_passe);
                if (valor.isEmpty) {
                  _observadorCampoTexto2.mudarValorValido(
                      true, TipoCampoTexto.palavra_passe);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  nome,
                  email,
                  telefone,
                  valorSeleccionadoMenuDropDown,
                  palavraPasse,
                  confirmePalavraPasse
                ], [
                  _observadorCampoTexto.valorNomeValido.value,
                  _observadorCampoTexto.valorEmailValido.value,
                  _observadorCampoTexto.valorPalavraPasseValido.value,
                  _observadorCampoTexto2.valorPalavraPasseValido.value
                ]);
              },
            ),
          ),
          Obx(() {
            return _observadorCampoTexto2.valorPalavraPasseValido.value == true
                ? Container()
                : LabelErros(
                    sms: "Esta palavra-passe de ser igual ao campo anterior!",
                  );
          }),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            return Container(
              width: MediaQuery.of(context).size.width * .7,
              child: ModeloButao(
                corButao: Colors.white.withOpacity(.8),
                butaoHabilitado:
                    _observadorButoes.butaoFinalizarCadastroInstituicao.value ||
                        1 == 1,
                tituloButao: "Finalizar",
                metodoChamadoNoClique: () async {
                  await _c.orientarRealizacaoCadastro(nome, email, palavraPasse);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class LinhaProgressoPequena extends StatelessWidget {
  LinhaProgressoPequena({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .5,
        child: LinearProgressIndicator());
  }
}
