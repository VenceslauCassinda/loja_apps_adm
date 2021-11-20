import 'package:get/get.dart';
import 'package:loja_apps_adm/vista/layouts/layout_carregando_circualr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loja_apps_adm/vista/layouts/layout_informacao.dart';

mostrarCarregandoDialogoDeInformacao(String informacao, [bool? fechavel]) {
  fecharDialogoCasoAberto();
  Get.defaultDialog(
      barrierDismissible: fechavel == null ? false : true,
      title: "",
      content: LayoutCarregandoCircrular(informacao));
}

mostrarDialogoDeInformacao(String informacao,
    [bool? fechavel, Function? accaoNaNovaTentativa]) {
  fecharDialogoCasoAberto();
  Get.defaultDialog(
      barrierDismissible: fechavel == null ? false : fechavel,
      title: "",
      content: LayoutInformacao(informacao, accaoNaNovaTentativa));
}

void fecharDialogoCasoAberto() {
  var teste = Get.isDialogOpen;
  bool avaliacao = teste == null ? false : Get.isDialogOpen!;
  if (avaliacao == true) {
    Get.back();
  }
}

mostrarToast(String sms) {
  Fluttertoast.showToast(msg: sms);
}
