class Usuario {
  String? nome, email, senha, imagem;
  int? estado;

  Usuario({this.nome, this.email, this.senha, this.imagem, this.estado});

  Usuario.fromJson(Map json) {
    this.nome = json["nome"] ?? "";
    this.email = json["email"] ?? "";
    this.senha = json["senha"] ?? "";
    this.imagem = json["imagem"] ?? "";
    this.estado = json["estado"] ?? 0;
  }

  Map toJson() {
    return {
      "nome": this.nome,
      "email": this.email,
      "senha": this.senha,
      "imagem": this.imagem,
      "estado": this.estado,
    };
  }
}
