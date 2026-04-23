import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'services/carrinho_service.dart';
import 'pagamento_page.dart';

class DetalhesPage extends StatefulWidget {
  final Produto produto;
  const DetalhesPage({super.key, required this.produto});

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  int _quantidade = 1;
  final _carrinho = CarrinhoService();
  final _favoritos = FavoritosService();

  @override
  Widget build(BuildContext context) {
    final p = widget.produto;
    final total = p.preco * _quantidade;
    final fav = _favoritos.isFavorito(p.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () { setState(() => _favoritos.toggleFavorito(p)); },
                icon: Icon(fav ? Icons.favorite : Icons.favorite_outline, color: fav ? const Color(0xFFFF6B8A) : Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(p.imagemUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(p.nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)))),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('R\$ ${p.preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                          const Text('por unidade', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFDE68A))),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                          SizedBox(width: 4),
                          Text('4.8', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                        ]),
                      ),
                      const SizedBox(width: 8),
                      const Text('(128 avaliações)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(20)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                          SizedBox(width: 4),
                          Text('Em estoque', style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  const Text('Descrição', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                  const SizedBox(height: 8),
                  Text(p.descricao, style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.6)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Quantidade
                  Row(
                    children: [
                      const Text('Quantidade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E0FF)), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _quantidade > 1 ? () => setState(() => _quantidade--) : null,
                              icon: const Icon(Icons.remove, size: 18),
                              color: const Color(0xFF4F46E5),
                            ),
                            SizedBox(width: 32, child: Text('$_quantidade', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                            IconButton(
                              onPressed: () => setState(() => _quantidade++),
                              icon: const Icon(Icons.add, size: 18),
                              color: const Color(0xFF4F46E5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFF0EFFE), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE0E0FF))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total do pedido', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão adicionar ao carrinho
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _carrinho.adicionar(p, quantidade: _quantidade);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_quantidade}x ${p.nome} adicionado ao carrinho!'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF4F46E5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Adicionar ao carrinho', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4F46E5),
                        side: const BorderSide(color: Color(0xFF4F46E5), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botão comprar agora
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _carrinho.adicionar(p, quantidade: _quantidade);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PagamentoPage()));
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text('Comprar agora', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
