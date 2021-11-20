import 'dart:async';

void executarAccaoNoTempoEmMilissegundos(int milissegundos, Function accaoAexecutar){
  Timer.periodic(Duration(milliseconds: milissegundos), (timer){
    accaoAexecutar();
    timer.cancel();
  });
}