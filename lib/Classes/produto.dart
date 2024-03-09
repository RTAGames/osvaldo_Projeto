class Produto{
  String nome;
  int quantidade;
  double preco;

  Produto({this.nome = '', this.quantidade = 0, this.preco = 0});

  static Produto fromMap(item){
    return Produto(
      nome: item['nome'] ?? '',
      quantidade: item['quantidade'] ?? 0,
      preco: item['preco'] ?? 0,
    );
  }

  toMap(){
    return{
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco,
    };
  }
}