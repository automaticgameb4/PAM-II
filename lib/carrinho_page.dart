import 'package:flutter/material.dart';
import 'services/carrinho_service.dart';
import 'pagamento_page.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final _carrinho = CarrinhoService();

  @override
  Widget build(BuildContext context) {
    final itens = _carrinho.itens;
    final total = _carrinho.totalPreco;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        title: const Text('Meu Carrinho', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (itens.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Limpar carrinho'),
                    content: const Text('Deseja remover todos os itens?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                      TextButton(
                        onPressed: () { _carrinho.limpar(); setState(() {}); Navigator.pop(context); },
                        child: const Text('Limpar', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Limpar', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ),
        ],
      ),
      body: itens.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Carrinho vazio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Adicione produtos para continuar', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: itens.length,
                    itemBuilder: (_, i) {
                      final item = itens[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(item.produto.imagemUrl, width: 60, height: 60, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: Colors.grey.shade100, child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.produto.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text('R\$ ${item.produto.preco.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              // Controles de quantidade
                              Row(
                                children: [
                                  _BotaoQtd(
                                    icon: Icons.remove,
                                    onTap: () { _carrinho.alterarQtd(item.produto.id, item.quantidade - 1); setState(() {}); },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('${item.quantidade}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  ),
                                  _BotaoQtd(
                                    icon: Icons.add,
                                    onTap: () { _carrinho.alterarQtd(item.produto.id, item.quantidade + 1); setState(() {}); },
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () { _carrinho.remover(item.produto.id); setState(() {}); },
                                child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Rodapé com total e botão
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_carrinho.totalItens} ${_carrinho.totalItens == 1 ? "item" : "itens"}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PagamentoPage())),
                          icon: const Icon(Icons.payment),
                          label: const Text('Finalizar pedido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _BotaoQtd extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BotaoQtd({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EFFE),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0FF)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
      ),
    );
  }
}
