class App {
  late String nome, imagem, tamanho, tranferencias, 
  autoria, descricao, genero, versao, lancamento, tipo;
  late int estado;
  late List<String> listaCapturasEcra;

  App(this.nome, this.imagem, this.tamanho);

  App.fromJson(Map json) {
    this.nome = json["nome"] ?? "";
    this.tamanho = json["tamanho"] ?? "0";
    this.imagem = json["imagem"] ?? "";
    this.tranferencias = json["transferencias"] ?? "0";
    this.autoria = json["autoria"] ?? "";
    this.descricao = json["descricao"] ?? "";
    this.estado = json["estado"] ?? 1;
    this.listaCapturasEcra = json["lista_capturas_ecra"] ?? [];
    this.genero = json["genero"] ?? "";
    this.versao = json["versao"] ?? "";
    this.lancamento = json["lancamento"] ?? "";
    this.tipo = json["tipo"] ?? "";
  }

  Map toJson() {
    return {
      "nome": this.nome,
      "tamanho": this.tamanho,
      "imagem": this.imagem,
      "tranferencias": this.tranferencias,
      "autoria": this.autoria,
      "descricao": this.descricao,
      "estado": this.estado,
      "lista_capturas_ecra": this.listaCapturasEcra,
      "genero": this.genero,
      "versao": this.versao,
      "lancamento": this.lancamento,
      "tipo": this.tipo,
    };
  }
}
