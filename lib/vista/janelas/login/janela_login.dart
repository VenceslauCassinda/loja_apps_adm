import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/label_erros.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/logo_no_circulo.dart';
import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'janela_login_c.dart';

class JanelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: CorpoJanelaLogin(),
    );
  }
}

class CorpoJanelaLogin extends StatelessWidget {
  late JanelaLoginC _c;
  late ObservadorCampoTexto _observadorCampoTexto;
  late ObservadorButoes _observadorButoes;
  String email = "", palavraPasse = "";

  CorpoJanelaLogin() {
    _c = JanelaLoginC();
    _observadorCampoTexto = ObservadorCampoTexto();
    _observadorButoes = ObservadorButoes();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: LogoNoCirculo()),
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
                    valor, TipoCampoTexto.generico);
                if (valor.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.generico);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  email,
                  palavraPasse
                ], [
                  _observadorCampoTexto.valorEmailValido.value,
                  _observadorCampoTexto.valorPalavraPasseValido.value
                ]);
              },
            ),
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
                  email,
                  palavraPasse
                ], [
                  _observadorCampoTexto.valorEmailValido.value,
                  _observadorCampoTexto.valorPalavraPasseValido.value
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
          Container(
            width: MediaQuery.of(context).size.width * .7,
            child: Obx(() {
              return ModeloButao(
                corButao: Colors.white.withOpacity(.8),
                butaoHabilitado:
                    _observadorButoes.butaoFinalizarCadastroInstituicao.value,
                tituloButao: "Entrar",
                metodoChamadoNoClique: () async {},
              );
            }),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Divider(),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .7,
            child: ModeloButao(
              corButao: Colors.white.withOpacity(.8),
              tituloButao: "Cadastrar",
              metodoChamadoNoClique: () {
                _c.irParaJanelaCadastro();
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
