import 'package:flutter/material.dart';
import 'services/carrinho_service.dart';
import 'home_page.dart';

class PagamentoPage extends StatefulWidget {
  // Pagamento do carrinho completo
  const PagamentoPage({super.key});

  @override
  State<PagamentoPage> createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  int _metodoSelecionado = 0;
  final _carrinho = CarrinhoService();

  final List<Map<String, dynamic>> _metodos = [
    {'icone': Icons.pix, 'titulo': 'PIX', 'subtitulo': 'Aprovação imediata', 'cor': const Color(0xFF00B09B)},
    {'icone': Icons.credit_card, 'titulo': 'Cartão de Crédito', 'subtitulo': 'Em até 12x sem juros', 'cor': const Color(0xFF4F46E5)},
    {'icone': Icons.credit_card_outlined, 'titulo': 'Cartão de Débito', 'subtitulo': 'Débito à vista', 'cor': const Color(0xFF7C3AED)},
    {'icone': Icons.receipt_long_outlined, 'titulo': 'Boleto Bancário', 'subtitulo': 'Vencimento em 3 dias úteis', 'cor': const Color(0xFFF59E0B)},
  ];

  void _confirmar() {
    final total = _carrinho.totalPreco;
    final metodo = _metodos[_metodoSelecionado]['titulo'] as String;
    _carrinho.limpar();

    // Vai direto para home e mostra dialog lá — sem problema de context
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );

    // Agora mostra o dialog no context da nova rota via addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFFECFDF5), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 56),
              ),
              const SizedBox(height: 16),
              const Text('Pedido realizado!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Pagamento via $metodo confirmado.\nTotal: R\$ ${total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Continuar comprando', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _carrinho.totalPreco;
    final totalItens = _carrinho.totalItens;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        title: const Text('Pagamento', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EFFE),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E0FF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Resumo do pedido', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('$totalItens ${totalItens == 1 ? "item" : "itens"}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text('Escolha o pagamento', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                  const SizedBox(height: 4),
                  const Text('Selecione a forma de pagamento preferida', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),

                  ..._metodos.asMap().entries.map((e) {
                    final i = e.key;
                    final m = e.value;
                    final sel = _metodoSelecionado == i;
                    return GestureDetector(
                      onTap: () => setState(() => _metodoSelecionado = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: sel ? (m['cor'] as Color).withOpacity(0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: sel ? m['cor'] as Color : const Color(0xFFE0E0FF), width: sel ? 2 : 1),
                          boxShadow: sel ? [] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: (m['cor'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                              child: Icon(m['icone'] as IconData, color: m['cor'] as Color, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m['titulo'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: sel ? m['cor'] as Color : const Color(0xFF1E1B4B))),
                                  Text(m['subtitulo'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(
                              sel ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                              color: sel ? m['cor'] as Color : Colors.grey,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Botão confirmar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _confirmar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text('Confirmar pagamento • R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
