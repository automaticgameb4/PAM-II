import '../models/produto.dart';

class ItemCarrinho {
  final Produto produto;
  int quantidade;
  ItemCarrinho({required this.produto, this.quantidade = 1});
}

class CarrinhoService {
  static final CarrinhoService _instance = CarrinhoService._internal();
  factory CarrinhoService() => _instance;
  CarrinhoService._internal();

  final List<ItemCarrinho> _itens = [];
  List<ItemCarrinho> get itens => List.unmodifiable(_itens);

  int get totalItens => _itens.fold(0, (s, i) => s + i.quantidade);
  double get totalPreco => _itens.fold(0, (s, i) => s + i.produto.preco * i.quantidade);

  void adicionar(Produto produto, {int quantidade = 1}) {
    final idx = _itens.indexWhere((i) => i.produto.id == produto.id);
    if (idx >= 0) {
      _itens[idx].quantidade += quantidade;
    } else {
      _itens.add(ItemCarrinho(produto: produto, quantidade: quantidade));
    }
  }

  void remover(int produtoId) {
    _itens.removeWhere((i) => i.produto.id == produtoId);
  }

  void alterarQtd(int produtoId, int quantidade) {
    final idx = _itens.indexWhere((i) => i.produto.id == produtoId);
    if (idx >= 0) {
      if (quantidade <= 0) {
        _itens.removeAt(idx);
      } else {
        _itens[idx].quantidade = quantidade;
      }
    }
  }

  void limpar() => _itens.clear();
}

class FavoritosService {
  static final FavoritosService _instance = FavoritosService._internal();
  factory FavoritosService() => _instance;
  FavoritosService._internal();

  final List<Produto> _favoritos = [];
  List<Produto> get favoritos => List.unmodifiable(_favoritos);

  bool isFavorito(int produtoId) => _favoritos.any((p) => p.id == produtoId);

  void toggleFavorito(Produto produto) {
    if (isFavorito(produto.id)) {
      _favoritos.removeWhere((p) => p.id == produto.id);
    } else {
      _favoritos.add(produto);
    }
  }
}
