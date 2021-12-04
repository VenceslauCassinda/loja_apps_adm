import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';

class LayoutNovoTexto extends StatelessWidget {
  ObservadorButoes observadorButoes = ObservadorButoes();
  ObservadorCampoTexto observadorCampoTexto = ObservadorCampoTexto();

  Function(String texto)? accaoAoFinalizar;
  TipoCampoTexto? tipoCampoTexto;

  var janelaC;
  String texto = "";
  String? textoPadrao;
  String? label;

  LayoutNovoTexto(this.janelaC, {this.accaoAoFinalizar, this.label, this.tipoCampoTexto, this.textoPadrao});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CampoTexto(
            textoPadrao: textoPadrao,
            dicaParaCampo: label ?? "Rota",
            tipoCampoTexto: tipoCampoTexto ?? TipoCampoTexto.nome,
            icone: Icon(Icons.text_fields),
            campoBordado: true,
            metodoChamadoNaInsersao: (String valor) {
              texto = valor;
              observadorButoes.mudarValorFinalizarCadastroInstituicao(
                  [""], [valor.isEmpty]);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ModeloButao(
                  tituloButao: "Finalizar",
                  butaoHabilitado: true,
                  metodoChamadoNoClique: () async {
                    fecharDialogoCasoAberto();
                    if (accaoAoFinalizar != null) {
                      accaoAoFinalizar!(texto);
                    }
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                ModeloButao(
                  butaoHabilitado: true,
                  tituloButao: "Cancelar",
                  metodoChamadoNoClique: () {
                    fecharDialogoCasoAberto();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
